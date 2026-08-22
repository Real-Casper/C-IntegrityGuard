// ========== EXECUTOR FUNCTION ==========
// Executes a shell command using KernelSU and returns a Promise with the output
function exec(command) {
  return new Promise((resolve, reject) => {
    if (typeof ksu !== "object" || typeof ksu.exec !== "function") {
      reject("ksu.exec unavailable");
      return;
    }
    const cb = `cb_${Date.now()}`;
    window[cb] = (code, out, err) => {
      delete window[cb];
      code ? reject(err || "Unknown error") : resolve(out);
    };
    ksu.exec(command, "{}", cb);
  });
}

// ========== VERSION MODULE DETECTION ==========
// Reads the 'version' from /data/adb/modules/CIntegrityGuard/module.prop
async function loadVersionFromModuleProp() {
  const versionElement = document.getElementById('version-text');
  if (!versionElement) return;
  try {
    const version = await exec("grep '^version=' /data/adb/modules/CIntegrityGuard/module.prop | cut -d'=' -f2");
    versionElement.textContent = (version || "").trim() || "-";
  } catch (error) {
    console.warn("Version unavailable (no root bridge):", error);
    versionElement.textContent = "-";
  }
}

// ========== DOM INITIALIZATION ==========
document.addEventListener('DOMContentLoaded', () => {
  loadVersionFromModuleProp();
});
