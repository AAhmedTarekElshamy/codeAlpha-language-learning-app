import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/di/service_locator.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/category_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'dashboard/dashboard_screen.dart';
import 'ai_tutor/ai_tutor_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ChangeNotifierProvider(
        create: (_) => getIt<HomeViewModel>(),
        child: const DashboardScreen(),
      ),
      ChangeNotifierProvider(
        create: (_) => getIt<CategoryViewModel>(),
        child: const Center(
          child: Text('Click Categories on Dashboard to Study!'),
        ),
      ),
      const AiTutorScreen(),
      ChangeNotifierProvider(
        create: (_) => getIt<ProfileViewModel>(),
        child: const ProfileScreen(),
      ),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Direct user to select category from dashboard to study
      setState(() {
        _selectedIndex = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a category card on the dashboard to study!',
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_rounded),
              label: 'Study',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_rounded),
              label: 'AI Tutor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
