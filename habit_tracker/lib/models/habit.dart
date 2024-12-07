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
