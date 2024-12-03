import 'package:flutter/material.dart';

class HabitReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Reports', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Weekly, Monthly, Yearly tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Weekly",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Monthly",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text("Yearly",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 16),

            // Habit tracker title
            Center(
              child: Text(
                "Habit Tracker",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              ),
            ),
            SizedBox(height: 8),

            // Date range
            Center(
              child: Text(
                "08/28 - 09/03",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 16),

            // Table for day headers and habit rows
            Table(
              columnWidths: {
                0: FlexColumnWidth(2), // Habit name column
                for (int i = 1; i <= 7; i++) i: FlexColumnWidth(1),
              },
              children: [
                // Day headers
                TableRow(
                  children: [
                    SizedBox.shrink(),
                    ...["S", "M", "T", "W", "T", "F", "S"]
                        .map((day) => Center(
                              child: Text(day,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ))
                        .toList(),
                  ],
                ),
                // Habit rows
                ...List.generate(8, (index) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Habit ${index + 1}",
                            style: TextStyle(fontSize: 16)),
                      ),
                      ...List.generate(7, (dayIndex) {
                        bool completed = (dayIndex % 3 == 0);
                        return Center(
                          child: Icon(
                            Icons.check_circle,
                            color: completed ? Colors.green : Colors.grey[300],
                            size: 20,
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
            SizedBox(height: 16),

            // Progress summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProgressSummary(label: "100%", description: "Met"),
                ProgressSummary(label: "7", description: "BestDay"),
                ProgressSummary(label: "56", description: "TotalDone"),
                ProgressSummary(label: "7", description: "BestStreak"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Progress summary widget for metrics at the bottom
class ProgressSummary extends StatelessWidget {
  final String label;
  final String description;

  ProgressSummary({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(description, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}
