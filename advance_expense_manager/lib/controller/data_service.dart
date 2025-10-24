

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';

class DataService {
  final String userId;
  late Box<Transaction> _transactionsBox;
  late Box<Budget> _budgetsBox;
  late Box<Goal> _goalsBox;

  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  bool _isInitialized = false;

  DataService(this.userId);

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _transactionsBox = await Hive.openBox<Transaction>('transactions_$userId');
    _budgetsBox = await Hive.openBox<Budget>('budgets_$userId');
    _goalsBox = await Hive.openBox<Goal>('goals_$userId');
    
    _isInitialized = true;
    
    // Initial sync from Firestore
    await syncFromFirestore();
  }

  // Transactions
  List<Transaction> getTransactions() {
    return _transactionsBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
    await _syncTransactionToFirestore(transaction);
  }

  Future<void> updateTransaction(String id, Transaction transaction) async {
    await _transactionsBox.put(id, transaction);
    await _syncTransactionToFirestore(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionsBox.delete(id);
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting transaction from Firestore: $e');
    }
  }

  // Budgets
  List<Budget> getBudgets() {
    return _budgetsBox.values.toList();
  }

  Future<void> addBudget(Budget budget) async {
    await _budgetsBox.put(budget.id, budget);
    await _syncBudgetToFirestore(budget);
  }

  Future<void> updateBudget(String id, Budget budget) async {
    await _budgetsBox.put(id, budget);
    await _syncBudgetToFirestore(budget);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetsBox.delete(id);
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting budget from Firestore: $e');
    }
  }

  // Goals
  List<Goal> getGoals() {
    return _goalsBox.values.toList();
  }

  Future<void> addGoal(Goal goal) async {
    await _goalsBox.put(goal.id, goal);
    await _syncGoalToFirestore(goal);
  }

  Future<void> updateGoal(String id, Goal goal) async {
    await _goalsBox.put(id, goal);
    await _syncGoalToFirestore(goal);
  }

  Future<void> deleteGoal(String id) async {
    await _goalsBox.delete(id);
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting goal from Firestore: $e');
    }
  }

  // Sync to Firestore
  Future<void> _syncTransactionToFirestore(Transaction transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toJson());
      
      transaction.synced = true;
      await _transactionsBox.put(transaction.id, transaction);
    } catch (e) {
      print('Error syncing transaction: $e');
    }
  }

  Future<void> _syncBudgetToFirestore(Budget budget) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc(budget.id)
          .set(budget.toJson());
      
      budget.synced = true;
      await _budgetsBox.put(budget.id, budget);
    } catch (e) {
      print('Error syncing budget: $e');
    }
  }

  Future<void> _syncGoalToFirestore(Goal goal) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goal.id)
          .set(goal.toJson());
      
      goal.synced = true;
      await _goalsBox.put(goal.id, goal);
    } catch (e) {
      print('Error syncing goal: $e');
    }
  }

  // Sync from Firestore
  Future<void> syncFromFirestore() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) return;

      // Sync transactions
      final transactionsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .get();
      
      for (var doc in transactionsSnapshot.docs) {
        final transaction = Transaction.fromJson(doc.data());
        transaction.synced = true;
        await _transactionsBox.put(transaction.id, transaction);
      }

      // Sync budgets
      final budgetsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .get();
      
      for (var doc in budgetsSnapshot.docs) {
        final budget = Budget.fromJson(doc.data());
        budget.synced = true;
        await _budgetsBox.put(budget.id, budget);
      }

      // Sync goals
      final goalsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .get();
      
      for (var doc in goalsSnapshot.docs) {
        final goal = Goal.fromJson(doc.data());
        goal.synced = true;
        await _goalsBox.put(goal.id, goal);
      }
    } catch (e) {
      print('Error syncing from Firestore: $e');
    }
  }

  Future<void> syncUnsyncedData() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) return;

      // Sync unsynced transactions
      final unsyncedTransactions = _transactionsBox.values.where((t) => !t.synced).toList();
      for (var transaction in unsyncedTransactions) {
        await _syncTransactionToFirestore(transaction);
      }

      // Sync unsynced budgets
      final unsyncedBudgets = _budgetsBox.values.where((b) => !b.synced).toList();
      for (var budget in unsyncedBudgets) {
        await _syncBudgetToFirestore(budget);
      }

      // Sync unsynced goals
      final unsyncedGoals = _goalsBox.values.where((g) => !g.synced).toList();
      for (var goal in unsyncedGoals) {
        await _syncGoalToFirestore(goal);
      }
    } catch (e) {
      print('Error syncing unsynced data: $e');
    }
  }

  double calculateCategorySpending(String category) {
    return _transactionsBox.values
        .where((t) => t.type == 'expense' && t.category == category)
        .fold(0, (sum, t) => sum + t.amount);
  }

  void updateBudgetSpending() {
    for (var budget in _budgetsBox.values) {
      budget.spent = calculateCategorySpending(budget.category);
      _budgetsBox.put(budget.id, budget);
      _syncBudgetToFirestore(budget);
    }
  }

  Future<void> dispose() async {
    await _transactionsBox.close();
    await _budgetsBox.close();
    await _goalsBox.close();
  }
}
