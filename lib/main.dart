import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false, // removes the red debug ribbon
      theme: ThemeData(
        // Turquoise + dark slate color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00ACC1),
          primary: const Color(0xFF00ACC1),    // turquoise
          secondary: const Color(0xFF455A64),  // dark slate grey
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00ACC1),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00ACC1),
          foregroundColor: Colors.white,
        ),
        useMaterial3: false,
      ),
      home: const MainScreen(),
    );
  }
}

// MainScreen holds the BottomNavigationBar and swaps screens using IndexedStack
// IndexedStack keeps all screens alive (they don't rebuild when you switch tabs)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // tracks which tab is selected

  // The two screens — IndexedStack shows only the one at _currentIndex
  final List<Widget> _screens = const [
    TaskListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF00ACC1),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}