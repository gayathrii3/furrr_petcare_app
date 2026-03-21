import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/ai_health_analysis.dart';

class AiAnalysisService {
  // Gemini API Key from https://aistudio.google.com/
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  
  static final AiAnalysisService _instance = AiAnalysisService._internal();
  factory AiAnalysisService() => _instance;
  AiAnalysisService._internal();

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
    ),
  );

  Future<AiHealthAnalysis> analyzeWound(File imageFile) async {
    return _analyzeGeneric(
      prompt: "Analyze this image of a pet's wound. Provide a detailed analysis in JSON.",
      imageFile: imageFile,
    );
  }

  Future<AiHealthAnalysis> analyzeSymptoms(List<String> symptoms, {String? description}) async {
    final symptomList = symptoms.join(", ");
    final userDesc = description != null ? " User description: $description" : "";
    return _analyzeGeneric(
      prompt: "Analyze these pet symptoms: $symptomList.$userDesc. Provide a detailed analysis in JSON.",
    );
  }

  Future<AiHealthAnalysis> analyzeBehavior(String behavior) async {
    return _analyzeGeneric(
      prompt: "Analyze this pet behavior: $behavior. Provide a detailed analysis in JSON.",
    );
  }

  Future<AiHealthAnalysis> _analyzeGeneric({required String prompt, File? imageFile}) async {
    if (_apiKey == "YOUR_GEMINI_API_KEY") {
      return AiHealthAnalysis(
        severity: "Key Missing",
        description: "Please provide a Gemini API Key.",
        supplies: ["API Key needed"],
        steps: ["Visit aistudio.google.com"],
        vetAdvice: "Contact developer",
      );
    }

    try {
      final fullPrompt = """
        $prompt
        Provide the analysis in JSON format with these exact keys:
        - severity: (e.g., 'Minor', 'Moderate', 'See Vet Soon', 'Emergency')
        - description: clear explanation of the situation
        - supplies: list of needed first-aid or management items
        - steps: list of clear actions to take
        - vetAdvice: specific advice on when to seek professional help
        
        Always prioritize veterinary care for serious concerns.
      """;

      final content = [
        imageFile != null 
          ? Content.multi([TextPart(fullPrompt), DataPart('image/jpeg', await imageFile.readAsBytes())])
          : Content.text(fullPrompt)
      ];

      final response = await _model.generateContent(content);
      print("AI Response: ${response.text}");
      final jsonResponse = jsonDecode(response.text ?? '{}');
      
      return AiHealthAnalysis.fromJson(jsonResponse);
    } catch (e) {
      print("AI Analysis Error: $e");
      return AiHealthAnalysis(
        severity: "Error",
        description: "Failed to analyze: $e",
        supplies: ["Check connection"],
        steps: ["Try again later"],
        vetAdvice: "Seek vet if worried",
      );
    }
  }
}
