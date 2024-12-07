import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/habit_provider.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  DateTime _focusedDay = DateTime.now(); // 초기 날짜: 오늘
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedDay == null
                ? const Center(
                    child: Text('Select a date to see habits.'),
                  )
                : _buildHabitList(context, habitProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(BuildContext context, HabitProvider provider) {
    final habitsForDate = provider.history[_selectedDay!] ?? [];

    if (habitsForDate.isEmpty) {
      return const Center(
        child: Text('No habits recorded on this day.'),
      );
    }

    return ListView.builder(
      itemCount: habitsForDate.length,
      itemBuilder: (context, index) {
        final habit = habitsForDate[index];
        return ListTile(
          title: Text(habit.name),
          subtitle: Text('Completed: ${habit.completedCount} times'),
        );
      },
    );
  }
}
