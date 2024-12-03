import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: habitProvider.habits.length,
              itemBuilder: (context, index, animation) {
                final habit = habitProvider.habits[index];
                return _buildHabitTile(context, habitProvider, index, animation);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addNewHabit(context, habitProvider);
            },
            child: const Text('Add Habit'),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitTile(BuildContext context, HabitProvider provider,
      int index, Animation<double> animation) {
    final habit = provider.habits[index];

    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(habit.name),
        subtitle: Text(
            'Progress: ${habit.currentCount}/${habit.goalCount}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                provider.incrementHabit(index);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removeHabit(context, provider, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addNewHabit(BuildContext context, HabitProvider provider) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController goalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Habit Name'),
              ),
              TextField(
                controller: goalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Goal Count'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    goalController.text.isNotEmpty) {
                  provider.addHabit(
                    nameController.text,
                    int.parse(goalController.text),
                  );
                  _listKey.currentState?.insertItem(provider.habits.length - 1);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeHabit(BuildContext context, HabitProvider provider, int index) {
    final removedHabit = provider.habits[index];

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildHabitTile(
        context,
        provider,
        index,
        animation,
      ),
    );

    provider.removeHabit(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted habit: ${removedHabit.name}'),
      ),
    );
  }
}
