import 'package:flutter/material.dart';

import '../common/transaction_dialogs.dart';
import '../controller/data_service.dart';
import '../models/transaction.dart';
// ==================== TRANSACTIONS TAB ====================
class TransactionsTab extends StatefulWidget {
  final DataService dataService;

  const TransactionsTab({super.key, required this.dataService});

  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  String searchQuery = '';
  String? selectedCategory;
  String? selectedType;

  double get totalIncome => widget.dataService
      .getTransactions()
      .where((t) => t.type == 'income')
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => widget.dataService
      .getTransactions()
      .where((t) => t.type == 'expense')
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  void _addTransaction() {
    showDialog(
      context: context,
      builder: (context) => AddTransactionDialog(dataService: widget.dataService),
    ).then((_) {
      setState(() {});
      widget.dataService.updateBudgetSpending();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allTransactions = widget.dataService.getTransactions();
    final categories = allTransactions.map((t) => t.category).toSet().toList();
    
    final filteredTransactions = allTransactions.where((t) {
      final matchesSearch = searchQuery.isEmpty ||
          t.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == null || t.category == selectedCategory;
      final matchesType = selectedType == null || t.type == selectedType;
      return matchesSearch && matchesCategory && matchesType;
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Income',
                      totalIncome,
                      Colors.green,
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Expenses',
                      totalExpense,
                      Colors.red,
                      Icons.trending_down,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Balance',
                      balance,
                      Colors.blue,
                      Icons.account_balance_wallet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: '🔍 Search transactions...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => searchQuery = ''),
                        )
                      : null,
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All')),
                        ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                      ],
                      onChanged: (v) => setState(() => selectedCategory = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('All')),
                        DropdownMenuItem(value: 'income', child: Text('Income')),
                        DropdownMenuItem(value: 'expense', child: Text('Expense')),
                      ],
                      onChanged: (v) => setState(() => selectedType = v),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredTransactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final t = filteredTransactions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: t.type == 'income'
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          child: Icon(
                            t.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                            color: t.type == 'income' ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(
                          t.description,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('${t.category} • ${t.payment}'),
                            Text(
                              t.date,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${t.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: t.type == 'income' ? Colors.green : Colors.red,
                                fontSize: 16,
                              ),
                            ),
                            if (!t.synced)
                              Icon(Icons.cloud_off, size: 16, color: Colors.orange[700]),
                          ],
                        ),
                        onLongPress: () => _showOptionsMenu(context, t),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _addTransaction,
            icon: const Icon(Icons.add),
            label: const Text('Add Transaction'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '₹${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editTransaction(transaction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteTransaction(transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editTransaction(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => EditTransactionDialog(
        dataService: widget.dataService,
        transaction: transaction,
      ),
    ).then((_) {
      setState(() {});
      widget.dataService.updateBudgetSpending();
    });
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Delete "${transaction.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.dataService.deleteTransaction(transaction.id);
      setState(() {});
      widget.dataService.updateBudgetSpending();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
