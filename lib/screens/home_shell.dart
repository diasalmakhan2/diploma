import 'package:flutter/material.dart';

import '../widgets/app_scope.dart';
import 'bank_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'teacher_dashboard_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final isTeacher = appState.isTeacher;
    final screens = isTeacher
        ? const <Widget>[
            TeacherDashboardScreen(),
            ProfileScreen(),
          ]
        : const <Widget>[
            HomeScreen(),
            BankScreen(),
            ProfileScreen(),
          ];

    final destinations = isTeacher
        ? const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded),
              label: 'Reviews',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ]
        : const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.savings_outlined),
              selectedIcon: Icon(Icons.savings_rounded),
              label: 'Points',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ];

    if (_index >= screens.length) {
      _index = 0;
    }

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
          });
        },
        destinations: destinations,
      ),
    );
  }
}
