import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

type Action = "set" | "get" | "delete" | "list";

interface SecretsToolParams {
  action: Action;
  key?: string;
  value?: string;
  prefix?: string;
}

interface SecretsStoreResponse {
  ok: boolean;
  action: Action;
  key?: string;
  value?: string;
  found?: boolean;
  deleted?: boolean;
  keys?: string[];
  updated_at?: number;
}

const actionSchema = Type.Union([
  Type.Literal("set"),
  Type.Literal("get"),
  Type.Literal("delete"),
  Type.Literal("list"),
]);

export default function secretsStoreExtension(pi: ExtensionAPI) {
  const extensionDir = path.dirname(fileURLToPath(import.meta.url));
  const scriptPath = path.join(extensionDir, "secrets_store.py");
  const agentDir = process.env.PI_AGENT_DIR || process.env.PI_CODING_AGENT_DIR || process.cwd();
  const dbPath = path.join(agentDir, "secrets.sqlite3");

  pi.registerTool({
    name: "secrets_store",
    label: "Secrets Store",
    description:
      "Store and retrieve secrets from a local SQLite database. Actions: set, get, list, delete.",
    parameters: Type.Object({
      action: actionSchema,
      key: Type.Optional(Type.String({ description: "Secret key for set/get/delete actions." })),
      value: Type.Optional(Type.String({ description: "Secret value for set action." })),
      prefix: Type.Optional(Type.String({ description: "Optional key prefix filter for list action." })),
    }),

    async execute(_toolCallId, rawParams, _onUpdate, _ctx, signal) {
      const params = rawParams as SecretsToolParams;
      const validationError = validateParams(params);
      if (validationError) {
        return {
          content: [{ type: "text", text: validationError }],
          details: { ok: false },
        };
      }

      const args = ["-u", scriptPath, "--db", dbPath, "--op", params.action];
      if (params.key !== undefined) args.push("--key", params.key);
      if (params.value !== undefined) args.push("--value", params.value);
      if (params.prefix !== undefined) args.push("--prefix", params.prefix);

      const execResult = await pi.exec("python3", args, {
        signal,
        timeout: 30000,
      });

      if (execResult.code !== 0) {
        const err = (execResult.stderr || execResult.stdout || "unknown error").trim();
        return {
          content: [{ type: "text", text: `secrets_store failed: ${err} (db: ${dbPath})` }],
          details: { ok: false, exitCode: execResult.code, dbPath },
        };
      }

      let response: SecretsStoreResponse;
      try {
        response = JSON.parse(execResult.stdout) as SecretsStoreResponse;
      } catch {
        return {
          content: [{ type: "text", text: "secrets_store returned invalid JSON output." }],
          details: { ok: false },
        };
      }

      return formatToolResponse(params, response);
    },
  });
}

function validateParams(params: SecretsToolParams): string | null {
  if ((params.action === "set" || params.action === "get" || params.action === "delete") && !params.key) {
    return `action "${params.action}" requires "key".`;
  }

  if (params.action === "set" && params.value === undefined) {
    return 'action "set" requires "value".';
  }

  return null;
}

function formatToolResponse(params: SecretsToolParams, response: SecretsStoreResponse) {
  if (params.action === "set") {
    return {
      content: [{ type: "text", text: `Saved secret "${response.key ?? params.key}".` }],
      details: {
        ok: true,
        action: "set",
        key: response.key ?? params.key,
        updatedAt: response.updated_at,
      },
    };
  }

  if (params.action === "get") {
    if (!response.found) {
      return {
        content: [{ type: "text", text: `Secret "${params.key}" was not found.` }],
        details: { ok: true, action: "get", key: params.key, found: false },
      };
    }

    return {
      content: [{ type: "text", text: response.value ?? "" }],
      details: { ok: true, action: "get", key: response.key ?? params.key, found: true },
    };
  }

  if (params.action === "delete") {
    if (response.deleted) {
      return {
        content: [{ type: "text", text: `Deleted secret "${params.key}".` }],
        details: { ok: true, action: "delete", key: params.key, deleted: true },
      };
    }

    return {
      content: [{ type: "text", text: `Secret "${params.key}" did not exist.` }],
      details: { ok: true, action: "delete", key: params.key, deleted: false },
    };
  }

  const keys = response.keys ?? [];
  if (keys.length == 0) {
    return {
      content: [{ type: "text", text: "No secrets found." }],
      details: { ok: true, action: "list", count: 0, keys: [] },
    };
  }

  const lines = keys.map((key) => `- ${key}`);
  return {
    content: [{ type: "text", text: `Secrets (${keys.length}):\n${lines.join("\n")}` }],
    details: { ok: true, action: "list", count: keys.length, keys },
  };
}
