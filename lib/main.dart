import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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