import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FurrrApp());
}

class FurrrApp extends StatelessWidget {
  const FurrrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Furrr',
      theme: ThemeData(
        primaryColor: const Color(0xFF006949),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006949),
          primary: const Color(0xFF006949),
          secondary: const Color(0xFFA6FDD3),
        ),
        fontFamily: 'Manrope',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF00362B)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}