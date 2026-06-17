import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../services/persistent_cache_service.dart';
import '../../services/ai_analysis_service.dart';
import '../../config/api_config.dart';

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
import '../../widgets/quick_action_card.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class FurrrHomePage extends StatefulWidget {
  const FurrrHomePage({super.key});

  @override
  State<FurrrHomePage> createState() => _FurrrHomePageState();
}

class _FurrrHomePageState extends State<FurrrHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isBarking = false;
  
  // Real high-quality sound URLs from Google/Firebase
  final List<String> _barkSounds = [
    'https://actions.google.com/sounds/v1/animals/dog_barking.ogg',
    'https://actions.google.com/sounds/v1/animals/small_dog_barking.ogg',
    'https://actions.google.com/sounds/v1/animals/canine_barking.ogg',
  ];

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    PetProfileService().addListener(_onProfileChanged);
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    PetProfileService().removeListener(_onProfileChanged);
    TranslationService().removeListener(_onLanguageChanged);
    _lottieController.dispose();
    _audioPlayer.dispose();
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
                        title: _isBarking ? "STOP PLAYING" : "Bark & Play",
                        icon: _isBarking ? Icons.stop_circle_rounded : Icons.music_note_rounded,
                        ghostIcon: Icons.pets_rounded,
                        backgroundColor: _isBarking ? const Color(0xFFE0E0E0) : const Color(0xFFFFF7F0), 
                        iconColor: _isBarking ? Colors.black54 : AppColors.primaryOrange,
                        onTap: _toggleBark,
                       ),
                      QuickActionCard(
                        title: TranslationService.t('health_risks'),
                        icon: Icons.menu_book_rounded,
                        ghostIcon: Icons.library_books_outlined,
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
          // 1. Top Bar: Profile (Left) & Actions (Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🖼️ Pet Image (Top Left)
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PetProfileScreen()),
                ),
                child: Hero(
                  tag: 'pet_profile',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/pet_profile.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          "assets/images/splash_mascot.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 🔔 Actions (Top Right)
              Row(
                children: [
                  _buildLanguageSwitcher(),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _showSettingsDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.settings, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 10),

          // 2. Greeting & Pet Info
          Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const _PulseIcon(icon: Icons.wb_sunny_outlined, color: Colors.white70, size: 18),
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
                          "${dog.breed} • ${dog.age} • ${dog.weight} kg",
                          style: GoogleFonts.pangolin(
                            textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -60,
                top: -10,
                child: Lottie.asset(
                  'assets/animations/flirting_dog.json',
                  height: 150, // "Little big"
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Stats Row
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildStatCard(TranslationService.t('last_checkup'), dog.lastCheckup, Icons.favorite_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard(TranslationService.t('next_vaccine'), dog.nextVaccine, Icons.vaccines_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard(TranslationService.t('weight'), "${dog.weight} kg", Icons.scale_rounded)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) async {
    final cacheService = PersistentCacheService();
    final currentKey = await cacheService.getUserGeminiKey();
    final textController = TextEditingController(text: currentKey);
    bool testing = false;
    String testResult = "";
    bool testSuccess = false;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: const Color(0xFFFFF7F0), // Matching the warm dialog background
              title: Row(
                children: [
                  const Icon(Icons.settings_suggest_rounded, color: AppColors.primaryOrange, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    "AI Settings",
                    style: GoogleFonts.pangolin(
                      textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "To keep this app 100% free, all AI features (wound analyzer, behavior analyzer, symptom checker) can run using your own free Gemini API key.",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse("https://aistudio.google.com/app/apikey");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          "👉 Get a free Gemini API Key from Google AI Studio",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Gemini API Key",
                      style: GoogleFonts.pangolin(
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: textController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "AIzaSy...",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
                        ),
                      ),
                    ),
                    if (testResult.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            testSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                            color: testSuccess ? Colors.green : Colors.red,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              testResult,
                              style: TextStyle(
                                color: testSuccess ? Colors.green.shade800 : Colors.red.shade800,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentKey.isNotEmpty)
                          TextButton.icon(
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            onPressed: () async {
                              await cacheService.saveUserGeminiKey("");
                              AiAnalysisService.init(""); // fallback to env
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Custom API Key removed. Using default configuration."),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.grey.shade800,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete_forever_rounded, size: 18),
                            label: const Text("Remove"),
                          )
                        else
                          const SizedBox.shrink(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryOrange,
                            side: const BorderSide(color: AppColors.primaryOrange),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: testing
                              ? null
                              : () async {
                                  final testKey = textController.text.trim();
                                  if (testKey.isEmpty) {
                                    setState(() {
                                      testResult = "Please paste an API key first.";
                                      testSuccess = false;
                                    });
                                    return;
                                  }
                                  setState(() {
                                    testing = true;
                                    testResult = "Testing API connection...";
                                  });
                                  try {
                                    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: testKey);
                                    final response = await model.generateContent([Content.text('hi')]);
                                    if (response.text != null) {
                                      setState(() {
                                        testResult = "Connection successful! Key is valid.";
                                        testSuccess = true;
                                        testing = false;
                                      });
                                    } else {
                                      setState(() {
                                        testResult = "Failed: Received an empty response.";
                                        testSuccess = false;
                                        testing = false;
                                      });
                                    }
                                  } catch (e) {
                                    setState(() {
                                      testResult = "Failed: ${e.toString().contains("400") ? "Invalid API Key." : e.toString()}";
                                      testSuccess = false;
                                      testing = false;
                                    });
                                  }
                                },
                          child: testing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryOrange),
                                )
                              : const Text("Test Key"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final key = textController.text.trim();
                    await cacheService.saveUserGeminiKey(key);
                    AiAnalysisService.init(key.isNotEmpty ? key : ApiConfig.geminiKey);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(key.isEmpty
                              ? "API settings cleared. Using default fallback."
                              : "Gemini API Key saved successfully!"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green.shade800,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  child: const Text("Save Key"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageSwitcher() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
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
          color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2), // Lightened orange appearance over the orange header
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _PulseIcon(icon: icon, color: Colors.white70, size: 24),
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
        border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                  color: AppColors.primaryOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const _PulseIcon(
                  icon: Icons.lightbulb_rounded,
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

  void _toggleBark() async {
    try {
      if (_isBarking) {
        // Stop Barking
        setState(() => _isBarking = false);
        await _audioPlayer.stop();
        _lottieController.stop();
      } else {
        // Start Barking
        setState(() => _isBarking = true);
        final randomUrl = _barkSounds[Random().nextInt(_barkSounds.length)];
        
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.play(UrlSource(randomUrl));
        
        _lottieController.repeat();
      }
    } catch (e) {
      print("Error toggling bark: $e");
    }
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Custom Mascot SVG replacing the Paw Icon
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent, // transparent to blend with theme
            ),
            child: Lottie.asset(
              'assets/animations/footer_mascot.json',
              height: 120,
              fit: BoxFit.contain,
              controller: _lottieController,
              onLoaded: (composition) {
                // Reduced speed: 1.5x instead of 3x
                _lottieController.duration = composition.duration * 2 ~/ 3;
                _lottieController.repeat();
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Furrrr",
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

class _PulseIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  const _PulseIcon({required this.icon, required this.color, this.size = 24});

  @override
  State<_PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<_PulseIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.92, end: 1.08).animate(
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
      child: Icon(widget.icon, color: widget.color, size: widget.size),
    );
  }
}