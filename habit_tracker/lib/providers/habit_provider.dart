import 'package:flutter/foundation.dart';
import 'dart:async';

class Habit {
  final String name; // 습관 이름
  final int goalCount; // 목표 횟수
  int currentCount; // 현재 진행 중인 횟수
  int completedCount; // 완료된 횟수

  Habit({
    required this.name,
    required this.goalCount,
    this.currentCount = 0,
    this.completedCount = 0,
  });

  // 진행 횟수 증가
  void increment() {
    if (currentCount < goalCount) {
      currentCount++;
      if (currentCount == goalCount) {
        completedCount++;
        currentCount = 0; // 목표 달성 후 초기화
      }
    }
  }
}

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = []; // 전체 습관 리스트
  final Map<DateTime, List<Habit>> _dailyHabits = {}; // 날짜별 습관 저장
  final Map<DateTime, List<Habit>> _history = {}; // 날짜별 습관 기록 (자정 저장)

  HabitProvider() {
    _scheduleMidnightReset(); // 자정 초기화 예약
  }

  List<Habit> get habits => _habits;

  Map<DateTime, List<Habit>> get history => _history;

  List<Habit> getHabitsForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _dailyHabits[normalizedDate] ?? [];
  }

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

  // 날짜별 습관 완료 기록 추가
  void completeHabitOnDate(DateTime date, Habit habit) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _dailyHabits.putIfAbsent(normalizedDate, () => []).add(habit);
    notifyListeners();
  }

  // 자정에 모든 습관 저장 및 초기화
  void _scheduleMidnightReset() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final duration = tomorrow.difference(now);

    Timer(duration, () {
      _saveAndResetHabits();
      _scheduleMidnightReset(); // 다음 자정 예약
    });
  }

  void _saveAndResetHabits() {
    final today = DateTime.now();
    final normalizedDate = DateTime(today.year, today.month, today.day);

    // 오늘의 습관 기록 저장
    _history[normalizedDate] = List<Habit>.from(_habits);

    // 모든 습관 초기화
    for (final habit in _habits) {
      habit.currentCount = 0;
    }

    notifyListeners();
  }
}
