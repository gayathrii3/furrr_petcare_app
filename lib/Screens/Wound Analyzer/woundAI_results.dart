import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import 'package:furrr/models/ai_health_analysis.dart';
import '../../theme/app_colors.dart';

class WoundResultScreen extends StatefulWidget {
  final AiHealthAnalysis analysis;
  const WoundResultScreen({super.key, required this.analysis});

  @override
  State<WoundResultScreen> createState() => _WoundResultScreenState();
}

class _WoundResultScreenState extends State<WoundResultScreen> {
  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const CustomBackButton(),
        leadingWidth: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          TranslationService.t('analysis_result'),
          style: GoogleFonts.pangolin(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildSeverityCard(),
            const SizedBox(height: 18),
            _buildSuppliesCard(),
            const SizedBox(height: 18),
            _buildStepsCard(),
            const SizedBox(height: 18),
            _buildVetWarningCard(),
            const SizedBox(height: 22),
            _buildAnalyzeAgainButton(context),
          ],
        ),
      ),
    );
  }

  // 🔴 SEVERITY CARD
  Widget _buildSeverityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.error.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            widget.analysis.severity,
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.analysis.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                color: Colors.black87,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🧴 SUPPLIES CARD
  Widget _buildSuppliesCard() {
    final supplies = [
      "Saline solution or clean lukewarm water",
      "Sterile gauze pads (non-stick)",
      "Pet-safe antibiotic ointment",
      "Vet wrap or medical tape",
      "E-collar to prevent licking",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TranslationService.t('supplies_needed'),
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: AppColors.primaryOrange,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.analysis.supplies.map((e) => _chip(e)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.pangolin(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🩺 STEPS CARD
  Widget _buildStepsCard() {
    final steps = [
      "Gently clean the wounds with lukewarm water or saline solution to remove debris - do not scrub",
      "Pat dry with clean gauze and apply a thin layer of pet-safe antibiotic ointment if available",
      "Cover with a non-stick pad and wrap with gauze/bandage to keep clean - prevent licking with an e-collar if needed",
      "Monitor closely for signs of infection and keep the paw dry and clean until veterinary evaluation",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TranslationService.t('first_aid_steps'),
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: AppColors.primaryOrange,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: List.generate(
              widget.analysis.steps.length,
              (i) => _stepItem(i + 1, widget.analysis.steps[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            ),
            child: Text(
              "$number",
              style: GoogleFonts.pangolin(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.pangolin(
                textStyle: const TextStyle(
                  color: Colors.black87,
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟠 WHEN TO GO TO VET CARD
  Widget _buildVetWarningCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.1),
              width: 1.3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      TranslationService.t('when_to_vet'),
                      style: GoogleFonts.pangolin(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Text(
                widget.analysis.vetAdvice,
                style: GoogleFonts.pangolin(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // left dog ear
        Positioned(
          top: -6,
          left: 24,
          child: Container(
            width: 38,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),

        // right dog ear
        Positioned(
          top: -6,
          right: 24,
          child: Container(
            width: 38,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 📷 Analyze another wound button
  Widget _buildAnalyzeAgainButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.camera_alt_outlined,
          color: AppColors.textPrimary,
        ),
        label: Text(
          TranslationService.t('analyze_another'),
          style: GoogleFonts.pangolin(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          side: BorderSide(
            color: AppColors.primaryOrange.withOpacity(0.3),
            width: 1.7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}