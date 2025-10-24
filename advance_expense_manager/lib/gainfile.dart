// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:math' as math;




// // ==================== CONVERTER TAB ====================
// class ConverterTab extends StatefulWidget {
//   const ConverterTab({super.key});

//   @override
//   State<ConverterTab> createState() => _ConverterTabState();
// }

// class _ConverterTabState extends State<ConverterTab> {
//   double currencyAmount = 100;
//   String fromCurrency = 'INR';
//   String toCurrency = 'USD';
//   double loanAmount = 500000;
//   double interestRate = 8.5;
//   int loanTerm = 5;
//   double investAmount = 100000;
//   double monthlyContribution = 5000;
//   double returnRate = 12;
//   int investYears = 10;

//   final Map<String, double> exchangeRates = {
//     'INR': 1,
//     'USD': 0.012,
//     'EUR': 0.011,
//     'GBP': 0.0095,
//     'JPY': 1.78,
//     'AUD': 0.018,
//     'CAD': 0.016,
//   };

//   double convertCurrency() {
//     final inINR = currencyAmount / exchangeRates[fromCurrency]!;
//     return inINR * exchangeRates[toCurrency]!;
//   }

//   double calculateEMI() {
//     final rate = interestRate / 100 / 12;
//     final term = loanTerm * 12;
//     if (rate == 0) return loanAmount / term;
//     return (loanAmount * rate * math.pow(1 + rate, term)) / (math.pow(1 + rate, term) - 1);
//   }

//   double calculateInvestment() {
//     final rate = returnRate / 100 / 12;
//     final months = investYears * 12;
//     return investAmount * math.pow(1 + rate, months) +
//         monthlyContribution * ((math.pow(1 + rate, months) - 1) / rate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildConverterCard(
//           title: '💱 Currency Converter',
//           icon: Icons.currency_exchange,
//           color: Colors.blue,
//           child: Column(
//             children: [
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Amount',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) =>
//                     setState(() => currencyAmount = double.tryParse(value) ?? 100),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: fromCurrency,
//                       decoration: const InputDecoration(
//                         labelText: 'From',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: exchangeRates.keys
//                           .map((currency) => DropdownMenuItem(
//                                 value: currency,
//                                 child: Text(currency),
//                               ))
//                           .toList(),
//                       onChanged: (v) => setState(() => fromCurrency = v!),
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8),
//                     child: Icon(Icons.arrow_forward),
//                   ),
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: toCurrency,
//                       decoration: const InputDecoration(
//                         labelText: 'To',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: exchangeRates.keys
//                           .map((currency) => DropdownMenuItem(
//                                 value: currency,
//                                 child: Text(currency),
//                               ))
//                           .toList(),
//                       onChanged: (v) => setState(() => toCurrency = v!),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               _buildResultBox(
//                 'Converted Amount',
//                 '$toCurrency ${convertCurrency().toStringAsFixed(2)}',
//                 Colors.green,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildConverterCard(
//           title: '🧮 Loan Calculator',
//           icon: Icons.calculate,
//           color: Colors.orange,
//           child: Column(
//             children: [
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Loan Amount (₹)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: loanAmount.toString()),
//                 onChanged: (value) =>
//                     setState(() => loanAmount = double.tryParse(value) ?? 500000),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Interest Rate (%)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: interestRate.toString()),
//                 onChanged: (value) =>
//                     setState(() => interestRate = double.tryParse(value) ?? 8.5),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Loan Term (Years)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: loanTerm.toString()),
//                 onChanged: (value) =>
//                     setState(() => loanTerm = int.tryParse(value) ?? 5),
//               ),
//               const SizedBox(height: 16),
//               _buildResultBox(
//                 'Monthly EMI',
//                 '₹${calculateEMI().toStringAsFixed(2)}',
//                 Colors.blue,
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Total Payment:'),
//                         Text(
//                           '₹${(calculateEMI() * loanTerm * 12).toStringAsFixed(2)}',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Total Interest:'),
//                         Text(
//                           '₹${((calculateEMI() * loanTerm * 12) - loanAmount).toStringAsFixed(2)}',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildConverterCard(
//           title: '💰 Investment Calculator',
//           icon: Icons.trending_up,
//           color: Colors.green,
//           child: Column(
//             children: [
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Initial Investment (₹)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: investAmount.toString()),
//                 onChanged: (value) =>
//                     setState(() => investAmount = double.tryParse(value) ?? 100000),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Monthly Contribution (₹)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: monthlyContribution.toString()),
//                 onChanged: (value) => setState(
//                     () => monthlyContribution = double.tryParse(value) ?? 5000),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Expected Return (%)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: returnRate.toString()),
//                 onChanged: (value) =>
//                     setState(() => returnRate = double.tryParse(value) ?? 12),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: 'Time Period (Years)',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: investYears.toString()),
//                 onChanged: (value) =>
//                     setState(() => investYears = int.tryParse(value) ?? 10),
//               ),
//               const SizedBox(height: 16),
//               _buildResultBox(
//                 'Future Value',
//                 '₹${calculateInvestment().toStringAsFixed(2)}',
//                 Colors.purple,
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Total Invested:'),
//                         Text(
//                           '₹${(investAmount + (monthlyContribution * investYears * 12)).toStringAsFixed(2)}',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Total Returns:'),
//                         Text(
//                           '₹${(calculateInvestment() - investAmount - (monthlyContribution * investYears * 12)).toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildConverterCard({
//     required String title,
//     required IconData icon,
//     required Color color,
//     required Widget child,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: color),
//                 const SizedBox(width: 12),
//                 Text(
//                   title,
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             child,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultBox(String label, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color, color.withOpacity(0.7)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// // ==================== ADD BUDGET DIALOG ====================
// class AddBudgetDialog extends StatefulWidget {
//   final DataService dataService;

//   const AddBudgetDialog({super.key, required this.dataService});

//   @override
//   State<AddBudgetDialog> createState() => _AddBudgetDialogState();
// }

// class _AddBudgetDialogState extends State<AddBudgetDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _categoryController = TextEditingController();
//   final _limitController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Budget'),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: _categoryController,
//               decoration: const InputDecoration(
//                 labelText: 'Category',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.category),
//               ),
//               validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _limitController,
//               decoration: const InputDecoration(
//                 labelText: 'Budget Limit',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.currency_rupee),
//               ),
//               keyboardType: TextInputType.number,
//               validator: (v) {
//                 if (v?.isEmpty ?? true) return 'Required';
//                 if (double.tryParse(v!) == null) return 'Invalid amount';
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _saveBudget,
//           child: const Text('Save'),
//         ),
//       ],
//     );
//   }

//   Future<void> _saveBudget() async {
//     if (!_formKey.currentState!.validate()) return;

//     final spent = widget.dataService.calculateCategorySpending(_categoryController.text);

//     final budget = Budget(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       category: _categoryController.text,
//       limit: double.parse(_limitController.text),
//       spent: spent,
//     );

//     await widget.dataService.addBudget(budget);
//     if (mounted) Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _categoryController.dispose();
//     _limitController.dispose();
//     super.dispose();
//   }
// }

// // ==================== GOALS TAB ====================
// class GoalsTab extends StatefulWidget {
//   final DataService dataService;

//   const GoalsTab({super.key, required this.dataService});

//   @override
//   State<GoalsTab> createState() => _GoalsTabState();
// }

// class _GoalsTabState extends State<GoalsTab> {
//   void _addGoal() {
//     showDialog(
//       context: context,
//       builder: (context) => AddGoalDialog(dataService: widget.dataService),
//     ).then((_) => setState(() {}));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final goals = widget.dataService.getGoals();

//     return Column(
//       children: [
//         Expanded(
//           child: goals.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.flag, size: 64, color: Colors.grey[400]),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No goals set',
//                         style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Create a savings goal to track your progress',
//                         style: TextStyle(color: Colors.grey[500]),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: goals.length,
//                   itemBuilder: (context, index) {
//                     final goal = goals[index];
//                     final percent = (goal.current / goal.target) * 100;

//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.withOpacity(0.2),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: const Icon(
//                                         Icons.flag,
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       goal.name,
//                                       style: const TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete, color: Colors.red),
//                                   onPressed: () => _deleteGoal(goal),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Current',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     Text(
//                                       '₹${goal.current.toStringAsFixed(2)}',
//                                       style: const TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       'Target',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     Text(
//                                       '₹${goal.target.toStringAsFixed(2)}',
//                                       style: const TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: LinearProgressIndicator(
//                                 value: (percent / 100).clamp(0.0, 1.0),
//                                 backgroundColor: Colors.grey[300],
//                                 minHeight: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   '${percent.toStringAsFixed(1)}% achieved',
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Text(
//                                   '₹${(goal.target - goal.current).toStringAsFixed(2)} to go',
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             ElevatedButton.icon(
//                               onPressed: () => _addToGoal(goal),
//                               icon: const Icon(Icons.add),
//                               label: const Text('Add Money'),
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: const Size(double.infinity, 40),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: ElevatedButton.icon(
//             onPressed: _addGoal,
//             icon: const Icon(Icons.add),
//             label: const Text('Add Goal'),
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(double.infinity, 50),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _addToGoal(Goal goal) async {
//     final controller = TextEditingController();
//     final amount = await showDialog<double>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add to Goal'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             labelText: 'Amount',
//             border: OutlineInputBorder(),
//             prefixText: '₹ ',
//           ),
//           keyboardType: TextInputType.number,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final value = double.tryParse(controller.text);
//               Navigator.pop(context, value);
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );

//     if (amount != null && amount > 0) {
//       goal.current += amount;
//       await widget.dataService.updateGoal(goal.id, goal);
//       setState(() {});
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Added ₹${amount.toStringAsFixed(2)} to ${goal.name}'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _deleteGoal(Goal goal) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Goal'),
//         content: Text('Delete goal "${goal.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await widget.dataService.deleteGoal(goal.id);
//       setState(() {});
//     }
//   }
// }

// // ==================== ADD GOAL DIALOG ====================
// class AddGoalDialog extends StatefulWidget {
//   final DataService dataService;

//   const AddGoalDialog({super.key, required this.dataService});

//   @override
//   State<AddGoalDialog> createState() => _AddGoalDialogState();
// }


// class _AddGoalDialogState extends State<AddGoalDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _targetController = TextEditingController();
//   final _currentController = TextEditingController(text: '0');

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Goal'),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Goal Name',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.flag),
//               ),
//               validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _targetController,
//               decoration: const InputDecoration(
//                 labelText: 'Target Amount',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.currency_rupee),
//               ),
//               keyboardType: TextInputType.number,
//               validator: (v) {
//                 if (v?.isEmpty ?? true) return 'Required';
//                 if (double.tryParse(v!) == null) return 'Invalid amount';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _currentController,
//               decoration: const InputDecoration(
//                 labelText: 'Current Amount',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.currency_rupee),
//               ),
//               keyboardType: TextInputType.number,
//               validator: (v) {
//                 if (v?.isEmpty ?? true) return 'Required';
//                 if (double.tryParse(v!) == null) return 'Invalid amount';
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _saveGoal,
//           child: const Text('Save'),
//         ),
//       ],
//     );
//   }

//   Future<void> _saveGoal() async {
//     if (!_formKey.currentState!.validate()) return;

//     final goal = Goal(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       name: _nameController.text,
//       target: double.parse(_targetController.text),
//       current: double.parse(_currentController.text),
//     );

//     await widget.dataService.addGoal(goal);
//     if (mounted) Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _targetController.dispose();
//     _currentController.dispose();
//     super.dispose();
//   }
// }// main.dart

// // ==================== FIREBASE CONFIGURATION ====================
// class FirebaseConfig {
//   static const firebaseOptions = FirebaseOptions(
//     apiKey: 'YOUR_API_KEY',
//     appId: 'YOUR_APP_ID',
//     messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
//     projectId: 'YOUR_PROJECT_ID',
//     storageBucket: 'YOUR_STORAGE_BUCKET',
//   );
// }

// // ==================== MAIN ====================

// // ==================== AUTH WRAPPER ====================
// class AuthWrapper extends StatelessWidget {
//   final VoidCallback onToggleTheme;
  
//   const AuthWrapper({super.key, required this.onToggleTheme});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
        
//         if (snapshot.hasData) {
//           return ExpenseManagerHome(onToggleTheme: onToggleTheme);
//         }
        
//         return const LoginPage();
//       },
//     );
//   }
// }

// // ==================== LOGIN PAGE ====================
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLogin = true;
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       if (_isLogin) {
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text,
//         );
//       } else {
//         final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text,
//         );
        
//         // Initialize user data in Firestore
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .set({
//           'email': _emailController.text.trim(),
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       String message = 'An error occurred';
//       if (e.code == 'user-not-found') {
//         message = 'No user found with this email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Wrong password provided.';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'Email already in use.';
//       } else if (e.code == 'weak-password') {
//         message = 'Password is too weak.';
//       } else if (e.code == 'invalid-email') {
//         message = 'Invalid email address.';
//       }
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Theme.of(context).primaryColor,
//               Theme.of(context).primaryColor.withOpacity(0.7),
//             ],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 400),
//                 padding: const EdgeInsets.all(32),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColor.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.account_balance_wallet,
//                           size: 64,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Text(
//                         _isLogin ? 'Welcome Back!' : 'Create Account',
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         _isLogin
//                             ? 'Sign in to continue'
//                             : 'Sign up to get started',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           prefixIcon: const Icon(Icons.email_outlined),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           if (!value.contains('@')) {
//                             return 'Please enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: const Icon(Icons.lock_outlined),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_outlined
//                                   : Icons.visibility_off_outlined,
//                             ),
//                             onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         obscureText: _obscurePassword,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           if (value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: _isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : Text(
//                                   _isLogin ? 'Login' : 'Sign Up',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextButton(
//                         onPressed: () => setState(() => _isLogin = !_isLogin),
//                         child: Text(
//                           _isLogin
//                               ? 'Don\'t have an account? Sign Up'
//                               : 'Already have an account? Login',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }

// // ==================== DATA MODELS ====================
// @HiveType(typeId: 0)
// class Transaction extends HiveObject {
//   @HiveField(0)
//   String id;
  
//   @HiveField(1)
//   String date;
  
//   @HiveField(2)
//   String description;
  
//   @HiveField(3)
//   String category;
  
//   @HiveField(4)
//   String type;
  
//   @HiveField(5)
//   double amount;
  
//   @HiveField(6)
//   String payment;
  
//   @HiveField(7)
//   bool synced;

//   Transaction({
//     required this.id,
//     required this.date,
//     required this.description,
//     required this.category,
//     required this.type,
//     required this.amount,
//     required this.payment,
//     this.synced = false,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'date': date,
//     'description': description,
//     'category': category,
//     'type': type,
//     'amount': amount,
//     'payment': payment,
//     'synced': synced,
//     'updatedAt': FieldValue.serverTimestamp(),
//   };

//   factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
//     id: json['id'],
//     date: json['date'],
//     description: json['description'],
//     category: json['category'],
//     type: json['type'],
//     amount: json['amount'].toDouble(),
//     payment: json['payment'],
//     synced: json['synced'] ?? false,
//   );
// }

// class TransactionAdapter extends TypeAdapter<Transaction> {
//   @override
//   final typeId = 0;

//   @override
//   Transaction read(BinaryReader reader) {
//     return Transaction(
//       id: reader.readString(),
//       date: reader.readString(),
//       description: reader.readString(),
//       category: reader.readString(),
//       type: reader.readString(),
//       amount: reader.readDouble(),
//       payment: reader.readString(),
//       synced: reader.readBool(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Transaction obj) {
//     writer.writeString(obj.id);
//     writer.writeString(obj.date);
//     writer.writeString(obj.description);
//     writer.writeString(obj.category);
//     writer.writeString(obj.type);
//     writer.writeDouble(obj.amount);
//     writer.writeString(obj.payment);
//     writer.writeBool(obj.synced);
//   }
// }

// @HiveType(typeId: 1)
// class Budget extends HiveObject {
//   @HiveField(0)
//   String id;
  
//   @HiveField(1)
//   String category;
  
//   @HiveField(2)
//   double limit;
  
//   @HiveField(3)
//   double spent;
  
//   @HiveField(4)
//   bool synced;

//   Budget({
//     required this.id,
//     required this.category,
//     required this.limit,
//     required this.spent,
//     this.synced = false,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'category': category,
//     'limit': limit,
//     'spent': spent,
//     'synced': synced,
//     'updatedAt': FieldValue.serverTimestamp(),
//   };

//   factory Budget.fromJson(Map<String, dynamic> json) => Budget(
//     id: json['id'],
//     category: json['category'],
//     limit: json['limit'].toDouble(),
//     spent: json['spent'].toDouble(),
//     synced: json['synced'] ?? false,
//   );
// }

// class BudgetAdapter extends TypeAdapter<Budget> {
//   @override
//   final typeId = 1;

//   @override
//   Budget read(BinaryReader reader) {
//     return Budget(
//       id: reader.readString(),
//       category: reader.readString(),
//       limit: reader.readDouble(),
//       spent: reader.readDouble(),
//       synced: reader.readBool(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Budget obj) {
//     writer.writeString(obj.id);
//     writer.writeString(obj.category);
//     writer.writeDouble(obj.limit);
//     writer.writeDouble(obj.spent);
//     writer.writeBool(obj.synced);
//   }
// }

// @HiveType(typeId: 2)
// class Goal extends HiveObject {
//   @HiveField(0)
//   String id;
  
//   @HiveField(1)
//   String name;
  
//   @HiveField(2)
//   double target;
  
//   @HiveField(3)
//   double current;
  
//   @HiveField(4)
//   bool synced;

//   Goal({
//     required this.id,
//     required this.name,
//     required this.target,
//     required this.current,
//     this.synced = false,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'target': target,
//     'current': current,
//     'synced': synced,
//     'updatedAt': FieldValue.serverTimestamp(),
//   };

//   factory Goal.fromJson(Map<String, dynamic> json) => Goal(
//     id: json['id'],
//     name: json['name'],
//     target: json['target'].toDouble(),
//     current: json['current'].toDouble(),
//     synced: json['synced'] ?? false,
//   );
// }

// class GoalAdapter extends TypeAdapter<Goal> {
//   @override
//   final typeId = 2;

//   @override
//   Goal read(BinaryReader reader) {
//     return Goal(
//       id: reader.readString(),
//       name: reader.readString(),
//       target: reader.readDouble(),
//       current: reader.readDouble(),
//       synced: reader.readBool(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Goal obj) {
//     writer.writeString(obj.id);
//     writer.writeString(obj.name);
//     writer.writeDouble(obj.target);
//     writer.writeDouble(obj.current);
//     writer.writeBool(obj.synced);
//   }
// }

// // ==================== DATA SERVICE ====================
// class DataService {
//   final String userId;
//   late Box<Transaction> _transactionsBox;
//   late Box<Budget> _budgetsBox;
//   late Box<Goal> _goalsBox;
  
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isInitialized = false;

//   DataService(this.userId);

//   Future<void> initialize() async {
//     if (_isInitialized) return;
    
//     _transactionsBox = await Hive.openBox<Transaction>('transactions_$userId');
//     _budgetsBox = await Hive.openBox<Budget>('budgets_$userId');
//     _goalsBox = await Hive.openBox<Goal>('goals_$userId');
    
//     _isInitialized = true;
    
//     // Initial sync from Firestore
//     await syncFromFirestore();
//   }

//   // Transactions
//   List<Transaction> getTransactions() {
//     return _transactionsBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
//   }

//   Future<void> addTransaction(Transaction transaction) async {
//     await _transactionsBox.put(transaction.id, transaction);
//     await _syncTransactionToFirestore(transaction);
//   }

//   Future<void> updateTransaction(String id, Transaction transaction) async {
//     await _transactionsBox.put(id, transaction);
//     await _syncTransactionToFirestore(transaction);
//   }

//   Future<void> deleteTransaction(String id) async {
//     await _transactionsBox.delete(id);
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('transactions')
//           .doc(id)
//           .delete();
//     } catch (e) {
//       print('Error deleting transaction from Firestore: $e');
//     }
//   }

//   // Budgets
//   List<Budget> getBudgets() {
//     return _budgetsBox.values.toList();
//   }

//   Future<void> addBudget(Budget budget) async {
//     await _budgetsBox.put(budget.id, budget);
//     await _syncBudgetToFirestore(budget);
//   }

//   Future<void> updateBudget(String id, Budget budget) async {
//     await _budgetsBox.put(id, budget);
//     await _syncBudgetToFirestore(budget);
//   }

//   Future<void> deleteBudget(String id) async {
//     await _budgetsBox.delete(id);
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('budgets')
//           .doc(id)
//           .delete();
//     } catch (e) {
//       print('Error deleting budget from Firestore: $e');
//     }
//   }

//   // Goals
//   List<Goal> getGoals() {
//     return _goalsBox.values.toList();
//   }

//   Future<void> addGoal(Goal goal) async {
//     await _goalsBox.put(goal.id, goal);
//     await _syncGoalToFirestore(goal);
//   }

//   Future<void> updateGoal(String id, Goal goal) async {
//     await _goalsBox.put(id, goal);
//     await _syncGoalToFirestore(goal);
//   }

//   Future<void> deleteGoal(String id) async {
//     await _goalsBox.delete(id);
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('goals')
//           .doc(id)
//           .delete();
//     } catch (e) {
//       print('Error deleting goal from Firestore: $e');
//     }
//   }

//   // Sync to Firestore
//   Future<void> _syncTransactionToFirestore(Transaction transaction) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('transactions')
//           .doc(transaction.id)
//           .set(transaction.toJson());
      
//       transaction.synced = true;
//       await _transactionsBox.put(transaction.id, transaction);
//     } catch (e) {
//       print('Error syncing transaction: $e');
//     }
//   }

//   Future<void> _syncBudgetToFirestore(Budget budget) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('budgets')
//           .doc(budget.id)
//           .set(budget.toJson());
      
//       budget.synced = true;
//       await _budgetsBox.put(budget.id, budget);
//     } catch (e) {
//       print('Error syncing budget: $e');
//     }
//   }

//   Future<void> _syncGoalToFirestore(Goal goal) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('goals')
//           .doc(goal.id)
//           .set(goal.toJson());
      
//       goal.synced = true;
//       await _goalsBox.put(goal.id, goal);
//     } catch (e) {
//       print('Error syncing goal: $e');
//     }
//   }

//   // Sync from Firestore
//   Future<void> syncFromFirestore() async {
//     try {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) return;

//       // Sync transactions
//       final transactionsSnapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('transactions')
//           .get();
      
//       for (var doc in transactionsSnapshot.docs) {
//         final transaction = Transaction.fromJson(doc.data());
//         transaction.synced = true;
//         await _transactionsBox.put(transaction.id, transaction);
//       }

//       // Sync budgets
//       final budgetsSnapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('budgets')
//           .get();
      
//       for (var doc in budgetsSnapshot.docs) {
//         final budget = Budget.fromJson(doc.data());
//         budget.synced = true;
//         await _budgetsBox.put(budget.id, budget);
//       }

//       // Sync goals
//       final goalsSnapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('goals')
//           .get();
      
//       for (var doc in goalsSnapshot.docs) {
//         final goal = Goal.fromJson(doc.data());
//         goal.synced = true;
//         await _goalsBox.put(goal.id, goal);
//       }
//     } catch (e) {
//       print('Error syncing from Firestore: $e');
//     }
//   }

//   Future<void> syncUnsyncedData() async {
//     try {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) return;

//       // Sync unsynced transactions
//       final unsyncedTransactions = _transactionsBox.values.where((t) => !t.synced).toList();
//       for (var transaction in unsyncedTransactions) {
//         await _syncTransactionToFirestore(transaction);
//       }

//       // Sync unsynced budgets
//       final unsyncedBudgets = _budgetsBox.values.where((b) => !b.synced).toList();
//       for (var budget in unsyncedBudgets) {
//         await _syncBudgetToFirestore(budget);
//       }

//       // Sync unsynced goals
//       final unsyncedGoals = _goalsBox.values.where((g) => !g.synced).toList();
//       for (var goal in unsyncedGoals) {
//         await _syncGoalToFirestore(goal);
//       }
//     } catch (e) {
//       print('Error syncing unsynced data: $e');
//     }
//   }

//   double calculateCategorySpending(String category) {
//     return _transactionsBox.values
//         .where((t) => t.type == 'expense' && t.category == category)
//         .fold(0, (sum, t) => sum + t.amount);
//   }

//   void updateBudgetSpending() {
//     for (var budget in _budgetsBox.values) {
//       budget.spent = calculateCategorySpending(budget.category);
//       _budgetsBox.put(budget.id, budget);
//       _syncBudgetToFirestore(budget);
//     }
//   }

//   Future<void> dispose() async {
//     await _transactionsBox.close();
//     await _budgetsBox.close();
//     await _goalsBox.close();
//   }
// }

// // ==================== HOME SCREEN ====================
// class ExpenseManagerHome extends StatefulWidget {
//   final VoidCallback onToggleTheme;

//   const ExpenseManagerHome({super.key, required this.onToggleTheme});

//   @override
//   State<ExpenseManagerHome> createState() => _ExpenseManagerHomeState();
// }

// class _ExpenseManagerHomeState extends State<ExpenseManagerHome> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late DataService _dataService;
//   bool _isLoading = true;
//   bool _isSyncing = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _initializeData();
    
//     // Listen to connectivity changes
//     Connectivity().onConnectivityChanged.listen((result) {
//       if (result != ConnectivityResult.none) {
//         _syncData();
//       }
//     });
//   }

//   Future<void> _initializeData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     _dataService = DataService(user.uid);
//     await _dataService.initialize();
    
//     // Initialize with sample data if empty
//     if (_dataService.getTransactions().isEmpty) {
//       await _addSampleData();
//     }
    
//     setState(() => _isLoading = false);
//   }

//   Future<void> _addSampleData() async {
//     final now = DateTime.now();
//     final sampleTransactions = [
//       Transaction(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         date: '${now.year}-${now.month.toString().padLeft(2, '0')}-01',
//         description: 'Monthly Salary',
//         category: 'Income',
//         type: 'income',
//         amount: 50000,
//         payment: 'Bank Transfer',
//       ),
//       Transaction(
//         id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
//         date: '${now.year}-${now.month.toString().padLeft(2, '0')}-05',
//         description: 'Grocery Shopping',
//         category: 'Food',
//         type: 'expense',
//         amount: 3000,
//         payment: 'Credit Card',
//       ),
//       Transaction(
//         id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
//         date: '${now.year}-${now.month.toString().padLeft(2, '0')}-10',
//         description: 'Electricity Bill',
//         category: 'Utilities',
//         type: 'expense',
//         amount: 1200,
//         payment: 'UPI',
//       ),
//     ];

//     for (var transaction in sampleTransactions) {
//       await _dataService.addTransaction(transaction);
//     }

//     final sampleBudgets = [
//       Budget(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         category: 'Food',
//         limit: 5000,
//         spent: 3000,
//       ),
//       Budget(
//         id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
//         category: 'Utilities',
//         limit: 2000,
//         spent: 1200,
//       ),
//     ];

//     for (var budget in sampleBudgets) {
//       await _dataService.addBudget(budget);
//     }

//     final sampleGoals = [
//       Goal(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         name: 'Emergency Fund',
//         target: 100000,
//         current: 45000,
//       ),
//       Goal(
//         id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
//         name: 'Vacation Fund',
//         target: 50000,
//         current: 20000,
//       ),
//     ];

//     for (var goal in sampleGoals) {
//       await _dataService.addGoal(goal);
//     }
//   }

//   Future<void> _syncData() async {
//     if (_isSyncing) return;
    
//     setState(() => _isSyncing = true);
    
//     try {
//       await _dataService.syncFromFirestore();
//       await _dataService.syncUnsyncedData();
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 12),
//                 Text('Data synced successfully!'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.error, color: Colors.white),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text('Sync failed: $e')),
//               ],
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isSyncing = false);
//     }
//   }

//   Future<void> _logout() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await _dataService.dispose();
//       await FirebaseAuth.instance.signOut();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//               ),
//               const SizedBox(height: 16),
//               const Text('Loading your data...'),
//             ],
//           ),
//         ),
//       );
//     }

//     final user = FirebaseAuth.instance.currentUser;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('💰 Expense Manager Pro'),
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           tabs: const [
//             Tab(icon: Icon(Icons.receipt_long), text: 'Transactions'),
//             Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
//             Tab(icon: Icon(Icons.currency_exchange), text: 'Converter'),
//             Tab(icon: Icon(Icons.account_balance_wallet), text: 'Budget'),
//             Tab(icon: Icon(Icons.flag), text: 'Goals'),
//           ],
//         ),
//         actions: [
//           if (_isSyncing)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//             )
//           else
//             IconButton(
//               icon: const Icon(Icons.sync),
//               onPressed: _syncData,
//               tooltip: 'Sync Data',
//             ),
//           IconButton(
//             icon: const Icon(Icons.brightness_6),
//             onPressed: widget.onToggleTheme,
//             tooltip: 'Toggle Theme',
//           ),
//           PopupMenuButton(
//             icon: CircleAvatar(
//               backgroundColor: Theme.of(context).primaryColor,
//               child: Text(
//                 user?.email?.substring(0, 1).toUpperCase() ?? 'U',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 enabled: false,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       user?.email ?? '',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'UID: ${user?.uid.substring(0, 8)}...',
//                       style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//               const PopupMenuDivider(),
//               const PopupMenuItem(
//                 value: 'logout',
//                 child: Row(
//                   children: [
//                     Icon(Icons.logout, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text('Logout', style: TextStyle(color: Colors.red)),
//                   ],
//                 ),
//               ),
//             ],
//             onSelected: (value) {
//               if (value == 'logout') _logout();
//             },
//           ),
//         ],
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           TransactionsTab(dataService: _dataService),
//           AnalyticsTab(dataService: _dataService),
//           const ConverterTab(),
//           BudgetTab(dataService: _dataService),
//           GoalsTab(dataService: _dataService),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }

// // ==================== TRANSACTIONS TAB ====================
// class TransactionsTab extends StatefulWidget {
//   final DataService dataService;

//   const TransactionsTab({super.key, required this.dataService});

//   @override
//   State<TransactionsTab> createState() => _TransactionsTabState();
// }

// class _TransactionsTabState extends State<TransactionsTab> {
//   String searchQuery = '';
//   String? selectedCategory;
//   String? selectedType;

//   double get totalIncome => widget.dataService
//       .getTransactions()
//       .where((t) => t.type == 'income')
//       .fold(0, (sum, t) => sum + t.amount);

//   double get totalExpense => widget.dataService
//       .getTransactions()
//       .where((t) => t.type == 'expense')
//       .fold(0, (sum, t) => sum + t.amount);

//   double get balance => totalIncome - totalExpense;

//   void _addTransaction() {
//     showDialog(
//       context: context,
//       builder: (context) => AddTransactionDialog(dataService: widget.dataService),
//     ).then((_) {
//       setState(() {});
//       widget.dataService.updateBudgetSpending();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final allTransactions = widget.dataService.getTransactions();
//     final categories = allTransactions.map((t) => t.category).toSet().toList();
    
//     final filteredTransactions = allTransactions.where((t) {
//       final matchesSearch = searchQuery.isEmpty ||
//           t.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
//           t.category.toLowerCase().contains(searchQuery.toLowerCase());
//       final matchesCategory = selectedCategory == null || t.category == selectedCategory;
//       final matchesType = selectedType == null || t.type == selectedType;
//       return matchesSearch && matchesCategory && matchesType;
//     }).toList();

//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildSummaryCard(
//                       'Income',
//                       totalIncome,
//                       Colors.green,
//                       Icons.trending_up,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildSummaryCard(
//                       'Expenses',
//                       totalExpense,
//                       Colors.red,
//                       Icons.trending_down,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildSummaryCard(
//                       'Balance',
//                       balance,
//                       Colors.blue,
//                       Icons.account_balance_wallet,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: '🔍 Search transactions...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   suffixIcon: searchQuery.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () => setState(() => searchQuery = ''),
//                         )
//                       : null,
//                 ),
//                 onChanged: (value) => setState(() => searchQuery = value),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: selectedCategory,
//                       decoration: InputDecoration(
//                         labelText: 'Category',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                       items: [
//                         const DropdownMenuItem(value: null, child: Text('All')),
//                         ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
//                       ],
//                       onChanged: (v) => setState(() => selectedCategory = v),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: selectedType,
//                       decoration: InputDecoration(
//                         labelText: 'Type',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       ),
//                       items: const [
//                         DropdownMenuItem(value: null, child: Text('All')),
//                         DropdownMenuItem(value: 'income', child: Text('Income')),
//                         DropdownMenuItem(value: 'expense', child: Text('Expense')),
//                       ],
//                       onChanged: (v) => setState(() => selectedType = v),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: filteredTransactions.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No transactions found',
//                         style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: filteredTransactions.length,
//                   itemBuilder: (context, index) {
//                     final t = filteredTransactions[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(12),
//                         leading: CircleAvatar(
//                           backgroundColor: t.type == 'income'
//                               ? Colors.green.withOpacity(0.2)
//                               : Colors.red.withOpacity(0.2),
//                           child: Icon(
//                             t.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
//                             color: t.type == 'income' ? Colors.green : Colors.red,
//                           ),
//                         ),
//                         title: Text(
//                           t.description,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Text('${t.category} • ${t.payment}'),
//                             Text(
//                               t.date,
//                               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                             ),
//                           ],
//                         ),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               '₹${t.amount.toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: t.type == 'income' ? Colors.green : Colors.red,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             if (!t.synced)
//                               Icon(Icons.cloud_off, size: 16, color: Colors.orange[700]),
//                           ],
//                         ),
//                         onLongPress: () => _showOptionsMenu(context, t),
//                       ),
//                     );
//                   },
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: ElevatedButton.icon(
//             onPressed: _addTransaction,
//             icon: const Icon(Icons.add),
//             label: const Text('Add Transaction'),
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(double.infinity, 50),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color, color.withOpacity(0.7)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.white70, size: 20),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//           const SizedBox(height: 4),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               '₹${amount.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showOptionsMenu(BuildContext context, Transaction transaction) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text('Edit'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _editTransaction(transaction);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text('Delete'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _deleteTransaction(transaction);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _editTransaction(Transaction transaction) {
//     showDialog(
//       context: context,
//       builder: (context) => EditTransactionDialog(
//         dataService: widget.dataService,
//         transaction: transaction,
//       ),
//     ).then((_) {
//       setState(() {});
//       widget.dataService.updateBudgetSpending();
//     });
//   }

//   Future<void> _deleteTransaction(Transaction transaction) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Transaction'),
//         content: Text('Delete "${transaction.description}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await widget.dataService.deleteTransaction(transaction.id);
//       setState(() {});
//       widget.dataService.updateBudgetSpending();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Transaction deleted'),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     }
//   }
// }

// // ==================== ADD TRANSACTION DIALOG ====================
// class AddTransactionDialog extends StatefulWidget {
//   final DataService dataService;

//   const AddTransactionDialog({super.key, required this.dataService});

//   @override
//   State<AddTransactionDialog> createState() => _AddTransactionDialogState();
// }

// class _AddTransactionDialogState extends State<AddTransactionDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _descriptionController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _categoryController = TextEditingController();

//   String _type = 'expense';
//   String _payment = 'Cash';
//   DateTime _selectedDate = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Transaction'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: const InputDecoration(
//                   labelText: 'Category',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _amountController,
//                 decoration: const InputDecoration(
//                   labelText: 'Amount',
//                   border: OutlineInputBorder(),
//                   prefixText: '₹ ',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (v) {
//                   if (v?.isEmpty ?? true) return 'Required';
//                   if (double.tryParse(v!) == null) return 'Invalid amount';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 value: _type,
//                 decoration: const InputDecoration(
//                   labelText: 'Type',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'expense', child: Text('Expense')),
//                   DropdownMenuItem(value: 'income', child: Text('Income')),
//                 ],
//                 onChanged: (v) => setState(() => _type = v!),
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 value: _payment,
//                 decoration: const InputDecoration(
//                   labelText: 'Payment Method',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'Cash', child: Text('Cash')),
//                   DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
//                   DropdownMenuItem(value: 'Debit Card', child: Text('Debit Card')),
//                   DropdownMenuItem(value: 'UPI', child: Text('UPI')),
//                   DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
//                 ],
//                 onChanged: (v) => setState(() => _payment = v!),
//               ),
//               const SizedBox(height: 12),
//               ListTile(
//                 title: const Text('Date'),
//                 subtitle: Text(
//                   '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
//                 ),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: _selectedDate,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime.now(),
//                   );
//                   if (date != null) {
//                     setState(() => _selectedDate = date);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _saveTransaction,
//           child: const Text('Save'),
//         ),
//       ],
//     );
//   }

//   Future<void> _saveTransaction() async {
//     if (!_formKey.currentState!.validate()) return;

//     final transaction = Transaction(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       date:
//           '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
//       description: _descriptionController.text,
//       category: _categoryController.text,
//       type: _type,
//       amount: double.parse(_amountController.text),
//       payment: _payment,
//     );

//     await widget.dataService.addTransaction(transaction);
//     if (mounted) Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _amountController.dispose();
//     _categoryController.dispose();
//     super.dispose();
//   }
// }

// // ==================== EDIT TRANSACTION DIALOG ====================
// class EditTransactionDialog extends StatefulWidget {
//   final DataService dataService;
//   final Transaction transaction;

//   const EditTransactionDialog({
//     super.key,
//     required this.dataService,
//     required this.transaction,
//   });

//   @override
//   State<EditTransactionDialog> createState() => _EditTransactionDialogState();
// }

// class _EditTransactionDialogState extends State<EditTransactionDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _descriptionController;
//   late TextEditingController _amountController;
//   late TextEditingController _categoryController;
//   late String _type;
//   late String _payment;

//   @override
//   void initState() {
//     super.initState();
//     _descriptionController = TextEditingController(text: widget.transaction.description);
//     _amountController = TextEditingController(text: widget.transaction.amount.toString());
//     _categoryController = TextEditingController(text: widget.transaction.category);
//     _type = widget.transaction.type;
//     _payment = widget.transaction.payment;
//     final parts = widget.transaction.date.split('-');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Edit Transaction'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: const InputDecoration(
//                   labelText: 'Category',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _amountController,
//                 decoration: const InputDecoration(
//                   labelText: 'Amount',
//                   border: OutlineInputBorder(),
//                   prefixText: '₹ ',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (v) {
//                   if (v?.isEmpty ?? true) return 'Required';
//                   if (double.tryParse(v!) == null) return 'Invalid amount';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 value: _type,
//                 decoration: const InputDecoration(
//                   labelText: 'Type',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'expense', child: Text('Expense')),
//                   DropdownMenuItem(value: 'income', child: Text('Income')),
//                 ],
//                 onChanged: (v) => setState(() => _type = v!),
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 value: _payment,
//                 decoration: const InputDecoration(
//                   labelText: 'Payment Method',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'Cash', child: Text('Cash')),
//                   DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
//                   DropdownMenuItem(value: 'Debit Card', child: Text('Debit Card')),
//                   DropdownMenuItem(value: 'UPI', child: Text('UPI')),
//                   DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
//                 ],
//                 onChanged: (v) => setState(() => _payment = v!),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _updateTransaction,
//           child: const Text('Update'),
//         ),
//       ],
//     );
//   }

//   Future<void> _updateTransaction() async {
//     if (!_formKey.currentState!.validate()) return;

//     final updatedTransaction = Transaction(
//       id: widget.transaction.id,
//       date: widget.transaction.date,
//       description: _descriptionController.text,
//       category: _categoryController.text,
//       type: _type,
//       amount: double.parse(_amountController.text),
//       payment: _payment,
//     );

//     await widget.dataService.updateTransaction(widget.transaction.id, updatedTransaction);
//     if (mounted) Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _amountController.dispose();
//     _categoryController.dispose();
//     super.dispose();
//   }
// }

// // ==================== ANALYTICS TAB ====================
// class AnalyticsTab extends StatelessWidget {
//   final DataService dataService;

//   const AnalyticsTab({super.key, required this.dataService});

//   @override
//   Widget build(BuildContext context) {
//     final transactions = dataService.getTransactions();
//     final categoryData = <String, double>{};
//     double totalExpense = 0;

//     for (var t in transactions) {
//       if (t.type == 'expense') {
//         categoryData[t.category] = (categoryData[t.category] ?? 0) + t.amount;
//         totalExpense += t.amount;
//       }
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(
//                     children: [
//                       Icon(Icons.pie_chart, color: Colors.blue),
//                       SizedBox(width: 12),
//                       Text(
//                         'Expense by Category',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   if (categoryData.isEmpty)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(32),
//                         child: Column(
//                           children: [
//                             Icon(Icons.bar_chart, size: 64, color: Colors.grey),
//                             SizedBox(height: 16),
//                             Text('No expense data available'),
//                           ],
//                         ),
//                       ),
//                     )
//                   else
//                     SizedBox(
//                       height: 300,
//                       child: PieChart(
//                         PieChartData(
//                           sections: categoryData.entries.map((e) {
//                             final colors = [
//                               Colors.blue,
//                               Colors.green,
//                               Colors.orange,
//                               Colors.red,
//                               Colors.purple,
//                               Colors.teal,
//                               Colors.pink,
//                               Colors.indigo,
//                             ];
//                             final index = categoryData.keys.toList().indexOf(e.key);
//                             final percentage = (e.value / totalExpense * 100);
//                             return PieChartSectionData(
//                               value: e.value,
//                               title: '${percentage.toStringAsFixed(1)}%',
//                               color: colors[index % colors.length],
//                               radius: 100,
//                               titleStyle: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             );
//                           }).toList(),
//                           sectionsSpace: 2,
//                           centerSpaceRadius: 40,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(
//                     children: [
//                       Icon(Icons.list, color: Colors.blue),
//                       SizedBox(width: 12),
//                       Text(
//                         'Category Breakdown',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   if (categoryData.isEmpty)
//                     const Center(child: Text('No data'))
//                   else
//                     ...categoryData.entries.map((e) {
//                       final percentage = (e.value / totalExpense * 100);
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   e.key,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Text(
//                                   '₹${e.value.toStringAsFixed(2)}',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             LinearProgressIndicator(
//                               value: percentage / 100,
//                               backgroundColor: Colors.grey[300],
//                               minHeight: 8,
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '${percentage.toStringAsFixed(1)}% of total expenses',
//                               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }