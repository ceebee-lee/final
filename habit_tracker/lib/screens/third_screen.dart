import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/habit_provider.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
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
            focusedDay: _selectedDay ?? DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
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
    // 선택된 날짜에 해당하는 습관 데이터 가져오기
    final normalizedDate =
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    final habits = provider.habits
        .where((habit) =>
            habit.lastUpdated != null &&
            DateTime(habit.lastUpdated!.year, habit.lastUpdated!.month,
                    habit.lastUpdated!.day) ==
                normalizedDate)
        .toList();

    if (habits.isEmpty) {
      return const Center(
        child: Text('No habits recorded on this day.'),
      );
    }

    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(habit.name),
            subtitle:
                Text('Progress: ${habit.currentCount}/${habit.goalCount}'),
            trailing: habit.currentCount >= habit.goalCount
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.timelapse, color: Colors.orange),
          ),
        );
      },
    );
  }
}
