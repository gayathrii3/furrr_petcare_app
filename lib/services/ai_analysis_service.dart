import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/ai_health_analysis.dart';
import '../models/ai_food_analysis.dart';
import '../models/ai_medication_analysis.dart';
import '../models/health_article.dart';
import '../models/dog_profile.dart';

class AiAnalysisService {
  static String _apiKey = "";
  static GenerativeModel? _model;
  
  static final AiAnalysisService _instance = AiAnalysisService._internal();
  factory AiAnalysisService() => _instance;
  AiAnalysisService._internal();

  /// Initialize the service with an API key
  /// Initialize the service with an API key
  static void init(String key) {
    _apiKey = key;
    // Using gemini-1.5-flash as 2.0-flash has zero limits on some free tier accounts.
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  GenerativeModel get _generativeModel => _model!;

  Future<AiHealthAnalysis> analyzeWound(Uint8List imageBytes) async {
    return _analyzeGeneric(
      prompt: "Analyze this image of a pet's wound. You must respond in valid JSON format.",
      imageBytes: imageBytes,
    );
  }

  Future<AiHealthAnalysis> analyzeSymptoms(List<String> symptoms, {String? description}) async {
    final symptomList = symptoms.join(", ");
    final userDesc = description != null ? " User description: $description" : "";
    return _analyzeGeneric(
      prompt: "Analyze these pet symptoms: $symptomList.$userDesc. You must respond in valid JSON format.",
    );
  }

  Future<AiHealthAnalysis> analyzeBehavior(String behavior, {String? description}) async {
    final userDesc = description != null ? " User description: $description" : "";
    return _analyzeGeneric(
      prompt: "Analyze this pet behavior: $behavior.$userDesc. You must respond in valid JSON format.",
    );
  }

  Future<AiFoodAnalysis> analyzeFoodSafety(String foodName, DogProfile pet) async {
    final prompt = """
      Analyze the safety of giving "$foodName" to a pet with these details:
      - Breed: ${pet.breed}
      - Age: ${pet.age}
      - Allergies: ${pet.allergies}
      - Existing Conditions: ${pet.conditions}
      
      You must respond in valid JSON format with these exact keys:
      {
        "foodName": "$foodName",
        "safetyLevel": "Safe" | "Caution" | "Toxic",
        "description": "General explanation of why it is safe or toxic",
        "breedNuance": "Crucial: Explain why it is specific to a ${pet.breed}. If there are no specific breed risks, mention general canine physiology related to this food.",
        "symptoms": ["symptom if ingested", "another symptom"],
        "actionSteps": ["What the owner should do right now", "When to call the vet"]
      }
      
      Keep the tone helpful and professional.
    """;

    if (_apiKey.isEmpty) {
      return AiFoodAnalysis(
        foodName: foodName,
        safetyLevel: "Error",
        description: "API Key is missing.",
        breedNuance: "Please check your configuration.",
        symptoms: [],
        actionSteps: ["Add GEMINI_API_KEY"],
      );
    }

    try {
      final rawJson = await _getRawAiResponse(prompt);
      final jsonResponse = jsonDecode(_extractJson(rawJson));
      return AiFoodAnalysis.fromJson(jsonResponse);
    } catch (e) {
      return AiFoodAnalysis(
        foodName: foodName,
        safetyLevel: "Error",
        description: "Failed to analyze food safety: $e",
        breedNuance: "Check your connection and try again.",
        symptoms: [],
        actionSteps: ["Retry in a moment"],
      );
    }
  }

  Future<AiMedicationAnalysis> analyzeMedicationSafety(String medName, DogProfile pet) async {
    final prompt = """
      Analyze the safety and usage of the medication "$medName" for a pet with these details:
      - Breed: ${pet.breed}
      - Age: ${pet.age}
      - Allergies: ${pet.allergies}
      - Existing Conditions: ${pet.conditions}
      
      You must respond in valid JSON format with these exact keys:
      {
        "medName": "$medName",
        "safetyLevel": "Safe" | "Caution" | "Toxic" | "Emergency",
        "description": "General explanation of the medication and its purpose",
        "dosageInfo": "Crucial: Mention that dosage MUST be confirmed by a vet. Provide typical range for a ${pet.weight}kg dog if applicable, but with heavy disclaimers.",
        "breedNuance": "Crucial: Explain any specific risks or benefits for a ${pet.breed}. Some breeds have sensitivities (e.g. MDR1 gene in collies).",
        "sideEffects": ["side effect 1", "side effect 2"],
        "actionSteps": ["Crucial first step", "Signs of overdose to watch for"]
      }
      
      Maintain a highly cautious and professional medical tone. Use bold disclaimers about veterinary consultation.
    """;

    if (_apiKey.isEmpty) {
      return AiMedicationAnalysis(
        medName: medName,
        safetyLevel: "Error",
        description: "API Key is missing.",
        dosageInfo: "",
        breedNuance: "Please check your configuration.",
        sideEffects: [],
        actionSteps: ["Add GEMINI_API_KEY"],
      );
    }

    try {
      final rawJson = await _getRawAiResponse(prompt);
      final jsonResponse = jsonDecode(_extractJson(rawJson));
      return AiMedicationAnalysis.fromJson(jsonResponse);
    } catch (e) {
      return AiMedicationAnalysis(
        medName: medName,
        safetyLevel: "Error",
        description: "Failed to analyze medication safety: $e",
        dosageInfo: "",
        breedNuance: "Check your connection and try again.",
        sideEffects: [],
        actionSteps: ["Retry in a moment"],
      );
    }
  }

  Future<List<HealthArticle>> generateHealthFeed(DogProfile pet) async {
    final prompt = """
      Generate a set of 5 distinct, high-quality Wikipedia-style health articles for a pet with these details:
      - Breed: ${pet.breed}
      - Age: ${pet.age}
      - Existing Conditions: ${pet.conditions}
      
      The articles should cover common health risks, infections, diseases, or preventative care specific to ${pet.breed}s or general dogs.
      
      You must respond in valid JSON format as a list of articles:
      {
        "articles": [
          {
            "title": "Disease Name or Health Topic",
            "summary": "A concise academic summary of the topic.",
            "sections": [
              {
                "title": "Nature of the Condition",
                "content": "Detailed overview..."
              },
              {
                "title": "Symptoms and Diagnosis",
                "content": "Common signs to watch for..."
              },
              {
                "title": "Preventative Care",
                "content": "How to mitigate risks..."
              }
            ],
            "tags": ["Infection", "Genetic", "Maintenance"]
          }
        ]
      }
      
      Use an informative, encyclopedic tone. Ensure one article is about common infections and another about a breed-specific genetic risk.
    """;

    if (_apiKey.isEmpty) return [];

    try {
      final rawJson = await _getRawAiResponse(prompt);
      final jsonResponse = jsonDecode(_extractJson(rawJson));
      final List articlesJson = jsonResponse['articles'] ?? [];
      return articlesJson.map((a) => HealthArticle.fromJson(a)).toList();
    } catch (e) {
      print("Failed to generate health feed: $e");
      return [];
    }
  }


  Future<String> _getRawAiResponse(String prompt, {Uint8List? imageBytes}) async {
    final content = [
      imageBytes != null 
        ? Content.multi([TextPart(prompt), DataPart('image/jpeg', imageBytes)])
        : Content.text(prompt)
    ];

    final response = await _generativeModel.generateContent(content);
    final rawText = response.text;
    
    if (rawText == null || rawText.isEmpty) {
      throw Exception("Empty response from AI");
    }
    return rawText;
  }

  /// Extracts the JSON block from potentially messy AI output
  String _extractJson(String text) {
    // 1. Try to find content between ```json and ```
    final jsonMatch = RegExp(r'```json\s*(\{[\s\S]*?\})\s*```').firstMatch(text);
    if (jsonMatch != null) return jsonMatch.group(1)!;

    // 2. Try to find content between any ``` and ```
    final codeMatch = RegExp(r'```\s*(\{[\s\S]*?\})\s*```').firstMatch(text);
    if (codeMatch != null) return codeMatch.group(1)!;

    // 3. Find the first '{' and last '}'
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return text.substring(start, end + 1);
    }

    return text.trim();
  }

  Future<AiHealthAnalysis> _analyzeGeneric({required String prompt, Uint8List? imageBytes}) async {
    if (_apiKey.isEmpty) {
      return AiHealthAnalysis(
        severity: "Key Missing",
        description: "Gemini API Key is missing. Please check your .env file or build configuration.",
        supplies: ["API Key needed"],
        steps: ["Add GEMINI_API_KEY to assets/.env"],
        vetAdvice: "Configure the API to enable AI analysis.",
      );
    }

    try {
      final fullPrompt = """
        $prompt
        
        Provide the analysis in JSON format with these exact keys:
        {
          "severity": "Minor" | "Moderate" | "See Vet Soon" | "Emergency",
          "description": "Clear explanation",
          "supplies": ["item 1", "item 2"],
          "steps": ["step 1", "step 2"],
          "vetAdvice": "When to seek professional help"
        }
        
        DO NOT provide any text outside of the JSON block.
        Always prioritize professional veterinary care for serious concerns.
      """;

      final content = [
        imageBytes != null 
          ? Content.multi([TextPart(fullPrompt), DataPart('image/jpeg', imageBytes)])
          : Content.text(fullPrompt)
      ];

      final response = await _generativeModel.generateContent(content);
      
      String? rawText = response.text;
      print("--- AI RAW RESPONSE ---");
      print(rawText);
      print("-----------------------");
      
      if (rawText == null || rawText.isEmpty) {
        throw Exception("The AI returned an empty response. This can happen due to safety filters or connectivity issues.");
      }

      final cleanJson = _extractJson(rawText);
      
      try {
        final jsonResponse = jsonDecode(cleanJson);
        return AiHealthAnalysis.fromJson(jsonResponse);
      } catch (parseError) {
        print("AI JSON Parse Error: $parseError");
        print("Problematic Text: $cleanJson");
        throw Exception("Failed to parse AI response. The model's output was not valid JSON.");
      }
    } catch (e) {
      print("AI Analysis Error: $e");
      
      String errorDescription = "An unexpected error occurred during analysis.";
      if (e.toString().contains("quota")) {
        errorDescription = "API Quota exceeded. Please try again in 60 seconds (Free tier limit).";
      } else if (e.toString().contains("SocketException") || e.toString().contains("connection")) {
        errorDescription = "Network error. Please check your internet connection and try again.";
      } else if (e.toString().contains("Safety")) {
        errorDescription = "The AI safety filter blocked this request. Please try with less sensitive input.";
      } else {
        errorDescription = "Analysis failed: ${e.toString().replaceFirst('Exception: ', '')}";
      }

      return AiHealthAnalysis(
        severity: "Error",
        description: errorDescription,
        supplies: ["Check Internet", "Check API Credentials"],
        steps: ["Verify assets/.env", "Wait 60 seconds"],
        vetAdvice: "If your pet is in distress, seek immediate veterinary care.",
      );
    }
  }
}
