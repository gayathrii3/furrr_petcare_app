import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/ai_health_analysis.dart';

class AiAnalysisService {
  static String _apiKey = "";
  static GenerativeModel? _model;
  
  static final AiAnalysisService _instance = AiAnalysisService._internal();
  factory AiAnalysisService() => _instance;
  AiAnalysisService._internal();

  /// Initialize the service with an API key
  static void init(String key) {
    _apiKey = key;
    // Using gemini-flash-latest as it is the only verified working alias
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );
  }

  GenerativeModel get _generativeModel => _model!;

  Future<AiHealthAnalysis> analyzeWound(Uint8List imageBytes) async {
    return _analyzeGeneric(
      prompt: "Analyze this image of a pet's wound. Provide a detailed analysis in JSON.",
      imageBytes: imageBytes,
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

  Future<AiHealthAnalysis> _analyzeGeneric({required String prompt, Uint8List? imageBytes}) async {
    if (_apiKey.isEmpty) {
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
        imageBytes != null 
          ? Content.multi([TextPart(fullPrompt), DataPart('image/jpeg', imageBytes)])
          : Content.text(fullPrompt)
      ];

      final response = await _generativeModel.generateContent(content);
      
      String? text = response.text;
      print("AI Response Raw: $text");
      
      if (text == null) throw Exception("Empty AI response");

      // Cleanup JSON from markdown code blocks if necessary
      if (text.contains("```")) {
        text = text.replaceAll(RegExp(r'```json\n?'), '');
        text = text.replaceAll(RegExp(r'\n?```'), '');
        text = text.trim();
      }
      
      final jsonResponse = jsonDecode(text);
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
