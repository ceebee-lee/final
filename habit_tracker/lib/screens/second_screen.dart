import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/habit_provider.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final habits = habitProvider.habits;

    final List<Color> barColors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Completion Stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            habits.isEmpty
                ? const Center(
                    child: Text('No habits available to display stats.'),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0), // 그래프 위치 조정
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: habits.isNotEmpty
                              ? habits
                                      .map((h) => h.completedCount)
                                      .fold(0, (a, b) => a > b ? a : b)
                                      .toDouble() +
                                  1
                              : 1,
                          barGroups: habits
                              .asMap()
                              .entries
                              .map(
                                (entry) => BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.completedCount.toDouble(),
                                      width: 20,
                                      borderRadius: BorderRadius.circular(4),
                                      color: barColors[entry.key %
                                          barColors.length], // 색상 순환 적용
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final habitIndex = value.toInt();
                                  if (habitIndex >= 0 &&
                                      habitIndex < habits.length) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        habits[habitIndex].name,
                                        style: const TextStyle(fontSize: 14), // 폰트 크기 증가
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1, // 1 단위로 숫자 출력
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 14), // 폰트 크기 증가
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false), // 맨 위 타이틀 숨김
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
