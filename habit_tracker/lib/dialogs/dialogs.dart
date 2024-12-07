import 'package:flutter/material.dart';

class AddHabitDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController goalController;
  final VoidCallback onAdd;

  const AddHabitDialog({
    super.key,
    required this.nameController,
    required this.goalController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Habit Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Goal Count'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
