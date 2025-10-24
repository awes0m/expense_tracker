// ==================== ADD BUDGET DIALOG ====================
import 'package:flutter/material.dart';

import '../controller/data_service.dart';
import '../models/budget.dart';

class AddBudgetDialog extends StatefulWidget {
  final DataService dataService;

  const AddBudgetDialog({super.key, required this.dataService});

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _limitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _limitController,
              decoration: const InputDecoration(
                labelText: 'Budget Limit',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v?.isEmpty ?? true) return 'Required';
                if (double.tryParse(v!) == null) return 'Invalid amount';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveBudget,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;

    final spent = widget.dataService.calculateCategorySpending(_categoryController.text);

    final budget = Budget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: _categoryController.text,
      limit: double.parse(_limitController.text),
      spent: spent,
    );

    await widget.dataService.addBudget(budget);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    super.dispose();
  }
}
