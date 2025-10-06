import { appData, draggedElement, updateExpense, deleteExpense, addExpenseRow, saveBookmark, deleteBookmark, swapBookmarks, updateBankBalance, saveSettings, toggleTheme, saveLocal, loadLocal, importBookmarksFromHTML } from './model.js';
import { renderBookmarks, renderExpenses, updateSummaryView, populateFiltersView, filterExpensesView, renderCharts, showSettings, closeModal, previewWallpaper } from './view.js';

// Initialization
export function init() {
  renderBookmarks();
  renderExpenses();
  updateSummaryView();
  populateFiltersView();
  renderCharts();
  document.getElementById("userName").textContent = appData.userName;
  if (appData.wallpaper) {
    document.getElementById("appContainer").style.backgroundImage = `url(${appData.wallpaper})`;
  }
  if (appData.theme) {
    document.body.setAttribute("data-theme", appData.theme);
  }
}

// Event handlers
export function switchTab(tab) {
  document.querySelectorAll(".tab").forEach((t) => t.classList.remove("active"));
  document.querySelectorAll(".page").forEach((p) => p.classList.remove("active"));
  event.target.classList.add("active");
  document.getElementById(tab + "Page").classList.add("active");
  if (tab === "expense") {
    renderCharts();
  }
}

export function toggleThemeHandler() {
  toggleTheme();
  document.body.setAttribute("data-theme", appData.theme);
  renderCharts();
}

export function showSettingsHandler() {
  showSettings();
}

export function saveSettingsHandler() {
  const name = document.getElementById("settingsName").value;
  const wallpaper = document.getElementById("settingsWallpaper").value;
  saveSettings(name, wallpaper);
  document.getElementById("userName").textContent = appData.userName;
  if (appData.wallpaper) {
    document.getElementById("appContainer").style.backgroundImage = `url(${appData.wallpaper})`;
  } else {
    document.getElementById("appContainer").style.backgroundImage = "";
  }
  closeModal("settingsModal");
}

export function closeModalHandler(id) {
  closeModal(id);
}

export function updateBankBalanceHandler() {
  const val = parseFloat(document.getElementById("bankInput").value);
  updateBankBalance(val);
  updateSummaryView();
  renderExpenses();
  document.getElementById("bankInput").value = "";
}

export function saveBookmarkHandler() {
  const name = document.getElementById("bookmarkName").value;
  const url = document.getElementById("bookmarkUrl").value;
  saveBookmark(name, url);
  renderBookmarks();
  document.getElementById("bookmarkName").value = "";
  document.getElementById("bookmarkUrl").value = "";
  closeModal("bookmarkModal");
}

export function deleteBookmarkHandler(index) {
  deleteBookmark(index);
  renderBookmarks();
}

export function addExpenseRowHandler() {
  addExpenseRow();
  renderExpenses();
  updateSummaryView();
  renderCharts();
}

export function updateExpenseHandler(index, field, value) {
  updateExpense(index, field, value);
  renderExpenses();
  updateSummaryView();
  renderCharts();
}

export function deleteExpenseHandler(index) {
  deleteExpense(index);
  renderExpenses();
  updateSummaryView();
  renderCharts();
}

export function filterExpensesHandler() {
  filterExpensesView();
}

export function saveLocalHandler() {
  saveLocal();
}

export function loadLocalHandler() {
  loadLocal();
  // After loading, re-init
  setTimeout(init, 100); // Small delay to ensure file is read
}

export function importBookmarksHandler() {
  const input = document.createElement("input");
  input.type = "file";
  input.accept = ".html,.htm";
  input.onchange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (ev) => {
        const htmlString = ev.target.result;
        const bookmarks = importBookmarksFromHTML(htmlString);
        if (bookmarks.length > 0) {
          appData.bookmarks = [...appData.bookmarks, ...bookmarks];
          renderBookmarks();
          alert(`✅ Imported ${bookmarks.length} bookmarks!`);
        } else {
          alert("❌ No valid bookmarks found in the file.");
        }
      };
      reader.readAsText(file);
    }
  };
  input.click();
}

// Attach to window for global access
window.switchTab = switchTab;
window.toggleTheme = toggleThemeHandler;
window.showSettings = showSettingsHandler;
window.saveSettings = saveSettingsHandler;
window.closeModal = closeModalHandler;
window.updateBankBalance = updateBankBalanceHandler;
window.saveBookmark = saveBookmarkHandler;
window.deleteBookmark = deleteBookmarkHandler;
window.addExpenseRow = addExpenseRowHandler;
window.updateExpense = updateExpenseHandler;
window.deleteExpense = deleteExpenseHandler;
window.filterExpenses = filterExpensesHandler;
window.saveLocal = saveLocalHandler;
window.loadLocal = loadLocalHandler;
window.importBookmarks = importBookmarksHandler;
window.previewWallpaper = previewWallpaper;

// Initialize on load
window.addEventListener('DOMContentLoaded', init);