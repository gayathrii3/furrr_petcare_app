import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  /// Gemini API Key for AI Health Analysis
  /// Priority: .env -> --dart-define -> empty
  static String get geminiKey =>
      dotenv.env['GEMINI_API_KEY'] ??
      const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  /// YouTube API Key for Pet Care Videos
  /// Priority: .env -> --dart-define -> empty
  static String get youtubeKey =>
      dotenv.env['YOUTUBE_API_KEY'] ??
      const String.fromEnvironment('YOUTUBE_API_KEY', defaultValue: '');


  /// Helper to check if essential keys are missing
  static bool get hasMissingKeys => geminiKey.isEmpty || youtubeKey.isEmpty;
}
