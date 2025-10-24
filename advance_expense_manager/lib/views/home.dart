

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../controller/data_service.dart';
import '../models/models.dart';
import 'analytics_tab.dart';
import 'budget_tab.dart';
import 'converter_tab.dart';
import 'goals_tab.dart';
import 'transactions_tab.dart';


// ==================== HOME SCREEN ====================
class ExpenseManagerHome extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const ExpenseManagerHome({super.key, required this.onToggleTheme});

  @override
  State<ExpenseManagerHome> createState() => _ExpenseManagerHomeState();
}

class _ExpenseManagerHomeState extends State<ExpenseManagerHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DataService _dataService;
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeData();
    
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _syncData();
      }
    });
  }

  Future<void> _initializeData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _dataService = DataService(user.uid);
    await _dataService.initialize();
    
    // Initialize with sample data if empty
    if (_dataService.getTransactions().isEmpty) {
      await _addSampleData();
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _addSampleData() async {
    final now = DateTime.now();
    final sampleTransactions = [
      Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-01',
        description: 'Monthly Salary',
        category: 'Income',
        type: 'income',
        amount: 50000,
        payment: 'Bank Transfer',
      ),
      Transaction(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-05',
        description: 'Grocery Shopping',
        category: 'Food',
        type: 'expense',
        amount: 3000,
        payment: 'Credit Card',
      ),
      Transaction(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-10',
        description: 'Electricity Bill',
        category: 'Utilities',
        type: 'expense',
        amount: 1200,
        payment: 'UPI',
      ),
    ];

    for (var transaction in sampleTransactions) {
      await _dataService.addTransaction(transaction);
    }

    final sampleBudgets = [
      Budget(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: 'Food',
        limit: 5000,
        spent: 3000,
      ),
      Budget(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        category: 'Utilities',
        limit: 2000,
        spent: 1200,
      ),
    ];

    for (var budget in sampleBudgets) {
      await _dataService.addBudget(budget);
    }

    final sampleGoals = [
      Goal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Emergency Fund',
        target: 100000,
        current: 45000,
      ),
      Goal(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        name: 'Vacation Fund',
        target: 50000,
        current: 20000,
      ),
    ];

    for (var goal in sampleGoals) {
      await _dataService.addGoal(goal);
    }
  }

  Future<void> _syncData() async {
    if (_isSyncing) return;
    
    setState(() => _isSyncing = true);
    
    try {
      await _dataService.syncFromFirestore();
      await _dataService.syncUnsyncedData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Data synced successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Sync failed: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dataService.dispose();
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              const Text('Loading your data...'),
            ],
          ),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Expense Manager Pro'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long), text: 'Transactions'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.currency_exchange), text: 'Converter'),
            Tab(icon: Icon(Icons.account_balance_wallet), text: 'Budget'),
            Tab(icon: Icon(Icons.flag), text: 'Goals'),
          ],
        ),
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: _syncData,
              tooltip: 'Sync Data',
            ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'UID: ${user?.uid.substring(0, 8)}...',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TransactionsTab(dataService: _dataService),
          AnalyticsTab(dataService: _dataService),
          const ConverterTab(),
          BudgetTab(dataService: _dataService),
          GoalsTab(dataService: _dataService),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
