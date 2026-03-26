import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Profile/pet_profile_screen.dart';
import '../../services/pet_profile_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/stacked_swiper.dart';
import '../SymptomChecker/symptom_checker_screen.dart';
import '../Behavior/behavior_analyzer_screen.dart';
import '../FoodSafety/food_safety_screen.dart';
import '../Meds/medication_guide_screen.dart';
import '../HealthRisk/health_risk_screen.dart';

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
  }

  @override
  void dispose() {
    PetProfileService().removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildHorizontalCalendar(),
              const SizedBox(height: 30),
              _buildHeroStatusCard(),
              const SizedBox(height: 32),
              _buildSectionHeader("ACTIVE CARE FOR ${PetProfileService().currentPet.name.toUpperCase()}!", showSeeAll: false),
              const SizedBox(height: 16),
              StackedCardSwiper(
                cards: [
                  OngoingTaskCard(
                    title: "Symptom Checker",
                    icon: Icons.health_and_safety_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SymptomCheckerScreen())),
                  ),
                  OngoingTaskCard(
                    title: "Medication Guide",
                    icon: Icons.medication_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicationGuideScreen())),
                  ),
                  OngoingTaskCard(
                    title: "Behavior Check",
                    icon: Icons.psychology_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BehaviorAnalyzerScreen())),
                  ),
                  OngoingTaskCard(
                    title: "Food Safety",
                    icon: Icons.restaurant_menu_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodSafetyScreen())),
                  ),
                  OngoingTaskCard(
                    title: "Health Risks",
                    icon: Icons.warning_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthRiskScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 40), // Spacing for end of scroll
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PetProfileScreen())),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2),
            ),
            child: const Center(
              child: Icon(Icons.pets, color: AppColors.primary, size: 24),
            ),
          ),
        ),
        _buildIconBtn(Icons.notifications_none_rounded),
      ],
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildHorizontalCalendar() {
    DateTime now = DateTime.now();
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: index));
          bool isSelected = date.day == now.day;
          
          return Container(
            width: 50,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.background : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      "${date.day}",
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "HELLO ${PetProfileService().currentPet.name.toUpperCase()},",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroStatusCard() {
    final dog = PetProfileService().currentPet;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
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
              _buildStatusMiniChip(dog.gender),
              const SizedBox(width: 8),
              _buildStatusMiniChip(dog.age),
            ],
          ),
          const SizedBox(height: 28),
          // Details Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem("Weight", "${dog.weight} kg", Icons.monitor_weight_outlined),
              _buildDetailItem("Last Checkup", dog.lastCheckup, Icons.history),
              _buildDetailItem("Next Due", dog.nextVaccine, Icons.event_available_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMiniChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textDark.withOpacity(0.6)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textDark.withOpacity(0.6),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallProgress() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Daily Routine Progress",
              style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Text("56%", style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        const LinearProgressIndicator(
          value: 0.56,
          backgroundColor: Color(0x33000000),
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textDark),
          minHeight: 8,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        if (showSeeAll)
          const Row(
            children: [
              Text("See all", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
            ],
          ),
      ],
    );
  }
}

class StackedAvatars extends StatelessWidget {
  const StackedAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 30,
      child: Stack(
        children: [
          _buildAvatar(0),
          _buildAvatar(15),
          _buildAvatar(30),
        ],
      ),
    );
  }

  Widget _buildAvatar(double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1.5),
          image: const DecorationImage(
            image: NetworkImage('https://i.pravatar.cc/100'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}