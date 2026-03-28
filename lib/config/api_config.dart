class ApiConfig {
  /// Gemini API Key for AI Health Analysis
  /// Pass via --dart-define=GEMINI_API_KEY=your_key
  static const String geminiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// YouTube API Key for Pet Care Videos
  /// Pass via --dart-define=YOUTUBE_API_KEY=your_key
  static const String youtubeKey = String.fromEnvironment(
    'YOUTUBE_API_KEY',
    defaultValue: '',
  );

  /// Google Maps API Key for Vet Services
  /// Pass via --dart-define=MAPS_API_KEY=your_key
  static const String mapsKey = String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: '',
  );

  /// Helper to check if essential keys are missing
  static bool get hasMissingKeys =>
    geminiKey.isEmpty || youtubeKey.isEmpty;
}
