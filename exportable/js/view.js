import { appData, charts, draggedElement, calculateRunningBalance, updateSummary, populateFilters, getMonthlyData, getCategoryData, getTotals, getBalanceTrend } from './model.js';

// Rendering functions
export function renderBookmarks() {
  const grid = document.getElementById("bookmarksGrid");
  const count = appData.bookmarks.length;
  const cols = count <= 4 ? 2 : count <= 9 ? 3 : count <= 16 ? 4 : 5;
  const size = count <= 4 ? "220px" : count <= 9 ? "180px" : count <= 16 ? "140px" : "120px";

  grid.style.gridTemplateColumns = `repeat(${cols}, 1fr)`;
  grid.innerHTML = "";

  appData.bookmarks.forEach((b, i) => {
    const tile = document.createElement("div");
    tile.className = "bookmark-tile";
    tile.draggable = true;
    tile.style.minHeight = size;
    tile.innerHTML = `
      <h3>${b.name}</h3>
      <p>${b.url}</p>
      <button class="delete-btn" onclick="deleteBookmark(${i})">×</button>
    `;
    tile.onclick = (e) => {
      if (e.target.className !== "delete-btn") window.open(b.url, "_blank");
    };
    tile.ondragstart = (e) => {
      draggedElement = i;
    };
    tile.ondragover = (e) => e.preventDefault();
    tile.ondrop = (e) => {
      e.preventDefault();
      const temp = appData.bookmarks[draggedElement];
      appData.bookmarks[draggedElement] = appData.bookmarks[i];
      appData.bookmarks[i] = temp;
      renderBookmarks();
    };
    grid.appendChild(tile);
  });

  if (count < 20) {
    const addTile = document.createElement("div");
    addTile.className = "bookmark-tile add-bookmark";
    addTile.style.minHeight = size;
    addTile.innerHTML = "+";
    addTile.onclick = () => document.getElementById("bookmarkModal").classList.add("active");
    grid.appendChild(addTile);
  }
}

export function renderExpenses() {
  const tbody = document.getElementById("expenseBody");
  tbody.innerHTML = "";

  appData.expenses.forEach((exp, i) => {
    const row = tbody.insertRow();
    row.innerHTML = `
      <td><input type="date" value="${exp.date}" onchange="updateExpense(${i}, 'date', this.value)"></td>
      <td><input type="text" value="${exp.description}" onchange="updateExpense(${i}, 'description', this.value)"></td>
      <td><input type="text" value="${exp.category}" onchange="updateExpense(${i}, 'category', this.value)"></td>
      <td>
        <select onchange="updateExpense(${i}, 'type', this.value)">
          <option value="expense" ${exp.type === "expense" ? "selected" : ""}>Expense</option>
          <option value="income" ${exp.type === "income" ? "selected" : ""}>Income</option>
        </select>
      </td>
      <td><input type="number" value="${exp.amount}" onchange="updateExpense(${i}, 'amount', parseFloat(this.value))"></td>
      <td>${calculateRunningBalance(i)}</td>
      <td><button class="delete-row" onclick="deleteExpense(${i})">Delete</button></td>
    `;
  });
}

export function updateSummaryView() {
  const summary = updateSummary();
  document.getElementById("totalIncome").textContent = "₹" + summary.income.toFixed(2);
  document.getElementById("totalExpense").textContent = "₹" + summary.expense.toFixed(2);
  document.getElementById("totalBalance").textContent = "₹" + summary.balance.toFixed(2);
  document.getElementById("bankBalance").textContent = "₹" + summary.totalBalance.toFixed(2);
}

export function populateFiltersView() {
  const { months, years } = populateFilters();
  const monthSel = document.getElementById("monthFilter");
  const yearSel = document.getElementById("yearFilter");

  monthSel.innerHTML = '<option value="">All Months</option>';
  months.forEach((m, i) => {
    monthSel.innerHTML += `<option value="${i + 1}">${m}</option>`;
  });

  yearSel.innerHTML = '<option value="">All Years</option>';
  years.forEach((y) => {
    yearSel.innerHTML += `<option value="${y}">${y}</option>`;
  });
}

export function filterExpensesView() {
  const month = document.getElementById("monthFilter").value;
  const year = document.getElementById("yearFilter").value;
  const search = document.getElementById("searchFilter").value.toLowerCase();

  const rows = document.querySelectorAll("#expenseBody tr");
  rows.forEach((row, i) => {
    const exp = appData.expenses[i];
    if (!exp) return;
    const date = new Date(exp.date);
    const matchMonth = !month || date.getMonth() + 1 == month;
    const matchYear = !year || date.getFullYear() == year;
    const matchSearch = !search || exp.description.toLowerCase().includes(search) || exp.category.toLowerCase().includes(search);

    row.style.display = matchMonth && matchYear && matchSearch ? "" : "none";
  });
}

export function renderCharts() {
  const theme = document.body.getAttribute("data-theme");
  const textColor = theme === "dark" ? "#f1f5f9" : "#0f172a";
  const gridColor = theme === "dark" ? "rgba(148, 163, 184, 0.1)" : "rgba(15, 23, 42, 0.1)";

  Chart.defaults.color = textColor;
  Chart.defaults.borderColor = gridColor;

  // Monthly Trend Chart
  const monthlyData = getMonthlyData();
  if (charts.monthly) charts.monthly.destroy();
  charts.monthly = new Chart(document.getElementById("monthlyChart"), {
    type: "line",
    data: {
      labels: monthlyData.labels,
      datasets: [
        {
          label: "Income",
          data: monthlyData.income,
          borderColor: "#10b981",
          backgroundColor: "rgba(16, 185, 129, 0.1)",
          tension: 0.4,
        },
        {
          label: "Expense",
          data: monthlyData.expense,
          borderColor: "#ef4444",
          backgroundColor: "rgba(239, 68, 68, 0.1)",
          tension: 0.4,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { display: true },
      },
      scales: {
        y: { beginAtZero: true },
      },
    },
  });

  // Category Chart
  const categoryData = getCategoryData();
  if (charts.category) charts.category.destroy();
  charts.category = new Chart(document.getElementById("categoryChart"), {
    type: "doughnut",
    data: {
      labels: categoryData.labels,
      datasets: [
        {
          data: categoryData.values,
          backgroundColor: ["#3b82f6", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6", "#ec4899", "#06b6d4", "#84cc16"],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { position: "right" },
      },
    },
  });

  // Income vs Expense Chart
  const totals = getTotals();
  if (charts.incomeExpense) charts.incomeExpense.destroy();
  charts.incomeExpense = new Chart(document.getElementById("incomeExpenseChart"), {
    type: "bar",
    data: {
      labels: ["Income", "Expense", "Balance"],
      datasets: [
        {
          data: [totals.income, totals.expense, totals.balance],
          backgroundColor: ["#10b981", "#ef4444", "#3b82f6"],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { display: false },
      },
      scales: {
        y: { beginAtZero: true },
      },
    },
  });

  // Balance Trend Chart
  const balanceData = getBalanceTrend();
  if (charts.balance) charts.balance.destroy();
  charts.balance = new Chart(document.getElementById("balanceChart"), {
    type: "line",
    data: {
      labels: balanceData.labels,
      datasets: [
        {
          label: "Balance",
          data: balanceData.values,
          borderColor: "#3b82f6",
          backgroundColor: "rgba(59, 130, 246, 0.1)",
          fill: true,
          tension: 0.4,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { display: false },
      },
      scales: {
        y: { beginAtZero: false },
      },
    },
  });
}

export function showSettings() {
  document.getElementById("settingsName").value = appData.userName;
  document.getElementById("settingsWallpaper").value = appData.wallpaper;
  document.getElementById("settingsModal").classList.add("active");
}

export function closeModal(id) {
  document.getElementById(id).classList.remove("active");
}

export function previewWallpaper() {
  const url = document.getElementById("settingsWallpaper").value;
  const preview = document.getElementById("wallpaperPreview");
  if (url) {
    preview.src = url;
    preview.style.display = "block";
    preview.onerror = () => {
      preview.style.display = "none";
    };
  } else {
    preview.style.display = "none";
  }
}