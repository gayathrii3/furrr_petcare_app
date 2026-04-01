import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
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
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light, 
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryOrange,
          primary: AppColors.primaryOrange,
          secondary: AppColors.buttonOrange,
          surface: AppColors.background,
        ),
        fontFamily: GoogleFonts.pangolin().fontFamily,
        textTheme: GoogleFonts.pangolinTextTheme().copyWith(
          bodyLarge: const TextStyle(color: Colors.black, fontSize: 16),
          bodyMedium: const TextStyle(color: Colors.black87, fontSize: 14),
          titleLarge: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}