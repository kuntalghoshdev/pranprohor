import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PranProhorApp());
}

class PranProhorApp extends StatelessWidget {
  const PranProhorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PranProhor',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}