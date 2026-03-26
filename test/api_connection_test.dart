import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  const geminiKey = String.fromEnvironment('GEMINI_API_KEY');
  const youtubeKey = String.fromEnvironment('YOUTUBE_API_KEY');

  test('Check Gemini API Connection', () async {
    print('\n--- Gemini Status Check ---');
    print('GEMINI_API_KEY: ${geminiKey.isNotEmpty && geminiKey != "YOUR_GEMINI_API_KEY" ? "✅ Loaded" : "❌ MISSING or DEFAULT"}');
    
    if (geminiKey.isNotEmpty && geminiKey != "YOUR_GEMINI_API_KEY") {
      try {
        final model = GenerativeModel(model: 'gemini-flash-latest', apiKey: geminiKey);
        final response = await model.generateContent([Content.text('Hello, are you working?')]);
        print('Gemini Result: ${response.text?.trim() ?? "No response"}');
        expect(response.text, isNotNull);
      } catch (e) {
        print('Gemini Full Error: $e');
        rethrow;
      }
    } else {
      fail('Gemini API Key is missing or default.');
    }
  });

  test('Check YouTube API Connection', () async {
    print('\n--- YouTube Status Check ---');
    print('YOUTUBE_API_KEY: ${youtubeKey.isNotEmpty && youtubeKey != "YOUR_YOUTUBE_API_KEY" ? "✅ Loaded" : "❌ MISSING or DEFAULT"}\n');

    if (youtubeKey.isNotEmpty && youtubeKey != "YOUR_YOUTUBE_API_KEY") {
      final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=dogs&type=video&maxResults=1&key=$youtubeKey';
      final response = await http.get(Uri.parse(url));
      print('YouTube Result: ${response.statusCode == 200 ? "✅ Success" : "❌ Error ${response.statusCode}"}');
      if (response.statusCode != 200) {
        print('YouTube Error Details: ${response.body}');
      }
      expect(response.statusCode, 200);
    } else {
      fail('YouTube API Key is missing or default.');
    }
  });
}
