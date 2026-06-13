import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

void main() async {
  final apiKey = 'AIzaSyA0tMWX23IWxyw05lPHePaT6Og0N8jVko0';
  if (apiKey.isEmpty) {
    print('No API key found.');
    return;
  }

  print('Listing models for API key ending in ...${apiKey.substring(apiKey.length - 4)}');
  
  // Note: listing models isn't directly exposed in the package in a simple way, 
  // but we can try to initialize common ones and see which one succeeds or fails with 404.
  
  final modelsToTest = [
    'gemini-1.5-flash',
    'gemini-1.5-flash-latest',
    'gemini-1.5-flash-8b',
    'gemini-2.0-flash',
    'gemini-2.0-flash-exp',
    'gemini-pro',
  ];

  for (final modelName in modelsToTest) {
    try {
      final model = GenerativeModel(model: modelName, apiKey: apiKey);
      final response = await model.generateContent([Content.text('hi')]);
      if (response.text != null) {
        print('✅ [SUCCESS] $modelName is available and working.');
      }
    } catch (e) {
      if (e.toString().contains('404')) {
        print('❌ [NOT FOUND] $modelName is not found/retired.');
      } else if (e.toString().contains('429')) {
        print('⚠️ [QUOTA] $modelName exists but quota is exceeded/zero.');
      } else {
        print('❓ [ERROR] $modelName returned: $e');
      }
    }
  }
}
