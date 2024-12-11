class Habit {
  final String name;
  final int goalCount;
  int currentCount;
  int completedCount;
  DateTime? lastUpdated; // 마지막 업데이트 시간

  Habit({
    required this.name,
    required this.goalCount,
    this.currentCount = 0,
    this.completedCount = 0,
    this.lastUpdated,
  });

  void increment() {
    if (currentCount < goalCount) {
      currentCount++;
      lastUpdated = DateTime.now(); // 업데이트 시간 설정
      if (currentCount == goalCount) {
        completedCount++;
        currentCount = 0;
      }
    }
  }
}
