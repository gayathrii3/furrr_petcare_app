import 'dart:ui' show ImageFilter;
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGlassDashboard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildHorizontalCalendar(),
                    const SizedBox(height: 20),
                    _buildHeroStatusCard(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 40), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDashboard({required Widget child}) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          // 1. The Glass Shape & Content
          ClipPath(
            clipper: DashboardClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25), // Increased blur for Stomer style
              child: Container(
                // Full padding to clear the "ears" and dip area
                padding: const EdgeInsets.only(top: 65, left: 24, right: 24, bottom: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.15),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                ),
                child: child,
              ),
            ),
          ),
          // 2. The Border Layer - Positioned.fill ensures it captures the full height
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: DashboardBorderPainter(),
              ),
            ),
          ),
        ],
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

class DashboardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double radius = 38; // Slightly larger for smoother look
    double sideMargin = 2; // Almost full width
    double topPadding = 0;
    double earWidth = 100; // Refined ear width
    double dipHeight = 35; // Depth of the head dip
    
    // Start at bottom left
    path.moveTo(sideMargin, size.height - radius);
    
    // Left side going up into the ear
    path.lineTo(sideMargin, dipHeight + topPadding + radius + 10);
    
    // Left Ear - Organic smooth parabolic curve
    path.cubicTo(
      sideMargin, topPadding + 5, 
      sideMargin + 20, topPadding, 
      sideMargin + radius + 15, topPadding
    );
    
    path.lineTo(sideMargin + earWidth - radius - 15, topPadding);
    
    // Smooth transition to the Dip
    path.cubicTo(
      sideMargin + earWidth - 10, topPadding,
      sideMargin + earWidth, topPadding + 10,
      sideMargin + earWidth, dipHeight + topPadding
    );
    
    // Middle Dip - Flat connecting line
    path.lineTo(size.width - sideMargin - earWidth, dipHeight + topPadding);
    
    // Right Ear - Perfect mirror of Left
    path.cubicTo(
      size.width - sideMargin - earWidth, topPadding + 10,
      size.width - sideMargin - earWidth + 10, topPadding,
      size.width - sideMargin - earWidth + radius + 15, topPadding
    );
    
    path.lineTo(size.width - sideMargin - radius - 15, topPadding);
    
    path.cubicTo(
      size.width - sideMargin - 20, topPadding,
      size.width - sideMargin, topPadding + 5,
      size.width - sideMargin, dipHeight + topPadding + radius + 10
    );
    
    // Right side going down
    path.lineTo(size.width - sideMargin, size.height - radius);
    
    // Bottom right corner
    path.quadraticBezierTo(
      size.width - sideMargin, size.height,
      size.width - sideMargin - radius, size.height
    );
    
    // Bottom side
    path.lineTo(sideMargin + radius, size.height);
    
    // Bottom left corner
    path.quadraticBezierTo(
      sideMargin, size.height,
      sideMargin, size.height - radius
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class DashboardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = DashboardClipper().getClip(size);
    
    // 1. Neon Outer Glow (Layer 1 - Soft Spread)
    var glowPaint1 = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawPath(path, glowPaint1);

    // 2. Main Solid Yellow Border (Solid core)
    var borderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.8; 
    canvas.drawPath(path, borderPaint);
    
    // 3. Specular Edge Highlight (Adds glass depth)
    var highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, highlightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
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