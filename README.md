# Expense Manager Pro

A modern, single-page personal finance dashboard built with vanilla JavaScript. Manage day-to-day transactions, visualize cash flow trends, plan budgets, set savings goals, and tap into handy financial calculators4	7all directly in your browser.

## Features

### Transactions Hub
- **Inline editing**: Add, edit, and delete income or expense rows right inside the table.
- **Type & category controls**: Toggle between `income` and `expense`, assign categories, and note payment methods.
- **Smart filters**: Slice data by month, year, category, or a free-text search across descriptions.
- **Auto summaries**: Track total income, expenses, and the net balance with live-updating summary cards.

### Financial Analytics
- **Monthly trend line chart**: Compare income vs. expense over time.
- **Category breakdown doughnut**: Understand which categories eat the biggest portion of your budget.
- **Income vs. expense bar chart**: Spot gaps between money in and money out.
- **Balance trend chart**: Follow how your running balance evolves across transactions.

### Financial Utilities
- **Currency converter**: Quick conversions between INR, USD, EUR, GBP, JPY, AUD, and CAD (static sample rates for offline use).
- **Loan calculator**: Estimate monthly EMIs with adjustable principal, interest, and tenure values.
- **Investment calculator**: Project future value based on lump-sum, recurring contributions, expected return, and duration.
- **Tax estimator**: Approximate Indian income tax liability across the old and new regimes.

### Budget Oversight
- **Category limits**: Define spending caps per category and see how much has been used.
- **Progress indicators**: Visual gauges highlight safe, warning, and over-limit spending states.
- **Dynamic syncing**: Budget spending updates automatically as you edit transactions.

### Savings Goals
- **Goal tracking**: Set targets, record current savings, and monitor completion percentages.
- **Incremental updates**: Add contributions on the fly and visualize progress with animated bars.

### Personalization & Safety Nets
- **Theme toggle**: Switch instantly between polished dark and light themes.
- **Unsaved change guardrails**: Visual save button cues plus leave-page prompts help prevent data loss.
- **Sample data**: Preloaded examples let you explore the UI immediately (clear or overwrite as you go).
- **Local data export/import**: Save your data as JSON files and reload them later without any server.

## Tech Stack

- **Frontend**: HTML5, CSS3, vanilla JavaScript (ES6+)
- **Charts**: [Chart.js](https://www.chartjs.org/) via CDN
- **Storage**: Local JSON export/import, no backend required

## Getting Started

1. **Clone or download** this repository to your machine.
2. **Open** `expense_tracker/index.html` directly in any modern browser.
3. **Start tracking**: Enter transactions, explore analytics, configure budgets, and adjust goals.

## Data Management

- **Export**: Use the `💾 Save` button to download your current data as a JSON backup.
- **Import**: Click `📂 Load` to restore data from a previously saved JSON file.
- **Privacy first**: All data lives in the browser; nothing is sent to external servers.

## Browser Compatibility

Optimized for evergreen browsers that support ES6 features:
- Chrome 61+
- Firefox 60+
- Safari 10.1+
- Edge 16+

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

Som (2025)
