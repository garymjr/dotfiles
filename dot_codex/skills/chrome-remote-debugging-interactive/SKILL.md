---
name: chrome-remote-debugging-interactive
description: Connect `js_repl` directly to a user-started browser session through Chrome's new remote debugging flow and keep that browser state alive across iterations. Prefer raw Chrome DevTools Protocol over WebSocket and fall back to Puppeteer only when the local `js_repl` runtime lacks a usable WebSocket client. Use when Codex should debug or inspect a real browser profile without MCP, especially for signed-in flows, shared manual-and-agent testing, existing tabs, cookies, extensions, feature flags, or other stateful browser work where launching a fresh automation browser would lose important context.
---

# Chrome Remote Debugging Interactive

Use a persistent `js_repl` session to attach to a running browser instance through the new Chrome remote debugging flow, reuse the same tabs and profile state across iterations, and switch freely between manual browsing and agent-driven debugging. Prefer raw CDP over WebSocket first; use Puppeteer only as an environment fallback.

## Preconditions

- Enable `js_repl` before using this skill.
- Run Codex with `danger-full-access`. This workflow depends on direct browser attachment and may need a local fallback package install.
- Use Chrome 144 or newer, or another Chromium-based browser that exposes a live `DevToolsActivePort` after remote debugging is enabled.
- Start the browser yourself and keep it running. This skill connects to that browser; it does not launch its own browser by default.
- Enable remote debugging in the browser at `chrome://inspect/#remote-debugging` and approve the connection prompt when the browser asks.
- Run setup from the workspace you want to debug.
- Treat `js_repl_reset` as recovery only. Resetting the kernel destroys the persistent browser handles.

## One-Time Setup

Raw CDP needs no package install when the `js_repl` runtime already exposes `WebSocket`.

Only install a fallback if the bootstrap step tells you there is no usable WebSocket client:

```bash
test -f package.json || npm init -y
npm install puppeteer
node -e "import('puppeteer').then(() => console.log('puppeteer fallback ok')).catch((error) => { console.error(error); process.exit(1); })"
```

Repeat that fallback setup if you switch to a different workspace later.

## Connection Modes

Choose the narrowest connection mode that matches the task.

- Automatic `DevToolsActivePort` discovery: Use when you want the skill to find the live browser profile instead of assuming a specific browser location.
- Explicit `userDataDir`: Use when the browser is running with a specific user data dir and you want deterministic attachment to that exact profile.
- Legacy endpoint attach: Use `browserURL` or `browserWSEndpoint` only when you are intentionally using the older port-based remote debugging flow, Android forwarding, or a VM/host bridge.

Prefer the new flow first. It is the closest match to a real manual browser session.

## Core Workflow

1. Write a short QA inventory before testing.
2. Run the bootstrap cell once.
3. Start or confirm any local dev server in a persistent TTY session.
4. Connect to the running browser instance with the right connection mode.
5. List pages and select the tab you want to drive, or open a dedicated debug tab.
6. Keep the same browser handles alive while you iterate.
7. Reload or navigate the active tab after each code change.
8. Run functional QA with real input.
9. Run a separate visual QA pass and capture screenshots.
10. Disconnect from Chrome only when the task is actually finished.

## Bootstrap

Run this once in `js_repl`:

```javascript
var fs;
var path;
var os;
var BufferMod;
var WebSocketCtor;
var puppeteer;
var backend;
var cdpBrowser;
var browser;
var tabs = [];
var activeTabId;
var activeSessionId;

try {
  fs = await import("node:fs/promises");
  path = await import("node:path");
  os = await import("node:os");
  BufferMod = await import("node:buffer");
  WebSocketCtor = typeof WebSocket === "function" ? WebSocket : undefined;
  backend = undefined;
  console.log(
    WebSocketCtor
      ? "Raw CDP is available in this js_repl"
      : "No usable WebSocket client in this js_repl; Puppeteer fallback may be needed"
  );
} catch (error) {
  throw new Error(
    `Could not load the Node helpers needed for this skill. Original error: ${error}`
  );
}
```

Use `var` for the shared top-level handles so later `js_repl` cells can reuse them.

## Shared Helpers

Run this once after the bootstrap cell:

```javascript
var resetChromeHandles = function () {
  tabs = [];
  activeTabId = undefined;
  activeSessionId = undefined;
};

var browserIsConnected = function () {
  if (backend === "raw-cdp") {
    return !!cdpBrowser;
  }
  if (backend === "puppeteer") {
    return !!browser && (browser.connected ?? browser.isConnected?.());
  }
  return false;
};

var ensurePuppeteerFallback = async function () {
  if (puppeteer) {
    return puppeteer;
  }
  try {
    ({ default: puppeteer } = await import("puppeteer"));
    return puppeteer;
  } catch (error) {
    throw new Error(
      `This js_repl does not expose WebSocket, and Puppeteer fallback is not installed in the current workspace. Run the fallback setup first. Original error: ${error}`
    );
  }
};

var pathExists = async function (filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
};

var candidateProfileRoots = function () {
  const home = os.homedir();
  const roots = [
    path.join(home, "Library", "Application Support"),
    path.join(home, ".config"),
    process.env.LOCALAPPDATA,
    path.join(home, "AppData", "Local"),
  ];

  return Array.from(new Set(roots.filter(Boolean)));
};

var findDevToolsActivePortFiles = async function ({
  roots = candidateProfileRoots(),
  maxDepth = 3,
} = {}) {
  const matches = [];

  var walk = async function (dirPath, depth) {
    let entries;
    try {
      entries = await fs.readdir(dirPath, { withFileTypes: true });
    } catch {
      return;
    }

    for (const entry of entries) {
      const fullPath = path.join(dirPath, entry.name);

      if (entry.isFile() && entry.name === "DevToolsActivePort") {
        try {
          const stat = await fs.stat(fullPath);
          matches.push({
            filePath: fullPath,
            userDataDir: path.dirname(fullPath),
            mtimeMs: stat.mtimeMs,
          });
        } catch {
          // Skip broken candidates.
        }
        continue;
      }

      if (entry.isDirectory() && depth < maxDepth) {
        await walk(fullPath, depth + 1);
      }
    }
  };

  for (const root of roots) {
    if (await pathExists(root)) {
      await walk(root, 0);
    }
  }

  matches.sort((a, b) => b.mtimeMs - a.mtimeMs);
  return matches;
};

var readWsEndpointFromActivePortFile = async function (activePortPath) {
  const fileContent = await fs.readFile(activePortPath, "utf8");
  const [rawPort, rawPath] = fileContent
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);

  if (!rawPort || !rawPath) {
    throw new Error(`Invalid DevToolsActivePort file at ${activePortPath}`);
  }

  const port = Number.parseInt(rawPort, 10);
  if (!Number.isInteger(port) || port <= 0 || port > 65535) {
    throw new Error(`Invalid DevToolsActivePort port '${rawPort}' at ${activePortPath}`);
  }

  return `ws://127.0.0.1:${port}${rawPath}`;
};

var readWsEndpointFromUserDataDir = async function (userDataDir) {
  return await readWsEndpointFromActivePortFile(
    path.join(userDataDir, "DevToolsActivePort")
  );
};

class RawCDP {
  constructor(WebSocketCtor) {
    this.WebSocketCtor = WebSocketCtor;
    this.ws = null;
    this.id = 0;
    this.pending = new Map();
    this.handlers = new Map();
  }

  async connect(url) {
    return new Promise((resolve, reject) => {
      this.ws = new this.WebSocketCtor(url);
      this.ws.onopen = () => resolve();
      this.ws.onerror = (event) =>
        reject(new Error(`WebSocket error: ${event.message || event.type}`));
      this.ws.onmessage = (event) => {
        const msg = JSON.parse(event.data);
        if (msg.id && this.pending.has(msg.id)) {
          const { resolve, reject } = this.pending.get(msg.id);
          this.pending.delete(msg.id);
          if (msg.error) reject(new Error(msg.error.message));
          else resolve(msg.result);
          return;
        }

        if (msg.method && this.handlers.has(msg.method)) {
          for (const handler of this.handlers.get(msg.method)) {
            handler(msg.params || {}, msg);
          }
        }
      };
    });
  }

  async send(method, params = {}, sessionId) {
    const id = ++this.id;
    return await new Promise((resolve, reject) => {
      this.pending.set(id, { resolve, reject });
      const payload = { id, method, params };
      if (sessionId) payload.sessionId = sessionId;
      this.ws.send(JSON.stringify(payload));
      setTimeout(() => {
        if (this.pending.has(id)) {
          this.pending.delete(id);
          reject(new Error(`Timeout: ${method}`));
        }
      }, 10000);
    });
  }

  onEvent(method, handler) {
    if (!this.handlers.has(method)) {
      this.handlers.set(method, new Set());
    }
    const set = this.handlers.get(method);
    set.add(handler);
    return () => set.delete(handler);
  }

  waitForEvent(method, predicate = () => true, timeoutMs = 10000) {
    return new Promise((resolve, reject) => {
      const off = this.onEvent(method, (params, msg) => {
        if (!predicate(params, msg)) return;
        clearTimeout(timer);
        off();
        resolve({ params, msg });
      });
      const timer = setTimeout(() => {
        off();
        reject(new Error(`Timeout waiting for event: ${method}`));
      }, timeoutMs);
    });
  }

  close() {
    this.ws?.close();
  }
}

var connectRawCdp = async function (browserWSEndpoint) {
  if (!WebSocketCtor) {
    throw new Error("No usable WebSocket client in this js_repl");
  }
  cdpBrowser = new RawCDP(WebSocketCtor);
  await cdpBrowser.connect(browserWSEndpoint);
  browser = undefined;
  backend = "raw-cdp";
  resetChromeHandles();
};

var connectPuppeteerFallback = async function (connectOptions) {
  const pptr = await ensurePuppeteerFallback();
  browser = await pptr.connect(connectOptions);
  cdpBrowser = undefined;
  backend = "puppeteer";
  resetChromeHandles();
};

var connectChromeByAutoDiscovery = async function ({
  candidateUserDataDirs,
} = {}) {
  const roots = candidateUserDataDirs?.length
    ? candidateUserDataDirs
    : candidateProfileRoots();
  const candidates = await findDevToolsActivePortFiles({ roots });
  if (candidates.length === 0) {
    throw new Error(
      "No live DevToolsActivePort file found. Enable remote debugging in the running browser, or connect with an explicit userDataDir or browserURL."
    );
  }

  const browserWSEndpoint = await readWsEndpointFromActivePortFile(
    candidates[0].filePath
  );

  if (WebSocketCtor) {
    await connectRawCdp(browserWSEndpoint);
  } else {
    await connectPuppeteerFallback({
      browserWSEndpoint,
      defaultViewport: null,
      handleDevToolsAsPage: true,
    });
  }

  await refreshChromeTabs();
  console.log(`Connected via ${backend} using discovered DevToolsActivePort`);
};

var connectChromeByUserDataDir = async function ({
  userDataDir,
} = {}) {
  if (!userDataDir) {
    throw new Error("userDataDir is required");
  }

  const browserWSEndpoint = await readWsEndpointFromUserDataDir(userDataDir);
  if (WebSocketCtor) {
    await connectRawCdp(browserWSEndpoint);
  } else {
    await connectPuppeteerFallback({
      browserWSEndpoint,
      defaultViewport: null,
      handleDevToolsAsPage: true,
    });
  }

  await refreshChromeTabs();
  console.log(`Connected via ${backend} using ${userDataDir}`);
};

var connectChromeByBrowserURL = async function ({
  browserURL = "http://127.0.0.1:9222",
} = {}) {
  await connectPuppeteerFallback({
    browserURL,
    defaultViewport: null,
    handleDevToolsAsPage: true,
  });
  await refreshChromeTabs();
  console.log(`Connected via puppeteer fallback using ${browserURL}`);
};

var connectChromeByWSEndpoint = async function ({
  browserWSEndpoint,
  headers,
} = {}) {
  if (!browserWSEndpoint) {
    throw new Error("browserWSEndpoint is required");
  }

  if (WebSocketCtor) {
    await connectRawCdp(browserWSEndpoint);
  } else {
    await connectPuppeteerFallback({
      browserWSEndpoint,
      headers,
      defaultViewport: null,
      handleDevToolsAsPage: true,
    });
  }

  await refreshChromeTabs();
  console.log(`Connected via ${backend} using websocket endpoint`);
};

var refreshChromeTabs = async function () {
  if (!browserIsConnected()) {
    throw new Error("Browser is not connected. Run a connect helper first.");
  }

  if (backend === "raw-cdp") {
    const { targetInfos } = await cdpBrowser.send("Target.getTargets");
    tabs = targetInfos
      .filter((t) => t.type === "page" && !t.url.startsWith("chrome://"))
      .map((t, index) => ({
        id: index,
        targetId: t.targetId,
        url: t.url,
        title: t.title,
      }));
    if (activeTabId !== undefined && !tabs.find((tab) => tab.id === activeTabId)) {
      activeTabId = undefined;
      activeSessionId = undefined;
    }
  } else {
    const pages = (await browser.pages()).filter((page) => !page.isClosed());
    tabs = [];
    for (let i = 0; i < pages.length; i += 1) {
      tabs.push({
        id: i,
        page: pages[i],
        url: pages[i].url(),
        title: await pages[i].title().catch(() => ""),
      });
    }
    if (activeTabId !== undefined && !tabs.find((tab) => tab.id === activeTabId)) {
      activeTabId = undefined;
    }
  }

  if (activeTabId === undefined && tabs.length > 0) {
    activeTabId = 0;
  }
  return tabs;
};

var listChromePages = async function () {
  await refreshChromeTabs();
  const summary = tabs.map((tab) => ({
    id: tab.id,
    selected: tab.id === activeTabId,
    url: tab.url,
    title: tab.title,
  }));
  console.log(JSON.stringify(summary, null, 2));
  return summary;
};

var ensureActiveTab = async function () {
  await refreshChromeTabs();
  const tab = tabs.find((tab) => tab.id === activeTabId);
  if (!tab) {
    throw new Error("No active page is selected. Call listChromePages() first.");
  }
  return tab;
};

var selectChromePage = async function (id, { bringToFront = true } = {}) {
  await refreshChromeTabs();
  const tab = tabs.find((tab) => tab.id === id);
  if (!tab) {
    throw new Error(`No page found at index ${id}`);
  }

  activeTabId = id;
  activeSessionId = undefined;

  if (bringToFront) {
    if (backend === "raw-cdp") {
      await cdpBrowser.send("Target.activateTarget", { targetId: tab.targetId }).catch(() => {});
    } else {
      await tab.page.bringToFront().catch(() => {});
    }
  }

  console.log(`Selected page ${id}: ${tab.url}`);
  return tab;
};

var ensureActiveRawSession = async function () {
  const tab = await ensureActiveTab();
  if (backend !== "raw-cdp") {
    throw new Error("Raw CDP session requested while backend is not raw-cdp");
  }
  if (!activeSessionId) {
    const { sessionId } = await cdpBrowser.send("Target.attachToTarget", {
      targetId: tab.targetId,
      flatten: true,
    });
    activeSessionId = sessionId;
  }
  return { tab, sessionId: activeSessionId };
};

var evaluateActivePage = async function (expression) {
  if (!expression) {
    throw new Error("expression is required");
  }

  if (backend === "raw-cdp") {
    const { sessionId } = await ensureActiveRawSession();
    await cdpBrowser.send("Runtime.enable", {}, sessionId).catch(() => {});
    const result = await cdpBrowser.send(
      "Runtime.evaluate",
      {
        expression,
        returnByValue: true,
        awaitPromise: true,
      },
      sessionId
    );
    if (result.exceptionDetails) {
      throw new Error(
        result.exceptionDetails.text ||
          result.exceptionDetails.exception?.description ||
          "Runtime.evaluate failed"
      );
    }
    return result.result.value;
  }

  const tab = await ensureActiveTab();
  return await tab.page.evaluate(expression);
};

var navigateActivePage = async function (url) {
  if (!url) {
    throw new Error("url is required");
  }

  if (backend === "raw-cdp") {
    const { sessionId } = await ensureActiveRawSession();
    await cdpBrowser.send("Page.enable", {}, sessionId).catch(() => {});
    const loadEvent = cdpBrowser.waitForEvent(
      "Page.loadEventFired",
      (_params, msg) => msg.sessionId === sessionId,
      15000
    ).catch(() => null);
    const result = await cdpBrowser.send("Page.navigate", { url }, sessionId);
    if (result.loaderId) {
      await loadEvent;
    }
  } else {
    const tab = await ensureActiveTab();
    await tab.page.goto(url, { waitUntil: "domcontentloaded" });
  }

  await refreshChromeTabs();
  const tab = await ensureActiveTab();
  console.log(`Navigated page ${tab.id} to ${tab.url}`);
  return tab;
};

var reloadActivePage = async function () {
  const tab = await ensureActiveTab();
  return await navigateActivePage(tab.url);
};

var openChromePage = async function (url = "about:blank") {
  if (backend === "raw-cdp") {
    const { targetId } = await cdpBrowser.send("Target.createTarget", { url });
    await refreshChromeTabs();
    const tab = tabs.find((item) => item.targetId === targetId) || tabs.at(-1);
    activeTabId = tab?.id;
    activeSessionId = undefined;
    return tab;
  }

  const page = await browser.newPage();
  await page.goto(url, { waitUntil: "domcontentloaded" });
  await refreshChromeTabs();
  const tab = tabs.find((item) => item.page === page) || tabs.at(-1);
  activeTabId = tab?.id;
  return tab;
};

var emitActivePageJpeg = async function (options = {}) {
  if (backend === "raw-cdp") {
    const { sessionId } = await ensureActiveRawSession();
    const { data } = await cdpBrowser.send(
      "Page.captureScreenshot",
      {
        format: "jpeg",
        quality: options.quality ?? 85,
        ...options,
      },
      sessionId
    );
    await codex.emitImage({
      bytes: BufferMod.Buffer.from(data, "base64"),
      mimeType: "image/jpeg",
    });
    return;
  }

  const tab = await ensureActiveTab();
  await codex.emitImage({
    bytes: await tab.page.screenshot({
      type: "jpeg",
      quality: 85,
      ...options,
    }),
    mimeType: "image/jpeg",
  });
};

var setViewportOnActivePage = async function ({
  width,
  height,
  deviceScaleFactor = 1,
  mobile = false,
} = {}) {
  if (!width || !height) {
    throw new Error("width and height are required");
  }

  if (backend === "raw-cdp") {
    const { sessionId } = await ensureActiveRawSession();
    await cdpBrowser.send(
      "Emulation.setDeviceMetricsOverride",
      {
        width,
        height,
        deviceScaleFactor,
        mobile,
      },
      sessionId
    );
    return;
  }

  const tab = await ensureActiveTab();
  await tab.page.setViewport({
    width,
    height,
    deviceScaleFactor,
    isMobile: mobile,
  });
};

var disconnectChrome = async function () {
  if (backend === "raw-cdp") {
    cdpBrowser?.close();
    cdpBrowser = undefined;
  }
  if (backend === "puppeteer") {
    await browser?.disconnect?.();
    browser = undefined;
  }
  backend = undefined;
  resetChromeHandles();
  console.log("Disconnected from browser; browser remains running");
};
```

## Connect to Chrome

Use one of these patterns.

### Default new-flow attach

Use when you want the skill to discover the active browser session automatically. This chooses raw CDP first and falls back to Puppeteer only if `js_repl` has no usable WebSocket client:

```javascript
await connectChromeByAutoDiscovery();
await listChromePages();
```

If multiple browsers expose `DevToolsActivePort`, the helper picks the most recently updated one. Pass `candidateUserDataDirs` if you want to narrow the search:

```javascript
await connectChromeByAutoDiscovery({
  candidateUserDataDirs: [
    "/Users/me/Library/Application Support/net.imput.helium",
    "/Users/me/Library/Application Support/Google/Chrome",
  ],
});
```

### Explicit user data dir attach

Use when the browser is running from a known user data dir and you want to target that exact profile root:

```javascript
var CHROME_USER_DATA_DIR = "/absolute/path/to/browser-user-data-dir";

await connectChromeByUserDataDir({
  userDataDir: CHROME_USER_DATA_DIR,
});
await listChromePages();
```

Pass the user data dir root, not a nested profile folder like `Default` or `Profile 1`.

### Legacy port or websocket attach

Use only when you are intentionally on the older flow:

```javascript
await connectChromeByBrowserURL({
  browserURL: "http://127.0.0.1:9222",
});
```

or:

```javascript
await connectChromeByWSEndpoint({
  browserWSEndpoint: "ws://127.0.0.1:9222/devtools/browser/<id>",
});
```

## Select or Open a Page

List pages, then pick a tab:

```javascript
await listChromePages();
await selectChromePage(0);
```

Open a dedicated debug tab:

```javascript
await openChromePage("http://127.0.0.1:3000");
```

If you alternate between manual browsing and agent actions, call `listChromePages()` again before assuming the old tab order still applies.

## Iterate Without Losing Browser State

Keep the same browser instance attached whenever you can.

Reload the active tab after renderer-only changes:

```javascript
await reloadActivePage();
```

Navigate the active tab directly:

```javascript
await navigateActivePage("http://127.0.0.1:3000/settings");
```

Inspect the current page title quickly:

```javascript
await evaluateActivePage("document.title");
```

If the browser was closed or the connection dropped, reconnect with the same connect helper instead of resetting the REPL.

## QA Loop

Before signoff, keep coverage explicit:

- List the user-visible claims you intend to make.
- List the major controls, states, and view changes.
- Map each claim to at least one functional check and one visual check.
- Add at least two exploratory scenarios beyond the happy path.

For functional QA:

- Use real input through the active backend: raw CDP input events when `backend === "raw-cdp"`, or normal Puppeteer page APIs when `backend === "puppeteer"`.
- Verify the visible outcome, not just internal state.
- Recheck the core end-to-end flow after each meaningful code change.
- Spend 30-90 seconds on a short exploratory pass before signoff.

For visual QA:

- Treat visual review as separate from functional success.
- Check the initial viewport before scrolling.
- Inspect the densest realistic state, not only the empty or loading state.
- Look for clipping, overlap, illegible text, weak contrast, broken alignment, and awkward motion.
- Capture screenshots only after the UI is in the exact state you are evaluating.

## Screenshots

Emit a screenshot of the active page:

```javascript
await emitActivePageJpeg();
```

Capture a clipped region:

```javascript
await emitActivePageJpeg({
  clip: { x: 0, y: 0, width: 1280, height: 720 },
});
```

If you need reproducible screenshots or coordinate-based follow-up, prefer a dedicated debug tab and set a deterministic viewport there before capture:

```javascript
await setViewportOnActivePage({
  width: 1600,
  height: 900,
  deviceScaleFactor: 1,
});
await emitActivePageJpeg();
```

Avoid doing that on a manual tab unless you intentionally want to resize the live browsing surface.

## Dev Server

Keep local dev servers in a persistent TTY session. Do not rely on one-shot background commands from a short-lived shell.

Example:

```bash
npm start
```

Before loading a local URL in the browser, verify the port is actually responding.

## Cleanup

Disconnect from the browser when the task is done. Do not close the user's browser unless the user explicitly wants that.

If you opened throwaway tabs for debugging, close those tabs individually before disconnecting.

```javascript
await disconnectChrome();
```

## Common Failure Modes

- `This js_repl does not expose WebSocket`: Use the Puppeteer fallback setup, then reconnect.
- `Cannot find module 'puppeteer'`: Run the fallback setup in the current workspace and verify the import.
- Connection hangs or fails immediately: Confirm the browser is running, remote debugging is enabled at `chrome://inspect/#remote-debugging`, and you approved the browser permission prompt.
- No live `DevToolsActivePort` was found: The browser is either not exposing the new flow yet, the search roots are wrong for that browser, or you need to connect with an explicit `userDataDir`.
- `DevToolsActivePort` missing: You attached with the wrong `userDataDir`, Chrome is not running from that directory, or remote debugging is not active for that session.
- You connected to the wrong profile: Reconnect with `connectChromeByUserDataDir(...)` using the exact user data dir root for the intended Chrome instance.
- The active page disappeared: A manual tab close or navigation invalidated the old handle. Run `listChromePages()` and `selectChromePage(...)` again.
- Repro screenshots are inconsistent: Use a dedicated debug tab and call `setViewportOnActivePage(...)` before capture.
- `js_repl` timed out or reset: Reconnect to Chrome and recreate only the lightweight page-selection state; do not treat that as a browser bug by default.
