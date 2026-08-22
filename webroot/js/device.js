// Device Information Component
const INFO_SCRIPT_BASE = "/data/adb/modules/CIntegrityGuard/webroot/common/";

// Wait until translation data is loaded
async function waitForTranslations(timeout = 3000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    if (window.translations && Object.keys(window.translations).length > 0) {
      return;
    }
    await new Promise(r => setTimeout(r, 100));
  }
  console.warn("translations not loaded in time.");
}

// Wait for valid device-info.json response
async function waitForValidDeviceInfo(maxWait = 4000, interval = 400) {
  const start = Date.now();
  while (Date.now() - start < maxWait) {
    try {
      const res = await fetch("/json/device-info.json?ts=" + Date.now());
      if (!res.ok) throw new Error("Fetch failed");

      const data = await res.json();
      if (data.android || data.kernel || data.root) return data;
    } catch (err) {}
    await new Promise(r => setTimeout(r, interval));
  }
  throw new Error("Timeout waiting for valid device-info.json");
}

function setVal(id, text) {
  const el = document.getElementById(id);
  if (el) el.textContent = text || "-";
}

// Paint a value green/red/amber based on what it means for integrity
function setStat(id, text) {
  const el = document.getElementById(id);
  if (!el) return;
  const v = (text || "-").toString();
  el.textContent = v;
  el.classList.remove("ok", "bad", "warn");
  if (/^(OK|Installed|Active|Working|Enforcing)/i.test(v)) {
    el.classList.add("ok");
  } else if (/^(Broken|Missing|Not found|Not installed|No config)/i.test(v)) {
    el.classList.add("bad");
  } else if (/(Permissive)/i.test(v)) {
    el.classList.add("warn");
  }
}

function paintDeviceInfo(data) {
  setVal("android-version", data.android);
  setVal("kernel-version", data.kernel);
  setVal("root-type", data.root);
  setVal("dev-sign", data.romSign);
  setVal("dev-patch", data.securityPatch);
  setStat("dev-selinux", data.selinux);
  setStat("dev-tee", data.teeStatus);
  setStat("dev-keybox", data.keybox);
  setStat("dev-pif", data.pif);
  setStat("dev-hma", data.hma);
  setStat("dev-zn", data.zygiskNext);

  const fpEl = document.getElementById("dev-fp");
  if (fpEl) {
    fpEl.textContent = data.fingerprint || "-";
    fpEl.title = data.fingerprint || "";
  }
}

const INFO_IDS = ["android-version", "kernel-version", "root-type", "dev-sign",
  "dev-patch", "dev-selinux", "dev-tee", "dev-keybox", "dev-pif", "dev-hma",
  "dev-zn", "dev-fp"];

// Load device info and display it in the UI
async function loadDeviceInfo() {
  try {
    const res = await fetch("/json/device-info.json?ts=" + Date.now());
    if (!res.ok) throw new Error("Failed to fetch");
    paintDeviceInfo(await res.json());
  } catch (err) {
    console.warn("loadDeviceInfo():", err);
    INFO_IDS.forEach(id => setVal(id, "-"));
  }
}

// Run a webroot/common helper script (distinct from runScript in scriptExecutor.js)
function runInfoScript(scriptName, callback) {
  const fullPath = `${INFO_SCRIPT_BASE}${scriptName}`;
  if (typeof ksu === "object" && typeof ksu.exec === "function") {
    const cbId = `info_cb_${Date.now()}`;
    window[cbId] = () => {
      delete window[cbId];
      if (typeof callback === "function") callback();
    };
    ksu.exec(`sh '${fullPath}'`, "{}", cbId);
  } else {
    console.warn("ksu.exec not available.");
    if (typeof callback === "function") callback();
  }
}

// Setup refresh button behavior with animation
function setupRefreshButton() {
  const refreshBtn = document.getElementById("refresh-info-btn");
  if (!refreshBtn) return;

  const scriptName = refreshBtn.dataset.script || "device-info.sh";

  refreshBtn.addEventListener("click", () => {
    if (refreshBtn.disabled) return;
    refreshBtn.disabled = true;
    refreshBtn.classList.add("rotating");

    runInfoScript(scriptName, async () => {
      try {
        paintDeviceInfo(await waitForValidDeviceInfo());
      } catch (err) {
        console.warn("Could not update device info:", err);
      }
      refreshBtn.classList.remove("rotating");
      refreshBtn.disabled = false;
    });
  });
}

// Init device info on page load
window.addEventListener("DOMContentLoaded", async () => {
  await waitForTranslations();
  loadDeviceInfo();
  setupRefreshButton();
});

window.loadDeviceInfo = loadDeviceInfo;
window.runInfoScript = runInfoScript;
