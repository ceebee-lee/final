import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    final stats = _isWeekly
        ? habitProvider.getWeeklyStats()
        : habitProvider.getMonthlyStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isWeekly = true;
                  });
                },
                child: const Text('Weekly'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isWeekly = false;
                  });
                },
                child: const Text('Monthly'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: stats.isNotEmpty
                ? ListView.builder(
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      final habitName = stats.keys.elementAt(index);
                      final habitCount = stats.values.elementAt(index);

                      return ListTile(
                        title: Text(habitName),
                        subtitle: Text(
                            '${_isWeekly ? 'Weekly' : 'Monthly'} Completions: $habitCount'),
                      );
                    },
                  )
                : const Center(
                    child: Text('No statistics available yet.'),
                  ),
          ),
        ],
      ),
    );
  }
}
