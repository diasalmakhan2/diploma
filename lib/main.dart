import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/home_shell.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.load();
  runApp(LinguaLiftApp(appState: appState));
}

class LinguaLiftApp extends StatelessWidget {
  const LinguaLiftApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: appState,
      child: MaterialApp(
        title: 'LinguaLift',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        home: appState.isLoggedIn ? const HomeShell() : const AuthScreen(),
      ),
    );
  }
}
