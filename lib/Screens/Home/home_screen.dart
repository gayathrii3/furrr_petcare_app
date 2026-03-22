import 'package:flutter/material.dart';
import '../../widgets/language_selector.dart';
import '../Profile/pet_profile_screen.dart';
import '../../models/dog_profile.dart';
import '../../widgets/quick_action_card.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../Wound Analyzer/woundAI_screen.dart';
import '../HealthRisk/health_risk_screen.dart';
import '../FoodSafety/food_safety_screen.dart';
import '../Meds/medication_guide_screen.dart';
import '../Services/find_walker_screen.dart';
import '../Behavior/behavior_analyzer_screen.dart';
import '../SymptomChecker/symptom_checker_screen.dart';
import '../../theme/app_colors.dart';

class FurrrHomePage extends StatefulWidget {
  const FurrrHomePage({super.key});

  @override
  State<FurrrHomePage> createState() => _FurrrHomePageState();
}

class _FurrrHomePageState extends State<FurrrHomePage> {
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

  String t(String key) => TranslationService.t(key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopSection(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildVetTip(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.eco_outlined,
                            color: AppColors.primary.withOpacity(0.8),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              t('good_morning'),
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        TranslationService.t('hi_name', arg: PetProfileService().currentPet.name),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${PetProfileService().currentPet.breed} · ${PetProfileService().currentPet.weight}kg",
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LanguageSelector(
                    selectedLanguage: TranslationService().currentLanguage,
                    onLanguageChanged: (language) {
                      TranslationService().setLanguage(language);
                    },
                    darkMode: true,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PetProfileScreen()),
                      );
                    },
                    child: const JumpingDog(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: HeaderStatCard(
                  icon: Icons.favorite_border,
                  title: t('last_checkup'),
                  value: PetProfileService().currentPet.lastCheckup.contains('2025') 
                    ? PetProfileService().currentPet.lastCheckup.split('-').reversed.take(2).join('/')
                    : "12 Jan",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HeaderStatCard(
                  icon: Icons.vaccines_outlined,
                  title: t('next_vaccine'),
                  value: PetProfileService().currentPet.nextVaccine.contains('2025')
                    ? PetProfileService().currentPet.nextVaccine.split('-').reversed.take(2).join('/')
                    : "20 Mar",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HeaderStatCard(
                  icon: Icons.balance_outlined,
                  title: t('weight'),
                  value: "${PetProfileService().currentPet.weight} kg",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t('quick_actions'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    TranslationService.t('for_name', arg: PetProfileService().currentPet.name),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F8B73),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.03,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              QuickActionCard(
                title: t('check_symptoms'),
                icon: Icons.search,
                bgColor: AppColors.surface,
                iconColor: AppColors.primary,
                faintIcon: Icons.medical_services_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SymptomCheckerScreen(),
                    ),
                  );
                },
              ),
              QuickActionCard(
                title: t('food_safety'),
                icon: Icons.rice_bowl,
                bgColor: AppColors.surface,
                iconColor: const Color(0xFF4A90E2),
                faintIcon: Icons.restaurant_menu,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FoodSafetyScreen(),
                    ),
                  );
                },
              ),
              QuickActionCard(
                title: t('behavior_check'),
                icon: Icons.psychology_outlined,
                bgColor: AppColors.surface,
                iconColor: const Color(0xFFA55EEA),
                faintIcon: Icons.psychology_alt_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BehaviorAnalyzerScreen(),
                    ),
                  );
                },
              ),
              QuickActionCard(
                title: t('medications'),
                icon: Icons.medication_outlined,
                bgColor: AppColors.surface,
                iconColor: AppColors.accent,
                faintIcon: Icons.medication_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MedicationGuideScreen(),
                    ),
                  );
                },
              ),
              QuickActionCard(
                title: t('health_risks'),
                icon: Icons.pets,
                bgColor: AppColors.surface,
                iconColor: const Color(0xFFEB3B5A),
                faintIcon: Icons.pets_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HealthRiskScreen(),
                    ),
                  );
                },
              ),
              QuickActionCard(
                title: t('pet_services'),
                icon: Icons.storefront_outlined,
                bgColor: AppColors.surface,
                iconColor: const Color(0xFF2bcbba),
                faintIcon: Icons.pets_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FindWalkerScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVetTip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const JumpingBulb(),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t('pet_care_tip'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Color(0xFF8A6A1F),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              PetProfileService().getBreedSpecificContent()['tip'] ?? t('tip_content'),
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const HeaderStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.85),
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class JumpingDog extends StatefulWidget {
  const JumpingDog({super.key});

  @override
  State<JumpingDog> createState() => _JumpingDogState();
}

class _JumpingDogState extends State<JumpingDog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.pets,
              color: AppColors.primary,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}

class JumpingBulb extends StatefulWidget {
  const JumpingBulb({super.key});

  @override
  State<JumpingBulb> createState() => _JumpingBulbState();
}

class _JumpingBulbState extends State<JumpingBulb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: const Icon(
            Icons.lightbulb,
            color: Color(0xFF8A6A1F),
            size: 24,
          ),
        );
      },
    );
  }
}