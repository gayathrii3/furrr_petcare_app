import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../services/ai_analysis_service.dart';
import 'package:furrr/models/ai_health_analysis.dart';
import '../../theme/app_colors.dart';

class Behavior {
  final String title;
  final IconData icon;
  final Color dotColor;
  final Color iconBgColor;

  const Behavior({
    required this.title,
    required this.icon,
    required this.dotColor,
    required this.iconBgColor,
  });
}

class BehaviorAnalyzerScreen extends StatefulWidget {
  const BehaviorAnalyzerScreen({super.key});

  @override
  State<BehaviorAnalyzerScreen> createState() => _BehaviorAnalyzerScreenState();
}

class _BehaviorAnalyzerScreenState extends State<BehaviorAnalyzerScreen> {
  Behavior? _selectedBehavior;
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

  final List<Behavior> _behaviors = [
    Behavior(
      title: "Excessive barking",
      icon: Icons.volume_up_outlined,
      dotColor: Color(0xFF52B788),
      iconBgColor: AppColors.primary.withOpacity(0.12),
    ),
    Behavior(
      title: "Aggression",
      icon: Icons.error_outline,
      dotColor: Color(0xFFE63946),
      iconBgColor: AppColors.primary.withOpacity(0.12),
    ),
    Behavior(
      title: "Hiding / withdrawing",
      icon: Icons.visibility_off_outlined,
      dotColor: Color(0xFFFB8500),
      iconBgColor: AppColors.primary.withOpacity(0.12),
    ),
    Behavior(
      title: "Eating grass",
      icon: Icons.eco_outlined,
      dotColor: Color(0xFF52B788),
      iconBgColor: AppColors.primary.withOpacity(0.12),
    ),
    Behavior(
      title: "Tail chasing",
      icon: Icons.sync,
      dotColor: Color(0xFF52B788),
      iconBgColor: AppColors.primary.withOpacity(0.12),
    ),
    Behavior(
      title: "Sudden lethargy",
      icon: Icons.sentiment_dissatisfied_outlined,
      dotColor: Color(0xFFE63946),
      iconBgColor: AppColors.primary.withOpacity(0.12),
    ),
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
              child: _selectedBehavior == null ? _buildBehaviorList() : _buildBehaviorDetail(),
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
            TranslationService.t('behavior_analyzer'),
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

  Widget _buildBehaviorList() {
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
                    TranslationService.t('what_is_doing', arg: PetProfileService().currentPet.name),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _behaviors.length,
            itemBuilder: (context, index) {
              final behavior = _behaviors[index];
              return _buildBehaviorCard(behavior);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _analyzeBehavior(Behavior behavior) async {
    setState(() {
      _selectedBehavior = behavior;
      _isAnalyzing = true;
      _aiAnalysis = null;
    });

    try {
      final analysis = await AiAnalysisService().analyzeBehavior(behavior.title);
      
      if (!mounted) return;

      setState(() {
        _aiAnalysis = analysis;
        _isAnalyzing = false;
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

  Widget _buildBehaviorCard(Behavior behavior) {
    return GestureDetector(
      onTap: () => _analyzeBehavior(behavior),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.15), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: behavior.iconBgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(behavior.icon, color: behavior.dotColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                behavior.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: behavior.dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorDetail() {
    final b = _selectedBehavior!;
    
    if (_isAnalyzing) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_aiAnalysis == null) {
      return const Center(child: Text("Error analyzing behavior. Try again."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          _buildStepHeader(),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.primary.withOpacity(0.15), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(b.icon, color: b.dotColor, size: 48),
                const SizedBox(height: 15),
                Text(
                  b.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _aiAnalysis!.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                _buildInfoSection(Icons.lightbulb_outline, "WHY THIS HAPPENS", _aiAnalysis!.description, true),
                const SizedBox(height: 20),
                _buildInfoSection(Icons.play_circle_outline, "WHAT TO DO", _aiAnalysis!.steps.join("\n"), false),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: b.iconBgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: b.dotColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _aiAnalysis!.severity,
                        style: TextStyle(
                          color: b.dotColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => setState(() => _selectedBehavior = null),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text(
                    "Back to Behaviors",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
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

  Widget _buildStepHeader() {
    return Container(
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
              TranslationService.t('what_is_doing', arg: PetProfileService().currentPet.name),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(IconData icon, String title, String content, bool hasBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: hasBg ? const EdgeInsets.all(16) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: hasBg ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            content,
            softWrap: true,
            style: TextStyle(
              fontSize: 15,
              color: hasBg ? AppColors.textPrimary : AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
