import 'package:flutter/foundation.dart';

class HabitProvider extends ChangeNotifier {
  final List<String> _habits = [];

  List<String> get habits => _habits;

  void addHabit(String habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void removeHabit(String habit) {
    _habits.remove(habit);
    notifyListeners();
  }
}
