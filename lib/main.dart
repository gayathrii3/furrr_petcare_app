import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';
import 'services/ai_analysis_service.dart';
import 'config/api_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pull API Keys from environment configuration
  final gemini = ApiConfig.geminiKey;
  final youtube = ApiConfig.youtubeKey;
  final maps = ApiConfig.mapsKey;

  // Initialize Services
  AiAnalysisService.init(gemini);
  
  print('--- FURRR API DIAGNOSTICS ---');
  print('GEMINI_API_KEY: ${gemini.isNotEmpty ? "✅ LOADED (${gemini.substring(0, 4)}...)" : "❌ MISSING"}');
  print('YOUTUBE_API_KEY: ${youtube.isNotEmpty ? "✅ LOADED (${youtube.substring(0, 4)}...)" : "❌ MISSING"}');
  print('GOOGLE_MAPS_API_KEY: ${maps.isNotEmpty ? "✅ LOADED (${maps.substring(0, 4)}...)" : "❌ MISSING"}');
  print('-----------------------------');
  
  if (ApiConfig.hasMissingKeys) {
    print('⚠️ WARNING: SOME ESSENTIAL API KEYS ARE MISSING. Check your --dart-define parameters.');
  }

  runApp(FurrrApp(
    geminiKey: gemini,
    youtubeKey: youtube,
    mapsKey: maps,
  ));
}

class FurrrApp extends StatelessWidget {
  final String geminiKey;
  final String youtubeKey;
  final String mapsKey;

  const FurrrApp({
    super.key,
    required this.geminiKey,
    required this.youtubeKey,
    required this.mapsKey,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Furrr',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        fontFamily: 'Manrope',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
          titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textDark,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}