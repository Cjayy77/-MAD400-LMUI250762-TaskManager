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
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        // Windows File Explorer: warm dark brown + Windows blue
        colorScheme: ColorScheme.fromSeed(
          seedColor:  const Color(0xFF00897B),
          primary:  const Color(0xFF00897B),   
          secondary: const Color.fromARGB(255, 198, 152, 14),  
          surface: const Color(0xFFF5F0EB),    
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F0EB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 212, 151, 18),  
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 2, 182, 195),  
          foregroundColor: Colors.white,
        ),
        chipTheme: ChipThemeData(
          selectedColor: const Color(0xFF00897B).withOpacity(0.15),
          checkmarkColor:  const Color(0xFF00897B),
        ),
        cardColor: Colors.white,
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
        backgroundColor: const Color.fromARGB(255, 198, 152, 14),   // same brown as AppBar
        selectedItemColor:  const Color(0xFF00897B), // light blue — visible on brown
        unselectedItemColor: Colors.white54,
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