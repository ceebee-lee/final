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
  DateTime _focusedDay = DateTime(2024, 12, 1); // 기본 2024년 12월
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // 날짜별 이벤트 가져오기
    _events = habitProvider.dailyHabits;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red, // 기본 색상: 빨간색
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: (day) {
              final normalizedDay = DateTime(day.year, day.month, day.day);
              return _events[normalizedDay] ?? [];
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('Select a date to see habits.'))
                : _buildHabitList(context, habitProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(BuildContext context, HabitProvider provider) {
    final habits = provider.getHabitsForDate(_selectedDay!);

    if (habits.isEmpty) {
      return const Center(
        child: Text('No habits completed on this day.'),
      );
    }

    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(habits[index]),
        );
      },
    );
  }
}
