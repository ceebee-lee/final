import 'package:flutter/foundation.dart';

class Habit {
  final String name;
  final int goalCount;
  int currentCount;

  Habit({required this.name, required this.goalCount, this.currentCount = 0});
}

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(String name, int goalCount) {
    _habits.add(Habit(name: name, goalCount: goalCount));
    notifyListeners();
  }

  void incrementHabit(int index) {
    _habits[index].currentCount++;
    notifyListeners();
  }

  void removeHabit(int index) {
    _habits.removeAt(index);
    notifyListeners();
  }
}
