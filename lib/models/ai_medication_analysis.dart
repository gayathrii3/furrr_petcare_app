class AiMedicationAnalysis {
  final String medName;
  final String safetyLevel; // "Safe", "Caution", "Toxic", "Emergency"
  final String description;
  final String dosageInfo;
  final String breedNuance;
  final List<String> sideEffects;
  final List<String> actionSteps;

  AiMedicationAnalysis({
    required this.medName,
    required this.safetyLevel,
    required this.description,
    required this.dosageInfo,
    required this.breedNuance,
    required this.sideEffects,
    required this.actionSteps,
  });

  factory AiMedicationAnalysis.fromJson(Map<String, dynamic> json) {
    return AiMedicationAnalysis(
      medName: json['medName'] ?? 'Unknown Medication',
      safetyLevel: json['safetyLevel'] ?? 'Unknown',
      description: json['description'] ?? '',
      dosageInfo: json['dosageInfo'] ?? 'Consult a veterinarian for dosages.',
      breedNuance: json['breedNuance'] ?? '',
      sideEffects: List<String>.from(json['sideEffects'] ?? []),
      actionSteps: List<String>.from(json['actionSteps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medName': medName,
      'safetyLevel': safetyLevel,
      'description': description,
      'dosageInfo': dosageInfo,
      'breedNuance': breedNuance,
      'sideEffects': sideEffects,
      'actionSteps': actionSteps,
    };
  }
}
