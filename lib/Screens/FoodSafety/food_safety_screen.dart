import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_search_bar.dart';
import '../../models/ai_food_analysis.dart';
import '../../services/ai_analysis_service.dart';
import '../../services/tts_service.dart';
import '../../services/persistent_cache_service.dart';
import 'dart:ui';

enum SafetyLevel { safe, caution, toxic }

class FoodItem {
  final String name;
  final SafetyLevel level;
  final String description;

  const FoodItem({
    required this.name,
    required this.level,
    required this.description,
  });
}

class FoodSafetyScreen extends StatefulWidget {
  const FoodSafetyScreen({super.key});

  @override
  State<FoodSafetyScreen> createState() => _FoodSafetyScreenState();
}

class _FoodSafetyScreenState extends State<FoodSafetyScreen> {
  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged);
    TtsService().init();
    
    // Show breed-specific warning once on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBreedWarningToast();
    });
  }

  void _showBreedWarningToast() {
    final pet = PetProfileService().currentPet;
    final content = PetProfileService().getBreedSpecificContent();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Warning for ${pet.breed}: ${content['food_warning']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    TtsService().stop();
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
  final List<FoodItem> _allFoods = const [
    FoodItem(name: "Pumpkin", level: SafetyLevel.safe, description: "Great for digestion and fiber."),
    FoodItem(name: "Blueberries", level: SafetyLevel.safe, description: "Antioxidant-rich treat."),
    FoodItem(name: "Chocolate", level: SafetyLevel.toxic, description: "Contains theobromine, highly toxic to dogs."),
    FoodItem(name: "Grapes & Raisins", level: SafetyLevel.toxic, description: "Can cause sudden kidney failure."),
    FoodItem(name: "Onion & Garlic", level: SafetyLevel.toxic, description: "Causes red blood cell damage."),
    FoodItem(name: "Plain Roti", level: SafetyLevel.caution, description: "Fine in moderation, but no ghee or spices."),
    FoodItem(name: "Paneer (Plain)", level: SafetyLevel.safe, description: "Good protein, but avoid if lactose intolerant."),
    FoodItem(name: "Cooked Rice", level: SafetyLevel.safe, description: "Bland and easy on the stomach."),
    FoodItem(name: "Ghee", level: SafetyLevel.caution, description: "High fat, can cause pancreatitis in excess."),
    FoodItem(name: "Xylitol (Sweetener)", level: SafetyLevel.toxic, description: "Found in sugar-free gum, extremely dangerous."),
    FoodItem(name: "Avocado", level: SafetyLevel.toxic, description: "Contains persin, can cause vomiting/diarrhea."),
    FoodItem(name: "Papaya", level: SafetyLevel.safe, description: "Safe and healthy, remove all seeds."),
    FoodItem(name: "Masala/Spices", level: SafetyLevel.toxic, description: "Can irritate the stomach and cause toxicity."),
  ];

  String _searchQuery = "";
  bool _isAnalyzing = false;
  AiFoodAnalysis? _aiAnalysis;


  Future<void> _performAiSecurityCheck(String food) async {
    if (food.trim().isEmpty) return;

    // 1. Check Memory Cache first
    final memoryCached = PetProfileService().getFoodCached(food);
    if (memoryCached != null) {
      if (mounted) setState(() { _aiAnalysis = memoryCached; _isAnalyzing = false; });
      return;
    }

    // 2. Check Persistent Cache
    final persistentCached = await PersistentCacheService().getFood(food);
    if (persistentCached != null) {
      PetProfileService().cacheFood(food, persistentCached);
      if (mounted) setState(() { _aiAnalysis = persistentCached; _isAnalyzing = false; });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _aiAnalysis = null;
    });

    try {
      final pet = PetProfileService().currentPet;
      final result = await AiAnalysisService().analyzeFoodSafety(food, pet);
      
      setState(() {
        _aiAnalysis = result;
      });

      // 3. Save to both caches
      if (result.safetyLevel != "Error") {
        PetProfileService().cacheFood(food, result);
        await PersistentCacheService().saveFood(food, result);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Analysis failed: $e")),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _allFoods
        .where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: const CustomBackButton(),
          leadingWidth: 60,
          title: Text(
            TranslationService.t('food_safety'),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: TranslationService.t('all')),
              Tab(text: TranslationService.t('safe')),
              Tab(text: TranslationService.t('toxic')),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            if (_aiAnalysis != null) _buildAiAnalysisResult(),
            if (_isAnalyzing) 
              _buildLoadingState()
            else if (_aiAnalysis == null) ...[
              Center(
                child: Lottie.asset(
                  'assets/animations/foody.json',
                  height: 150,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildFoodList(filteredFoods),
                    _buildFoodList(filteredFoods.where((f) => f.level == SafetyLevel.safe).toList()),
                    _buildFoodList(filteredFoods.where((f) => f.level == SafetyLevel.toxic).toList()),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/foody.json', height: 200),
            const SizedBox(height: 20),
            const Text(
              "Furrr AI is analyzing...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Checking safety for ${PetProfileService().currentPet.breed}s",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAnalysisResult() {
    if (_aiAnalysis == null) return const SizedBox.shrink();
    
    final analysis = _aiAnalysis!;
    Color mainColor;
    IconData icon;

    switch (analysis.safetyLevel.toLowerCase()) {
      case 'safe':
        mainColor = AppColors.primary;
        icon = Icons.check_circle_rounded;
        break;
      case 'caution':
        mainColor = AppColors.accent;
        icon = Icons.warning_rounded;
        break;
      case 'toxic':
        mainColor = AppColors.error;
        icon = Icons.dangerous_rounded;
        break;
      default:
        mainColor = AppColors.textSecondary;
        icon = Icons.help_outline_rounded;
    }

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: mainColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(icon, color: mainColor, size: 60),
                  const SizedBox(height: 12),
                  Text(
                    analysis.safetyLevel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: mainColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    analysis.foodName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    onPressed: () {
                      final textToSpeak = "${analysis.foodName} is ${analysis.safetyLevel}. ${analysis.breedNuance} ${analysis.description}";
                      TtsService().speak(textToSpeak);
                    },
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const Text(
                    "Read Aloud",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Breed Nuance Card (Glassmorphism style)
            _buildResultSection(
              title: "Specific for your ${PetProfileService().currentPet.breed}",
              content: analysis.breedNuance,
              icon: Icons.pets_rounded,
              color: AppColors.primary,
            ),
            
            _buildResultSection(
              title: "Detailed Explanation",
              content: analysis.description,
              icon: Icons.description_rounded,
              color: AppColors.textPrimary,
            ),

            if (analysis.symptoms.isNotEmpty)
              _buildListSection(
                title: "Symptoms to Watch",
                items: analysis.symptoms,
                icon: Icons.visibility_rounded,
                color: AppColors.error,
              ),

            _buildListSection(
              title: "Recommended Actions",
              items: analysis.actionSteps,
              icon: Icons.flash_on_rounded,
              color: AppColors.accent,
            ),

            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => setState(() => _aiAnalysis = null),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Search another food"),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection({required String title, required String content, required IconData icon, required Color color}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection({required String title, required List<String> items, required IconData icon, required Color color}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 14))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          CustomSearchBar(
            hintText: "Search any food (e.g. Avocado, Paneer)...",
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                // If user starts typing again, clear AI results
                if (_aiAnalysis != null && value.toLowerCase() != _aiAnalysis!.foodName.toLowerCase()) {
                  _aiAnalysis = null;
                }
              });
            },
          ),
          if (_searchQuery.isNotEmpty && _aiAnalysis == null) 
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InkWell(
                onTap: () => _performAiSecurityCheck(_searchQuery),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Ask Furrr AI about this food",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodList(List<FoodItem> foods) {
    if (foods.isEmpty) {
      return const Center(child: Text("No food items found."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return _buildFoodCard(food);
      },
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    Color cardColor;
    IconData icon;
    Color textColor;

    switch (food.level) {
      case SafetyLevel.safe:
        cardColor = AppColors.primary.withOpacity(0.15);
        icon = Icons.check_circle_outline;
        textColor = AppColors.primary;
        break;
      case SafetyLevel.caution:
        cardColor = AppColors.accent.withOpacity(0.15);
        icon = Icons.warning_amber_rounded;
        textColor = AppColors.accent;
        break;
      case SafetyLevel.toxic:
        cardColor = AppColors.error.withOpacity(0.15);
        icon = Icons.cancel_outlined;
        textColor = AppColors.error;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _performAiSecurityCheck(food.name),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: textColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        food.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

