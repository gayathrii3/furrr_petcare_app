import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../services/ai_analysis_service.dart';
import 'package:furrr/models/ai_health_analysis.dart';
import 'package:furrr/Screens/Vets/vets_screen.dart';
import '../../theme/app_colors.dart';
import '../../widgets/paws_loading.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  int _currentStep = 0;
  final Set<String> _selectedSymptoms = {};
  final TextEditingController _descriptionController = TextEditingController();
  bool _isAnalyzing = false;
  AiHealthAnalysis? _aiAnalysis;

  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    PetProfileService().removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  final List<Map<String, dynamic>> _symptomData = [
    {"name": "Vomiting", "icon": Icons.sick_outlined},
    {"name": "Lethargy", "icon": Icons.sentiment_satisfied_alt_outlined},
    {"name": "Loss of appetite", "icon": Icons.near_me_outlined},
    {"name": "Coughing", "icon": Icons.lightbulb_outline},
    {"name": "Limping", "icon": Icons.link_outlined},
    {"name": "Scratching", "icon": Icons.hub_outlined},
    {"name": "Diarrhea", "icon": Icons.water_drop_outlined},
    {"name": "Sneezing", "icon": Icons.search_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(),
            Expanded(
              child: _currentStep == 0 ? _buildSymptomSelection() : _buildDiagnosis(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          CustomBackButton(onTap: () => Navigator.pop(context)),
          const SizedBox(width: 15),
          Text(
            TranslationService.t('symptom_checker'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text("🐶", style: TextStyle(fontSize: 32)),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    TranslationService.t('select_symptoms', arg: PetProfileService().currentPet.name),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: _symptomData.length,
            itemBuilder: (context, index) {
              final symptom = _symptomData[index];
              final isSelected = _selectedSymptoms.contains(symptom['name']);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSymptoms.remove(symptom['name']);
                    } else {
                      _selectedSymptoms.add(symptom['name']);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        symptom['icon'],
                        color: isSelected ? AppColors.textDark : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          symptom['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Or describe in your own words...",
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: (_selectedSymptoms.isEmpty && _descriptionController.text.isEmpty) || _isAnalyzing
                ? null
                : _analyzeSymptoms,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: (_selectedSymptoms.isEmpty && _descriptionController.text.isEmpty) || _isAnalyzing 
                    ? Colors.grey.withOpacity(0.2) 
                    : AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isAnalyzing 
                    ? const PawsLoading(size: 30, color: AppColors.textDark)
                    : Icon(
                        Icons.search,
                        color: (_selectedSymptoms.isEmpty && _descriptionController.text.isEmpty) ? Colors.grey : AppColors.primary,
                      ),
                  const SizedBox(width: 10),
                  Text(
                    _isAnalyzing ? "Analyzing..." : "Analyze Symptoms",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: (_selectedSymptoms.isEmpty && _descriptionController.text.isEmpty) ? Colors.grey : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _analyzeSymptoms() async {
    setState(() => _isAnalyzing = true);
    
    try {
      final analysis = await AiAnalysisService().analyzeSymptoms(
        _selectedSymptoms.toList(),
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      );
      
      if (!mounted) return;
      
      setState(() {
        _aiAnalysis = analysis;
        _isAnalyzing = false;
        _currentStep = 1;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Analysis failed: $e")),
        );
      }
    }
  }

  Widget _buildDiagnosis() {
    if (_aiAnalysis == null) return const Center(child: PawsLoading(size: 80));
    
    final bool isUrgent = _aiAnalysis!.severity.toLowerCase().contains("urgent") || 
                         _aiAnalysis!.severity.toLowerCase().contains("vet") ||
                         _aiAnalysis!.severity.toLowerCase().contains("emergency");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isUrgent ? AppColors.error.withOpacity(0.15) : AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUrgent ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: isUrgent ? AppColors.error : AppColors.primary,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              _aiAnalysis!.severity,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isUrgent ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _aiAnalysis!.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 30),
          const Text(
            "Analysis & Verdict",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _verdictRow("Advice", _aiAnalysis!.vetAdvice),
                const Divider(height: 24),
                _verdictRow("Steps", _aiAnalysis!.steps.isNotEmpty ? _aiAnalysis!.steps.first : "Monitor"),
                const Divider(height: 24),
                _verdictRow("Supplies", _aiAnalysis!.supplies.isNotEmpty ? _aiAnalysis!.supplies.first : "Water"),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VetsScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Find Vets Nearby",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _currentStep = 0;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 54),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Back",
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verdictRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
