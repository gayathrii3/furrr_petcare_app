import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  const geminiKey = String.fromEnvironment('GEMINI_API_KEY');
  const youtubeKey = String.fromEnvironment('YOUTUBE_API_KEY');

  print('\n--- API Status Check ---');
  print('GEMINI_API_KEY: ${geminiKey.isNotEmpty && geminiKey != "YOUR_GEMINI_API_KEY" ? "✅ Loaded" : "❌ MISSING or DEFAULT"}');
  print('YOUTUBE_API_KEY: ${youtubeKey.isNotEmpty && youtubeKey != "YOUR_YOUTUBE_API_KEY" ? "✅ Loaded" : "❌ MISSING or DEFAULT"}\n');

  if (geminiKey.isNotEmpty && geminiKey != "YOUR_GEMINI_API_KEY") {
    print('Testing Gemini...');
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiKey);
      final response = await model.generateContent([Content.text('Hello, are you working?')]);
      print('Result: ${response.text?.trim() ?? "No response"}');
    } catch (e) {
      print('Error: $e');
    }
  }

  if (youtubeKey.isNotEmpty && youtubeKey != "YOUR_YOUTUBE_API_KEY") {
    print('\nTesting YouTube...');
    try {
      final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=dogs&type=video&maxResults=1&key=$youtubeKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Result: ✅ Data fetched successfully!');
      } else {
        print('Result: ❌ Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  print('\n--- End of Check ---\n');
}
