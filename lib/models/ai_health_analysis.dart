class AiHealthAnalysis {
  final String severity;
  final String description;
  final List<String> supplies;
  final List<String> steps;
  final String vetAdvice;

  AiHealthAnalysis({
    required this.severity,
    required this.description,
    required this.supplies,
    required this.steps,
    required this.vetAdvice,
  });

  factory AiHealthAnalysis.fromJson(Map<String, dynamic> json) {
    return AiHealthAnalysis(
      severity: json['severity'] ?? 'Unknown',
      description: json['description'] ?? '',
      supplies: List<String>.from(json['supplies'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      vetAdvice: json['vetAdvice'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'severity': severity,
      'description': description,
      'supplies': supplies,
      'steps': steps,
      'vetAdvice': vetAdvice,
    };
  }
}
