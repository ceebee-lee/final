import 'package:flutter/foundation.dart';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [];
  final Map<DateTime, List<Habit>> _history = {};

  List<Habit> get habits => _habits;

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

  List<Habit> getHistory(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _history[normalizedDate] ?? [];
  }
}
