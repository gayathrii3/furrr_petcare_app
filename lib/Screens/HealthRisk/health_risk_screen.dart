import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/youtube_service.dart';
import '../../services/pet_profile_service.dart';

class HealthRisk {
  final String title;
  final String severity; // High, Medium, Low
  final String description;
  final String prevention;

  const HealthRisk({
    required this.title,
    required this.severity,
    required this.description,
    required this.prevention,
  });
}

class HealthRiskScreen extends StatefulWidget {
  const HealthRiskScreen({super.key});

  @override
  State<HealthRiskScreen> createState() => _HealthRiskScreenState();
}

class _HealthRiskScreenState extends State<HealthRiskScreen> {
  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged); // Added PetProfileService listener
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    PetProfileService().removeListener(_onProfileChanged); // Removed PetProfileService listener
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  // The _pugRisks list is no longer needed as risks will be fetched dynamically
  // final List<HealthRisk> _pugRisks = const [
  //   HealthRisk(
  //     title: "Breathing Issues (BAS)",
  //     severity: "High",
  //     description: "Due to their flat faces, Pugs often struggle with airflow, leading to snoring and overheating.",
  //     prevention: "Keep them in cool environments and use a harness instead of a collar.",
  //   ),
  //   HealthRisk(
  //     title: "Skin Fold Infections",
  //     severity: "Medium",
  //     description: "Bacteria and yeast can grow in the deep wrinkles on a Pug's face.",
  //     prevention: "Clean facial folds daily with pet-safe wipes and keep them dry.",
  //   ),
  //   HealthRisk(
  //     title: "Eye Injuries",
  //     severity: "High",
  //     description: "Their prominent eyes are prone to scratches, ulcers, and even proptosis.",
  //     prevention: "Avoid thorny bushes and monitor for any redness or cloudiness.",
  //   ),
  //   HealthRisk(
  //     title: "Obesity",
  //     severity: "Medium",
  //     description: "Pugs love food and gain weight easily, which puts stress on their joints and heart.",
  //     prevention: "Strict portion control and daily low-impact walks.",
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    final petProfile = PetProfileService().currentPet;
    final breedSpecificContent = PetProfileService().getBreedSpecificContent();
    final List<HealthRisk> breedRisks = (breedSpecificContent['risks'] as List)
        .map((riskData) => HealthRisk(
              title: riskData['title'],
              severity: riskData['severity'],
              description: riskData['description'],
              prevention: riskData['prevention'],
            ))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F3),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const CustomBackButton(),
            leadingWidth: 60,
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFFB4235A),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                TranslationService.t('health_risks'),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB4235A), Color(0xFFE63946)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.pets,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildRiskCard(breedRisks[index]),
                childCount: breedRisks.length, // Use dynamic risks count
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCard(HealthRisk risk) {
    Color severityColor = risk.severity == "High" ? const Color(0xFFE63946) : Colors.orange;
    if (risk.severity == "Low") severityColor = Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                risk.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2A22),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  risk.severity.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: severityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            risk.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF476555),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FFF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFB7E4C7)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFF1F8A5F)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "PREVENTION: ${risk.prevention}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F8A5F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
