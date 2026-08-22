// Main Application Entry Point
// This file orchestrates the loading of all components and utilities

document.addEventListener("DOMContentLoaded", () => {
  console.log("main.js active");

  const CORE_BASE = "/data/adb/modules/CIntegrityGuard/Core/";
  const COMMON_BASE = "/data/adb/modules/CIntegrityGuard/webroot/common/";

  // Route each data-script to the right folder:
  //   "name.sh"                 -> /Core/name.sh
  //   "webroot/common/name.sh"  -> /webroot/common/name.sh
  const resolveScript = (s) => s.startsWith("webroot/common/")
    ? COMMON_BASE + s.slice("webroot/common/".length)
    : CORE_BASE + s;

  // Register click events for buttons in Actions Page
  document.querySelectorAll("#actions-page [data-script]").forEach(button => {
    const scriptName = button.dataset.script;
    if (!scriptName) return;
    const full = resolveScript(scriptName);
    const folder = full.slice(0, full.lastIndexOf("/") + 1);
    const file = full.slice(full.lastIndexOf("/") + 1);
    button.addEventListener("click", () => runScript(file, folder, button));
  });

  // Register click events for buttons in Advanced Menu Page
  document.querySelectorAll("#advance-menu [data-script]").forEach(button => {
    const scriptName = button.dataset.script;
    if (!scriptName) return;
    const full = resolveScript(scriptName);
    const folder = full.slice(0, full.lastIndexOf("/") + 1);
    const file = full.slice(full.lastIndexOf("/") + 1);
    button.addEventListener("click", () => runScript(file, folder, button));
  });

  const historyCard = document.getElementById("module-version-card");
  const historyDialog = document.getElementById("script-history-dialog");
  const historyOverlay = document.getElementById("script-history-overlay");
  const historyCloseBtn = document.getElementById("script-history-close");
  const historyClearBtn = document.getElementById("script-history-clear");

  historyCard?.addEventListener("click", openHistoryDialog);
  historyCloseBtn?.addEventListener("click", closeHistoryDialog);
  historyOverlay?.addEventListener("click", closeHistoryDialog);
  historyDialog?.addEventListener("close", () => historyOverlay?.classList.remove("active"));
  historyClearBtn?.addEventListener("click", () => {
    writeHistory([]);
    renderHistoryDialog();
  });

  // Refresh info button event
  const refreshBtn = document.getElementById("refresh-info-btn");
  if (refreshBtn) {
    refreshBtn.addEventListener("click", () => {
      showToast(t("home_refreshing"), "info");
      updateNetworkStatus();
      if (window.loadDeviceInfo) {
        window.loadDeviceInfo();
      }
    });
  }
});
