#!/usr/bin/env node

import { createServer } from "node:http";
import { randomBytes } from "node:crypto";
import { homedir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";
import { spawn } from "node:child_process";

const SDK_ROOT = join(homedir(), ".pi", "agent", "extensions", "vanta-mcp", "node_modules", "@modelcontextprotocol", "sdk", "dist", "esm");
const { Client } = await import(pathToFileURL(join(SDK_ROOT, "client", "index.js")).href);
const { StreamableHTTPClientTransport } = await import(pathToFileURL(join(SDK_ROOT, "client", "streamableHttp.js")).href);
const { UnauthorizedError } = await import(pathToFileURL(join(SDK_ROOT, "client", "auth.js")).href);

const ENDPOINTS = {
  us: "https://mcp.vanta.com/mcp",
  eu: "https://mcp.eu.vanta.com/mcp",
  aus: "https://mcp.aus.vanta.com/mcp",
};
const redirectPort = Number.parseInt(process.env.VANTA_MCP_REDIRECT_PORT ?? "33371", 10) || 33371;
const endpoint = process.env.VANTA_MCP_URL ?? ENDPOINTS[(process.env.VANTA_MCP_REGION ?? "us").toLowerCase()] ?? ENDPOINTS.us;
const VAULT = "Agent Runtime";
const authItemTitle = `Codex Vanta MCP OAuth (${endpoint})`;

function fail(message) {
  process.stderr.write(`${message}\n`);
  process.exitCode = 1;
}

function runOp(args, input) {
  return new Promise((resolve, reject) => {
    const child = spawn("op", args, { stdio: ["pipe", "pipe", "pipe"] });
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (chunk) => { stdout += chunk; });
    child.stderr.on("data", (chunk) => { stderr += chunk; });
    child.on("error", reject);
    child.on("close", (code) => code === 0 ? resolve(stdout) : reject(new Error(stderr.trim() || `op exited with status ${code}`)));
    if (input === undefined) child.stdin.end();
    else {
      child.stdin.write(`${input}\n`);
      child.stdin.end();
    }
  });
}

async function getAuthItem() {
  try {
    return JSON.parse(await runOp(["item", "get", authItemTitle, "--vault", VAULT, "--format", "json", "--reveal"]));
  } catch (error) {
    if (/not found|could not find|isn't an item/i.test(error.message)) return undefined;
    throw error;
  }
}

async function loadAuth() {
  const item = await getAuthItem();
  if (!item) return {};
  const password = item.fields?.find((field) => field.id === "password" || field.purpose === "PASSWORD")?.value;
  if (!password) return {};
  return JSON.parse(password);
}

async function saveAuth(auth) {
  const item = await getAuthItem();
  if (item) {
    const password = item.fields?.find((field) => field.id === "password" || field.purpose === "PASSWORD");
    if (!password) throw new Error("Vanta OAuth item is missing its concealed password field.");
    password.value = JSON.stringify(auth);
    await runOp(["item", "edit", item.id, "--vault", VAULT, "--template", "/dev/stdin"], JSON.stringify(item));
    const persisted = await loadAuth();
    if (JSON.stringify(persisted) !== JSON.stringify(auth)) {
      throw new Error("1Password did not retain the Vanta OAuth state.");
    }
    return;
  }
  const template = {
    title: authItemTitle,
    category: "PASSWORD",
    fields: [
      { id: "password", type: "CONCEALED", purpose: "PASSWORD", label: "password", value: JSON.stringify(auth) },
      { id: "notesPlain", type: "STRING", purpose: "NOTES", label: "notesPlain", value: "OAuth state for the Codex Vanta MCP adapter. Do not edit manually." },
    ],
  };
  await runOp(["item", "create", "--vault", VAULT, "--template", "/dev/stdin"], JSON.stringify(template));
}

function provider(openAuthorization) {
  let cache;
  const current = async () => (cache ??= await loadAuth());
  const patch = async (values) => {
    cache = { ...(await current()), ...values };
    await saveAuth(cache);
  };
  return {
    get redirectUrl() { return `http://127.0.0.1:${redirectPort}/callback`; },
    get clientMetadata() {
      return {
        redirect_uris: [this.redirectUrl],
        token_endpoint_auth_method: "none",
        grant_types: ["authorization_code", "refresh_token"],
        response_types: ["code"],
        client_name: "Codex Vanta MCP adapter",
      };
    },
    async state() { const state = randomBytes(16).toString("hex"); await patch({ state }); return state; },
    async expectedState() { return (await current()).state; },
    async clientInformation() { return (await current()).clientInformation; },
    async saveClientInformation(clientInformation) { await patch({ clientInformation }); },
    async tokens() { return (await current()).tokens; },
    async saveTokens(tokens) { await patch({ tokens }); },
    async saveCodeVerifier(codeVerifier) { await patch({ codeVerifier }); },
    async codeVerifier() {
      const value = (await current()).codeVerifier;
      if (!value) throw new Error("Missing Vanta OAuth verifier. Run `node scripts/vanta-mcp.mjs auth`.");
      return value;
    },
    async saveDiscoveryState(discoveryState) { await patch({ discoveryState }); },
    async discoveryState() { return (await current()).discoveryState; },
    async invalidateCredentials(scope) {
      const auth = await current();
      if (scope === "all") cache = {};
      else {
        const fields = { client: "clientInformation", tokens: "tokens", verifier: "codeVerifier", discovery: "discoveryState" };
        delete auth[fields[scope]];
        cache = auth;
      }
      await saveAuth(cache);
    },
    async redirectToAuthorization(url) { openAuthorization?.(url); },
  };
}

async function connect(authProvider) {
  const transport = new StreamableHTTPClientTransport(new URL(endpoint), { authProvider });
  const client = new Client({ name: "codex-vanta-mcp", version: "1.0.0" }, { capabilities: {} });
  await client.connect(transport);
  return { client, transport };
}

function waitForCallback(authProvider) {
  let server;
  const promise = new Promise((resolve, reject) => {
    server = createServer(async (request, response) => {
      try {
        const url = new URL(request.url ?? "/", authProvider.redirectUrl);
        if (url.pathname !== "/callback") return response.writeHead(404).end("Not found");
        if (url.searchParams.get("error")) throw new Error(`Vanta OAuth failed: ${url.searchParams.get("error")}`);
        const code = url.searchParams.get("code");
        if (!code || url.searchParams.get("state") !== await authProvider.expectedState()) throw new Error("Invalid Vanta OAuth callback.");
        response.writeHead(200, { "content-type": "text/plain" }).end("Vanta MCP authorization complete. You may close this page.");
        resolve(code);
      } catch (error) { response.writeHead(400).end(String(error.message)); reject(error); }
    }).listen(redirectPort, "127.0.0.1");
    server.on("error", reject);
  });
  return { promise, close: () => server?.close() };
}

function openBrowser(url) {
  const child = spawn(process.platform === "darwin" ? "open" : "xdg-open", [url.toString()], { detached: true, stdio: "ignore" });
  child.unref();
}

async function authenticate() {
  const authProvider = provider(openBrowser);
  const callback = waitForCallback(authProvider);
  const transport = new StreamableHTTPClientTransport(new URL(endpoint), { authProvider });
  const client = new Client({ name: "codex-vanta-mcp", version: "1.0.0" }, { capabilities: {} });
  try {
    await client.connect(transport);
    process.stdout.write("Vanta MCP is already authenticated.\n");
  } catch (error) {
    if (!(error instanceof UnauthorizedError)) throw error;
    const code = await callback.promise;
    await transport.finishAuth(code);
    process.stdout.write("Vanta MCP authentication complete.\n");
  } finally { callback.close(); await transport.close().catch(() => undefined); }
}

async function main() {
  const [action, toolName, rawArguments] = process.argv.slice(2);
  if (action === "auth") return authenticate();
  if (!["list-tools", "call"].includes(action)) throw new Error("Usage: vanta-mcp.mjs auth | list-tools | call TOOL_NAME '{...}' [--allow-write]");
  const { client, transport } = await connect(provider());
  try {
    const tools = (await client.listTools()).tools;
    if (action === "list-tools") return process.stdout.write(`${JSON.stringify(tools, null, 2)}\n`);
    const tool = tools.find((candidate) => candidate.name === toolName);
    if (!tool) throw new Error(`Unknown Vanta MCP tool: ${toolName}. Run list-tools first.`);
    const readOnly = tool.annotations?.readOnlyHint === true && tool.annotations?.destructiveHint !== true;
    if (!readOnly && !process.argv.includes("--allow-write")) throw new Error(`Refusing ${toolName}: it is not marked read-only. Obtain explicit approval and pass --allow-write.`);
    const args = rawArguments ? JSON.parse(rawArguments) : {};
    const result = await client.callTool({ name: toolName, arguments: args });
    process.stdout.write(`${JSON.stringify(result, null, 2)}\n`);
  } finally { await transport.close().catch(() => undefined); }
}

main().catch((error) => fail(error instanceof UnauthorizedError ? "Vanta MCP authentication is required. Run `node scripts/vanta-mcp.mjs auth` interactively." : error.message));
