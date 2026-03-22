import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../theme/app_colors.dart';

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
            _buildBreedWarning(),
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
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Search food (e.g. Roti, Apple)...",
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          filled: true,
          fillColor: AppColors.primary.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: AppColors.textPrimary),
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
      padding: const EdgeInsets.all(16),
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
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
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
    );
  }

  Widget _buildBreedWarning() {
    final pet = PetProfileService().currentPet;
    final content = PetProfileService().getBreedSpecificContent();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Warning for ${pet.breed}: ${content['food_warning']}",
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

