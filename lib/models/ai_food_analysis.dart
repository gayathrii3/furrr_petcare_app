class AiFoodAnalysis {
  final String foodName;
  final String safetyLevel; // "Safe", "Caution", "Toxic"
  final String description;
  final String breedNuance;
  final List<String> symptoms;
  final List<String> actionSteps;

  AiFoodAnalysis({
    required this.foodName,
    required this.safetyLevel,
    required this.description,
    required this.breedNuance,
    required this.symptoms,
    required this.actionSteps,
  });

  factory AiFoodAnalysis.fromJson(Map<String, dynamic> json) {
    return AiFoodAnalysis(
      foodName: json['foodName'] ?? 'Unknown Food',
      safetyLevel: json['safetyLevel'] ?? 'Unknown',
      description: json['description'] ?? '',
      breedNuance: json['breedNuance'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      actionSteps: List<String>.from(json['actionSteps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'safetyLevel': safetyLevel,
      'description': description,
      'breedNuance': breedNuance,
      'symptoms': symptoms,
      'actionSteps': actionSteps,
    };
  }
}
