// ==================== ADD GOAL DIALOG ====================
import 'package:flutter/material.dart';

import '../controller/data_service.dart';
import '../models/goal.dart';

class AddGoalDialog extends StatefulWidget {
  final DataService dataService;

  const AddGoalDialog({super.key, required this.dataService});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}


class _AddGoalDialogState extends State<AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _currentController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Goal'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Goal Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetController,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _currentController,
              decoration: const InputDecoration(
                labelText: 'Current Amount',
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
          onPressed: _saveGoal,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    final goal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      target: double.parse(_targetController.text),
      current: double.parse(_currentController.text),
    );

    await widget.dataService.addGoal(goal);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    super.dispose();
  }
}// main.dart
