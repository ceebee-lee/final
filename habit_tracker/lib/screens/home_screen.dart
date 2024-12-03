import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../providers/quote_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            child: ListView.builder(
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];
                return ListTile(
                  title: Text(habit.name),
                  subtitle: Text(
                      'Progress: ${habit.currentCount}/${habit.goalCount}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          habitProvider.incrementHabit(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          habitProvider.removeHabit(index);
                        },
                      ),
                    ],
                  ),
                );
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

  void _addNewHabit(BuildContext context, HabitProvider provider) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController goalController = TextEditingController();
    final quoteProvider = QuoteProvider();

    // 동기부여 문구 가져오기
    String quote = 'Loading...';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Loading Motivation'),
          content: FutureBuilder<String>(
            future: quoteProvider.fetchRandomQuote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                quote = snapshot.data ?? 'Stay positive!';
                return Text(quote);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );

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
              const SizedBox(height: 20),
              Text(
                'Motivation:\n$quote',
                style: const TextStyle(fontStyle: FontStyle.italic),
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
}
