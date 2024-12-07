import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/habit_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Toggle Dark Mode'),
              onTap: () {
                themeProvider.toggleTheme();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: habitProvider.habits.isEmpty
                ? Center(
                    child: Text(
                      'No habits yet. Add your first habit!',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: habitProvider.habits.length,
                    itemBuilder: (context, index) {
                      final habit = habitProvider.habits[index];
                      return ListTile(
                        title: Text(habit.name),
                        subtitle: Text(
                            'Progress: ${habit.currentCount}/${habit.goalCount}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                habitProvider.incrementHabit(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmDeleteHabit(
                                    context, habitProvider, index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddHabitScreen(context, habitProvider);
            },
            child: const Text('Add Habit'),
          ),
        ],
      ),
    );
  }

  // PageRouteBuilder를 사용하여 "Add Habit" 모달 애니메이션 추가
  void _showAddHabitScreen(BuildContext context, HabitProvider provider) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // 배경을 투명하게 설정
        pageBuilder: (context, animation, secondaryAnimation) {
          return _buildAddHabitDialog(context, provider);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 슬라이드와 페이드 애니메이션 적용
          const begin = Offset(0, 1); // 아래에서 시작
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300), // 애니메이션 시간
      ),
    );
  }

  // Add Habit Dialog 구현
  Widget _buildAddHabitDialog(BuildContext context, HabitProvider provider) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController goalController = TextEditingController();

    return Center(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Habit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Habit Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: goalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Goal Count'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          goalController.text.isNotEmpty) {
                        final goalCount = int.tryParse(goalController.text);
                        if (goalCount != null) {
                          provider.addHabit(
                            nameController.text,
                            goalCount,
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid number.'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteHabit(
      BuildContext context, HabitProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: const Text('Are you sure you want to delete this habit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.removeHabit(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
