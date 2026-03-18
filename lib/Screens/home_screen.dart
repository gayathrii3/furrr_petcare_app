import 'package:flutter/material.dart';
import 'package:furrr/screens/woundAi_screen.dart';

enum AppLanguage { en, hi, te, ta }

class FurrrHomePage extends StatefulWidget {
  const FurrrHomePage({super.key});

  @override
  State<FurrrHomePage> createState() => _FurrrHomePageState();
}

class _FurrrHomePageState extends State<FurrrHomePage> {
  AppLanguage selectedLanguage = AppLanguage.en;

  String t(String en, String hi, String te, String ta) {
    switch (selectedLanguage) {
      case AppLanguage.en:
        return en;
      case AppLanguage.hi:
        return hi;
      case AppLanguage.te:
        return te;
      case AppLanguage.ta:
        return ta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F3),
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
            Color(0xFF0B5D3B),
            Color(0xFF1F8A5F),
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
                          const Icon(
                            Icons.eco_outlined,
                            color: Color(0xFFEAF8EE),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              t(
                                "Good morning!",
                                "सुप्रभात!",
                                "శుభోదయం!",
                                "காலை வணக்கம்!",
                              ),
                              style: const TextStyle(
                                color: Color(0xFFF0FFF4),
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
                        t(
                          "Hi, Brownie!",
                          "हाय, ब्राउनी!",
                          "హాయ్, బ్రౌనీ!",
                          "ஹாய், பிரௌனி!",
                        ),
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
                        t(
                          "Pug · 8kg",
                          "पग · 8किग्रा",
                          "పగ్ · 8కిలోలు",
                          "பக் · 8கிலோ",
                        ),
                        style: const TextStyle(
                          color: Color(0xFFE3F6E8),
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
                    selectedLanguage: selectedLanguage,
                    onLanguageChanged: (language) {
                      setState(() {
                        selectedLanguage = language;
                      });
                    },
                    darkMode: true,
                  ),
                  const SizedBox(height: 10),
                  const JumpingDog(),
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
                  title: t(
                    "Last checkup",
                    "अंतिम चेकअप",
                    "చివరి చెకప్",
                    "கடைசி பரிசோதனை",
                  ),
                  value: "12 Jan",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HeaderStatCard(
                  icon: Icons.vaccines_outlined,
                  title: t(
                    "Next vaccine",
                    "अगला टीका",
                    "తదుపరి టీకా",
                    "அடுத்த தடுப்பூசி",
                  ),
                  value: "20 Mar",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HeaderStatCard(
                  icon: Icons.balance_outlined,
                  title: t(
                    "Weight",
                    "वजन",
                    "బరువు",
                    "எடை",
                  ),
                  value: "8 kg",
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
                  t(
                    "Quick Actions",
                    "त्वरित कार्य",
                    "త్వరిత చర్యలు",
                    "விரைவு செயல்கள்",
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF183326),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    t(
                      "for Brownie",
                      "ब्राउनी के लिए",
                      "బ్రౌనీ కోసం",
                      "பிரௌனிக்காக",
                    ),
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
                title: t(
                  "Check Symptoms",
                  "लक्षण जांचें",
                  "లక్షణాలు చూడండి",
                  "அறிகுறிகள் பார்க்க",
                ),
                icon: Icons.search,
                bgColor: const Color(0xFFD8F1E3),
                iconColor: const Color(0xFF0B5D3B),
                faintIcon: Icons.medical_services_outlined,
              ),
              QuickActionCard(
                title: t(
                  "Food Safety",
                  "भोजन सुरक्षा",
                  "ఆహార భద్రత",
                  "உணவு பாதுகாப்பு",
                ),
                icon: Icons.rice_bowl,
                bgColor: const Color(0xFFD7E8FF),
                iconColor: const Color(0xFF2459A8),
                faintIcon: Icons.rice_bowl,
              ),
              QuickActionCard(
                title: t(
                  "Behavior Check",
                  "व्यवहार जांच",
                  "ప్రవర్తన తనిఖీ",
                  "நடத்தை சோதனை",
                ),
                icon: Icons.psychology_outlined,
                bgColor: const Color(0xFFE7DBF7),
                iconColor: const Color(0xFF6E3CBC),
                faintIcon: Icons.psychology_alt_outlined,
              ),
              QuickActionCard(
                title: t(
                  "Medications",
                  "दवाइयाँ",
                  "మందులు",
                  "மருந்துகள்",
                ),
                icon: Icons.medication_outlined,
                bgColor: const Color(0xFFFFE8C7),
                iconColor: const Color(0xFFD97706),
                faintIcon: Icons.medication_outlined,
              ),
              QuickActionCard(
                title: t(
                  "Health Risks",
                  "स्वास्थ्य जोखिम",
                  "ఆరోగ్య ప్రమాదాలు",
                  "ஆரோக்கிய ஆபத்துகள்",
                ),
                icon: Icons.pets,
                bgColor: const Color(0xFFFFD9E2),
                iconColor: const Color(0xFFB4235A),
                faintIcon: Icons.pets_outlined,
              ),
              QuickActionCard(
                title: t(
                  "Find Walker",
                  "वॉकर ढूंढें",
                  "వాకర్ కనుగొనండి",
                  "வாக்கரை கண்டுபிடி",
                ),
                icon: Icons.directions_walk_outlined,
                bgColor: const Color(0xFFD7F2F4),
                iconColor: const Color(0xFF0F7C8C),
                faintIcon: Icons.accessibility_new_outlined,
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
          color: const Color(0xFFFFF4D6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
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
                    t(
                      "PET CARE TIP",
                      "पेट केयर टिप",
                      "పెట్ కేర్ చిట్కా",
                      "செல்லப்பிராணி பராமரிப்பு குறிப்பு",
                    ),
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
              t(
                "Keep your pet hydrated, follow vaccine schedules, and watch for unusual behavior like low energy, poor appetite, or itching.",
                "अपने पालतू को हाइड्रेट रखें, टीकाकरण समय पर करवाएँ, और कम ऊर्जा, भूख कम लगना या खुजली जैसे संकेतों पर ध्यान दें।",
                "మీ పెంపుడు జంతువుకు నీరు సరిపడా ఇవ్వండి, టీకాలు సమయానికి వేయించండి, అలసట, ఆకలి తగ్గడం, దురద వంటి లక్షణాలను గమనించండి.",
                "உங்கள் செல்லப்பிராணிக்கு போதுமான தண்ணீர் கொடுக்கவும், தடுப்பூசிகளை நேரத்தில் போடவும், சோர்வு, பசி குறைவு, அரிப்பு போன்ற அறிகுறிகளை கவனிக்கவும்.",
              ),
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF4A3B12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final AppLanguage selectedLanguage;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.selectedLanguage,
  });

  String t(String en, String hi, String te, String ta) {
    switch (selectedLanguage) {
      case AppLanguage.en:
        return en;
      case AppLanguage.hi:
        return hi;
      case AppLanguage.te:
        return te;
      case AppLanguage.ta:
        return ta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0x22000000)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: BottomNavItem(
              icon: Icons.home,
              label: t("Home", "होम", "హోమ్", "ஹோம்"),
              selected: selectedIndex == 0,
              onTap: () {},
            ),
          ),
          Expanded(
            child: BottomNavItem(
              icon: Icons.medical_services,
              label: t("Wound AI", "वाउंड AI", "వౌండ్ AI", "வுண்ட் AI"),
              selected: selectedIndex == 1,
              onTap: () {
                Navigator.of(context).push(
  PageRouteBuilder(
    opaque: false,
    barrierColor: Colors.transparent,
    pageBuilder: (context, _, __) => const WoundAiScreen(),
  ),
);
              },
            ),
          ),
          Expanded(
            child: BottomNavItem(
              icon: Icons.local_hospital,
              label: t("Vets", "वेट्स", "వెట్స్", "வெட்ஸ்"),
              selected: selectedIndex == 2,
              onTap: () {},
            ),
          ),
          Expanded(
            child: BottomNavItem(
              icon: Icons.groups,
              label: t("Community", "समुदाय", "కమ్యూనిటీ", "சமூகம்"),
              selected: selectedIndex == 3,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final bool darkMode;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    const selectedBg = Color(0xFF2D6A4F);
    const selectedText = Colors.white;
    const unselectedText = Colors.white70;

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 10,
      runSpacing: 8,
      children: [
        _langChip("EN", AppLanguage.en, selectedBg, selectedText, unselectedText),
        _langChip("HI", AppLanguage.hi, selectedBg, selectedText, unselectedText),
        _langChip("TE", AppLanguage.te, selectedBg, selectedText, unselectedText),
        _langChip("TA", AppLanguage.ta, selectedBg, selectedText, unselectedText),
      ],
    );
  }

  Widget _langChip(
    String label,
    AppLanguage language,
    Color selectedBg,
    Color selectedText,
    Color unselectedText,
  ) {
    final isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () => onLanguageChanged(language),
      child: Container(
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isSelected ? selectedText : unselectedText,
          ),
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
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
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

class QuickActionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final IconData faintIcon;
  final Color bgColor;
  final Color iconColor;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.faintIcon,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.94;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white,
              width: 1.2,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  widget.faintIcon,
                  size: 22,
                  color: widget.iconColor.withOpacity(0.18),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Icon(
                    widget.icon,
                    size: 38,
                    color: widget.iconColor,
                  ),
                  const Spacer(),
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.iconColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: selected
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFDDEFE3) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              size: 22,
              color: selected
                  ? const Color(0xFF0B5D3B)
                  : const Color(0xFF476555),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: selected
                  ? const Color(0xFF0B5D3B)
                  : const Color(0xFF476555),
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: const Text(
            "🐶",
            style: TextStyle(fontSize: 72),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: const Icon(
            Icons.lightbulb_outline,
            color: Color(0xFFD97706),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}