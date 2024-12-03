import 'package:flutter/foundation.dart';

class Habit {
  final String name;
  final int goalCount;
  int currentCount;
  int completedCount; // 완료된 횟수

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
        completedCount++; // 목표 달성 시 완료 횟수 증가
        currentCount = 0; // 초기화
      }
    }
  }
}

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [];

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

  // 주간 통계
  Map<String, int> getWeeklyStats() {
    return {
      for (var habit in _habits) habit.name: habit.completedCount
    };
  }

  // 월간 통계 (단순히 완료 횟수로 표시)
  Map<String, int> getMonthlyStats() {
    return {
      for (var habit in _habits) habit.name: habit.completedCount * 4 // 예시로 주간 통계의 4배로 계산
    };
  }
}
