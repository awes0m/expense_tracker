

// Global app data
export let appData = {
  userName: "User",
  wallpaper: "",
  bankBalance: 0,
  bookmarks: [],
  expenses: [],
  theme: "dark",
};

// Global variables
export let draggedElement = null;
export let charts = {};



// expense management functions
/**
 * Module providing global app state and utilities for a personal finance dashboard.
 *
 * Exports:
 * - appData: userName, wallpaper, bankBalance, bookmarks, expenses, theme.
 * - UI globals: draggedElement, charts.
 * - Expense ops: addExpenseRow, updateExpense, deleteExpense, filterExpenses, populateFilters.
 * - Bookmark ops: saveBookmark, deleteBookmark, swapBookmarks.
 * - Settings ops: updateBankBalance, saveSettings, toggleTheme.
 * - Metrics: calculateRunningBalance, updateSummary, getTotals, getMonthlyData, getCategoryData, getBalanceTrend.
 * - Persistence: saveLocal (download JSON), loadLocal (import JSON via FileReader).
 *
 * Notes:
 * - Amounts use parseFloat; invalid values default to 0.
 * - Dates use ISO YYYY-MM-DD.
 * - Seeds sample data if expenses are empty.
 */

/**
 * Updates an expense item at the given index.
 *
 * @param {number} index - Index of the expense item to update.
 * @param {string} field - Field of the expense item to update (e.g. "date", "description", "category", "type", "amount").
 * @param {*} value - New value for the field.
 */
export function updateExpense(index, field, value) {
  appData.expenses[index][field] = value;
}


/**
 * Deletes an expense item at the given index.
 *
 * @param {number} index - Index of the expense item to delete.
 */
export function deleteExpense(index) {
  appData.expenses.splice(index, 1);
}

/**
 * Adds a new expense item to the app state with today's date as default.
 *
 * The new item is initialized with empty description and category, and
 * default type as "expense" and amount as 0.
 *
 * Notes:
 * - Amounts use parseFloat; invalid values default to 0.
 * - Dates use ISO YYYY-MM-DD.
 * - This function does not update the UI or re-render the expense table.
 * - Call renderExpenses() to update the UI after adding a new expense item.
 */
export function addExpenseRow() {
  const today = new Date().toISOString().split("T")[0];
  appData.expenses.push({
    date: today,
    description: "",
    category: "",
    type: "expense",
    amount: 0,
  });
}



/**
 * Updates the bank balance in the app state.
 *
 * @param {number} val - New bank balance value. If not a number, the bank balance is not updated.
 */

export function updateBankBalance(val) {
  if (!isNaN(val)) {
    appData.bankBalance = val;
  }
}


// bookmark management functions

/**
 * Saves a bookmark to the app state.
 *
 * @param {string} name - Name of the bookmark.
 * @param {string} url - URL of the bookmark.
 *
 * Notes:
 * - Both name and url are required to save a bookmark.
 * - Bookmarks are stored in the app state as an array of objects with name and url keys.
 */
export function saveBookmark(name, url) {
  if (name && url) {
    appData.bookmarks.push({ name, url });
  }
}

/**
 * Deletes a bookmark from the app state at the given index.
 *
 * @param {number} index - Index of the bookmark to delete.
 */
export function deleteBookmark(index) {
  appData.bookmarks.splice(index, 1);
}

/**
 * Swaps two bookmarks in the app state at the given indices.
 *
 * @param {number} draggedIndex - Index of the dragged bookmark.
 * @param {number} targetIndex - Index of the target bookmark.
 *
 * Notes:
 * - Both indices are required and must be valid indices of the bookmarks array.
 * - This function does not perform any validation on the indices, so it is up to the caller to ensure that the indices are valid.
 */
export function swapBookmarks(draggedIndex, targetIndex) {
  const temp = appData.bookmarks[draggedIndex];
  appData.bookmarks[draggedIndex] = appData.bookmarks[targetIndex];
  appData.bookmarks[targetIndex] = temp;
}





export function saveSettings(name, wallpaper) {
  appData.userName = name || "User";
  appData.wallpaper = wallpaper;
}

/**
 * Toggles the theme of the app between dark and light mode.
 * When the current theme is dark, it will be set to light, and vice versa.
 * The theme is stored in the app state as a string.
 * The value of the theme can be accessed using the appData.theme property.
 * The theme can be set to either "dark" or "light".
 * @returns {void} - This function does not return anything.
 */
export function toggleTheme() {
  appData.theme = appData.theme === "dark" ? "light" : "dark";
}



// Data processing functions
export function calculateRunningBalance(index) {
  let balance = appData.bankBalance;
  for (let i = 0; i <= index; i++) {
    const exp = appData.expenses[i];
    if (exp.type === "income") {
      balance += parseFloat(exp.amount) || 0;
    } else {
      balance -= parseFloat(exp.amount) || 0;
    }
  }
  return "₹" + balance.toFixed(2);
}

export function updateSummary() {
  let income = 0, expense = 0;
  appData.expenses.forEach((e) => {
    if (e.type === "income") income += parseFloat(e.amount) || 0;
    else expense += parseFloat(e.amount) || 0;
  });
  return { income, expense, balance: income - expense, totalBalance: appData.bankBalance + income - expense };
}

export function populateFilters() {
  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  const years = [...new Set(appData.expenses.map((e) => new Date(e.date).getFullYear()))];
  return { months, years };
}

export function filterExpenses(month, year, search) {
  return appData.expenses.map((exp, i) => {
    const date = new Date(exp.date);
    const matchMonth = !month || date.getMonth() + 1 == month;
    const matchYear = !year || date.getFullYear() == year;
    const matchSearch = !search || exp.description.toLowerCase().includes(search) || exp.category.toLowerCase().includes(search);
    return matchMonth && matchYear && matchSearch;
  });
}

export function getMonthlyData() {
  const months = {};
  appData.expenses.forEach((e) => {
    const date = new Date(e.date);
    const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}`;
    if (!months[key]) months[key] = { income: 0, expense: 0 };
    if (e.type === "income") {
      months[key].income += parseFloat(e.amount) || 0;
    } else {
      months[key].expense += parseFloat(e.amount) || 0;
    }
  });
  const sorted = Object.keys(months).sort();
  return {
    labels: sorted.map((k) => k.substring(5) + "/" + k.substring(0, 4)),
    income: sorted.map((k) => months[k].income),
    expense: sorted.map((k) => months[k].expense),
  };
}

export function getCategoryData() {
  const categories = {};
  appData.expenses.forEach((e) => {
    if (e.type === "expense" && e.category) {
      categories[e.category] = (categories[e.category] || 0) + (parseFloat(e.amount) || 0);
    }
  });
  return {
    labels: Object.keys(categories),
    values: Object.values(categories),
  };
}

export function getTotals() {
  let income = 0, expense = 0;
  appData.expenses.forEach((e) => {
    if (e.type === "income") income += parseFloat(e.amount) || 0;
    else expense += parseFloat(e.amount) || 0;
  });
  return { income, expense, balance: income - expense };
}

export function getBalanceTrend() {
  const sorted = [...appData.expenses].sort((a, b) => new Date(a.date) - new Date(b.date));
  let balance = appData.bankBalance;
  const labels = [];
  const values = [];
  sorted.forEach((e) => {
    if (e.type === "income") {
      balance += parseFloat(e.amount) || 0;
    } else {
      balance -= parseFloat(e.amount) || 0;
    }
    labels.push(e.date);
    values.push(balance);
  });
  return { labels, values };
}

export function saveLocal() {
  const json = JSON.stringify(appData, null, 2);
  const blob = new Blob([json], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = "home-expense-data.json";
  a.click();
  alert("✅ Data saved successfully!");
}

export function loadLocal() {
  const input = document.createElement("input");
  input.type = "file";
  input.accept = ".json";
  input.onchange = (e) => {
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onload = (ev) => {
      try {
        appData = JSON.parse(ev.target.result);
        // Re-init will be handled in controller
      } catch (err) {
        alert("❌ Error loading file: " + err.message);
      }
    };
    reader.readAsText(file);
  };
  input.click();
}

/**
 * Imports bookmarks from a bookmarks.html file (standard browser export format).
 *
 * @param {string} htmlString - The HTML content of the bookmarks file.
 * @returns {Array} Array of bookmark objects with name and url.
 */
export function importBookmarksFromHTML(htmlString) {
  const parser = new DOMParser();
  const doc = parser.parseFromString(htmlString, 'text/html');
  const links = doc.querySelectorAll('a[href]');
  const bookmarks = [];
  links.forEach(link => {
    const name = link.textContent.trim();
    const url = link.href;
    if (name && url && url.startsWith('http')) {
      bookmarks.push({ name, url });
    }
  });
  return bookmarks;
}

// Initialize sample data if empty
if (appData.expenses.length === 0) {
  appData.expenses = [
    { date: "2025-09-01", description: "Salary", category: "Income", type: "income", amount: 50000 },
    { date: "2025-09-05", description: "Groceries", category: "Food", type: "expense", amount: 3000 },
    { date: "2025-09-10", description: "Electricity Bill", category: "Utilities", type: "expense", amount: 1200 },
    { date: "2025-09-15", description: "Freelance", category: "Income", type: "income", amount: 10000 },
    { date: "2025-09-20", description: "Restaurant", category: "Food", type: "expense", amount: 1500 },
    { date: "2025-10-01", description: "Salary", category: "Income", type: "income", amount: 50000 },
    { date: "2025-10-03", description: "Rent", category: "Housing", type: "expense", amount: 15000 },
  ];
  appData.bankBalance = 20000;
}