import 'package:flutter/foundation.dart';

class Habit {
  final String name;
  final int goalCount;
  int currentCount;
  int completedCount;

  Habit({
    required this.name,
    required this.goalCount,
    this.currentCount = 0,
    this.completedCount = 0,
  });

  void increment() {
    if (currentCount < goalCount) {
      currentCount++;
      if (currentCount == goalCount) {
        completedCount++;
        currentCount = 0;
      }
    }
  }
}

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [];
  final Map<DateTime, List<String>> _dailyHabits = {};

  List<Habit> get habits => _habits;

  Map<DateTime, List<String>> get dailyHabits => _dailyHabits;

  void addHabit(String name, int goalCount) {
    _habits.add(Habit(name: name, goalCount: goalCount));
    notifyListeners();
  }

  void incrementHabit(int index) {
    _habits[index].increment();
    notifyListeners();
  }

  void removeHabit(int index) {
    _habits.removeAt(index);
    notifyListeners();
  }

  void completeHabitOnDate(DateTime date, String habitName) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _dailyHabits.putIfAbsent(normalizedDate, () => []).add(habitName);
    notifyListeners();
  }

  List<String> getHabitsForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _dailyHabits[normalizedDate] ?? [];
  }

  Map<String, int> getWeeklyStats() {
    return {for (var habit in _habits) habit.name: habit.completedCount};
  }

  Map<String, int> getMonthlyStats() {
    return {for (var habit in _habits) habit.name: habit.completedCount * 4};
  }
}
