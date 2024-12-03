import 'package:flutter/material.dart';
import 'habit_report_page.dart';
import 'habit_stats_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Habits', style: TextStyle(fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              // Placeholder for voice command button
            },
          ),
        ],
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  HabitCard(
                      habitName: 'Drink Water',
                      progress: '65/80 oz',
                      color: Colors.blue[100]!),
                  HabitCard(
                      habitName: 'Yoga',
                      progress: '25min/30min',
                      color: Colors.pink[100]!),
                  HabitCard(
                      habitName: 'Drink Less Beverage',
                      progress: '0/1 drink',
                      color: Colors.blue[100]!),
                  HabitCard(
                      habitName: 'Eat Breakfast',
                      progress: '1/1',
                      color: Colors.purple[100]!),
                  HabitCard(
                      habitName: 'Walk',
                      progress: '10000/10000 steps',
                      color: Colors.green[100]!),
                  HabitCard(
                      habitName: 'Run',
                      progress: '1h/1h',
                      color: Colors.orange[100]!),
                  HabitCard(
                      habitName: 'Meditation',
                      progress: '30min/30min',
                      color: Colors.blue[100]!),
                  HabitCard(
                      habitName: 'Save Money',
                      progress: '1/1',
                      color: Colors.yellow[100]!),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Stats'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HabitReportPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HabitStatsPage()),
            );
          }
        },
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final String habitName;
  final String progress;
  final Color color;

  const HabitCard(
      {super.key,
      required this.habitName,
      required this.progress,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(habitName, style: const TextStyle(fontSize: 18)),
        subtitle: Text(progress, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
