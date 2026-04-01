import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Profile/pet_profile_screen.dart';
import '../../services/pet_profile_service.dart';
import '../../theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import '../SymptomChecker/symptom_checker_screen.dart';
import '../Behavior/behavior_analyzer_screen.dart';
import '../FoodSafety/food_safety_screen.dart';
import '../Meds/medication_guide_screen.dart';
import '../HealthRisk/health_risk_screen.dart';
import '../Wound Analyzer/woundAI_screen.dart';
import '../../widgets/quick_action_card.dart';

class FurrrHomePage extends StatefulWidget {
  const FurrrHomePage({super.key});

  @override
  State<FurrrHomePage> createState() => _FurrrHomePageState();
}

class _FurrrHomePageState extends State<FurrrHomePage> {
  @override
  void initState() {
    super.initState();
    PetProfileService().addListener(_onProfileChanged);
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    PetProfileService().removeListener(_onProfileChanged);
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dog = PetProfileService().currentPet;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7), // Light mint/grey background from image
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Premium Header
            _buildModernHeader(dog),

            // 2. Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  
                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        TranslationService.t('quick_actions'),
                        style: GoogleFonts.pangolin(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        TranslationService.t('for_name', arg: dog.name),
                        style: GoogleFonts.pangolin(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. Quick Actions Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      QuickActionCard(
                        title: TranslationService.t('check_symptoms'),
                        icon: Icons.search_rounded,
                        ghostIcon: Icons.medical_services_outlined,
                        backgroundColor: const Color(0xFFFFF7F0), // Very Light Orange
                        iconColor: AppColors.primaryOrange,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SymptomCheckerScreen())),
                      ),
                      QuickActionCard(
                        title: TranslationService.t('food_safety'),
                        icon: Icons.restaurant_menu_rounded,
                        ghostIcon: Icons.shopping_basket_outlined,
                        backgroundColor: const Color(0xFFFFF7F0),
                        iconColor: AppColors.primaryOrange,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodSafetyScreen())),
                      ),
                      QuickActionCard(
                        title: TranslationService.t('behavior_check'),
                        icon: Icons.psychology_rounded,
                        ghostIcon: Icons.help_outline_rounded,
                        backgroundColor: const Color(0xFFFFF7F0),
                        iconColor: AppColors.primaryOrange,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BehaviorAnalyzerScreen())),
                      ),
                      QuickActionCard(
                        title: TranslationService.t('medications'),
                        icon: Icons.medication_rounded,
                        ghostIcon: Icons.add_box_outlined,
                        backgroundColor: const Color(0xFFFFF7F0),
                        iconColor: AppColors.primaryOrange,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicationGuideScreen())),
                      ),
                      QuickActionCard(
                        title: TranslationService.t('wound_analyzer'),
                        icon: Icons.pets_rounded,
                        ghostIcon: Icons.camera_alt_outlined,
                        backgroundColor: const Color(0xFFFFF7F0),
                        iconColor: AppColors.primaryOrange,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WoundAiScreen())),
                      ),
                      QuickActionCard(
                        title: TranslationService.t('health_risks'),
                        icon: Icons.warning_rounded,
                        ghostIcon: Icons.info_outline_rounded,
                        backgroundColor: const Color(0xFFFFF7F0),
                        iconColor: AppColors.primaryOrange,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthRiskScreen())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 4. Dynamic Pet Tip Box
                  _buildPetTipBox(dog),

                  const SizedBox(height: 32),

                  // 5. About Section
                  _buildAboutSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(var dog) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryOrange,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryOrange, Color(0xFFB5722F)], // Solid brand orange gradient
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Language Switcher & Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildLanguageSwitcher(),
              const SizedBox(width: 12),
            ],
          ),
          
          const SizedBox(height: 10),

          // Greeting & Pet Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        TranslationService.t('good_morning'),
                        style: GoogleFonts.pangolin(
                          textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    TranslationService.t('hi_name', arg: dog.name),
                    style: GoogleFonts.pangolin(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${dog.breed} • ${dog.weight} kg",
                    style: GoogleFonts.pangolin(
                      textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
              // Pet Image (Using a CircleAvatar or similar)
              Hero(
                tag: 'pet_profile',
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PetProfileScreen())),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: const Center(
                      child: Text('🐶', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(TranslationService.t('last_checkup'), dog.lastCheckup, Icons.favorite_rounded),
              _buildStatCard(TranslationService.t('next_vaccine'), dog.nextVaccine, Icons.vaccines_rounded),
              _buildStatCard(TranslationService.t('weight'), "${dog.weight} kg", Icons.scale_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangBtn("EN", AppLanguage.en),
          _buildLangBtn("HI", AppLanguage.hi),
          _buildLangBtn("TE", AppLanguage.te),
          _buildLangBtn("TA", AppLanguage.ta),
        ],
      ),
    );
  }

  Widget _buildLangBtn(String label, AppLanguage lang) {
    bool isSelected = TranslationService().currentLanguage == lang;
    return GestureDetector(
      onTap: () => TranslationService().setLanguage(lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: GoogleFonts.pangolin(
            textStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: (MediaQuery.of(context).size.width - 72) / 3,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Lightened orange appearance over the orange header
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _AnimatedStatIcon(icon: icon),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPetTipBox(var dog) {
    final breedContent = PetProfileService().getBreedSpecificContent();
    final tip = breedContent['tip'] ?? "Keep your pet hydrated and happy!";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Tip for ${dog.breed}",
                style: GoogleFonts.pangolin(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tip,
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            "🐾",
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 12),
          Text(
            "Furrr",
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryOrange,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Your pet's all-in-one AI companion. From health tracking to food safety, we are here for every paw.",
              textAlign: TextAlign.center,
              style: GoogleFonts.pangolin(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Version 1.0.0",
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(
                fontSize: 12,
                color: Colors.black26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedStatIcon extends StatefulWidget {
  final IconData icon;
  const _AnimatedStatIcon({required this.icon});

  @override
  State<_AnimatedStatIcon> createState() => _AnimatedStatIconState();
}

class _AnimatedStatIconState extends State<_AnimatedStatIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(widget.icon, color: Colors.white70, size: 24),
    );
  }
}