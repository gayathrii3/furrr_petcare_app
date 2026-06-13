import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_search_bar.dart';
import '../../models/ai_medication_analysis.dart';
import '../../services/ai_analysis_service.dart';
import '../../services/tts_service.dart';
import '../../services/persistent_cache_service.dart';

class Medication {
  final String name;
  final String dosage;
  final String use;
  final String warning;

  const Medication({
    required this.name,
    required this.dosage,
    required this.use,
    required this.warning,
  });
}

class MedicationGuideScreen extends StatefulWidget {
  const MedicationGuideScreen({super.key});

  @override
  State<MedicationGuideScreen> createState() => _MedicationGuideScreenState();
}

class _MedicationGuideScreenState extends State<MedicationGuideScreen> {


  final TextEditingController _searchController = TextEditingController();
  List<Medication> _filteredMeds = [];

  final List<Medication> _meds = const [
    Medication(
      name: "Benadryl",
      dosage: "1mg per lb (2.2mg per kg)",
      use: "Allergies, stings, anxiety.",
      warning: "Ensure it only contains Diphenhydramine. Avoid decongestants.",
    ),
    Medication(
      name: "Aspirin",
      dosage: "5-10mg per lb (10-20mg per kg)",
      use: "Pain relief, anti-inflammatory.",
      warning: "Can cause stomach ulcers. Never give to cats. Consult vet first.",
    ),
    Medication(
      name: "Melatonin",
      dosage: "1-6mg depending on size",
      use: "Anxiety, sleep issues, fireworks.",
      warning: "Check for Xylitol in the ingredients. Use plain melatonin only.",
    ),
    Medication(
      name: "Pepcid",
      dosage: "0.25-0.5mg per lb (0.5-1mg per kg)",
      use: "Acid reflux, stomach upset.",
      warning: "Consult a vet if your pet has kidney or heart disease.",
    ),
  ];
  
  bool _isAnalyzing = false;
  AiMedicationAnalysis? _aiAnalysis;


  Future<void> _performAiSecurityCheck(String medication) async {
    if (medication.trim().isEmpty) return;

    // 1. Check Memory Cache first
    final memoryCached = PetProfileService().getMedCached(medication);
    if (memoryCached != null) {
      if (mounted) setState(() { _aiAnalysis = memoryCached; _isAnalyzing = false; });
      return;
    }

    // 2. Check Persistent Cache
    final persistentCached = await PersistentCacheService().getMed(medication);
    if (persistentCached != null) {
      PetProfileService().cacheMed(medication, persistentCached);
      if (mounted) setState(() { _aiAnalysis = persistentCached; _isAnalyzing = false; });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _aiAnalysis = null;
    });

    try {
      final pet = PetProfileService().currentPet;
      final result = await AiAnalysisService().analyzeMedicationSafety(medication, pet);
      
      setState(() {
        _aiAnalysis = result;
      });

      // 3. Save to both caches
      if (result.safetyLevel != "Error") {
        PetProfileService().cacheMed(medication, result);
        await PersistentCacheService().saveMed(medication, result);
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
  void initState() {
    super.initState();
    _filteredMeds = List.from(_meds);
    _searchController.addListener(_onSearchChanged);
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged);
    TtsService().init();
    
    // Show vet caution once on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showVetCautionToast();
    });
  }

  void _showVetCautionToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "IMPORTANT: Always consult your vet before giving any medication.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    TtsService().stop();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
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

  void _onSearchChanged() {
    _filterMeds(_searchController.text);
  }

  void _filterMeds(String query) {
    setState(() {
      _filteredMeds = _meds
          .where((m) => m.name.toLowerCase().contains(query.toLowerCase()) ||
                        m.use.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(),
            _buildSearchBar(),
            if (_aiAnalysis != null) _buildAiAnalysisResult(),
            if (_isAnalyzing) 
              _buildLoadingState()
            else if (_aiAnalysis == null) ...[
              Center(
                child: Lottie.asset(
                  'assets/animations/medicine.json',
                  height: 120,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              Expanded(
                child: _filteredMeds.isEmpty
                  ? const Center(child: Text("No medications found."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredMeds.length,
                      itemBuilder: (context, index) {
                        return _buildMedCard(_filteredMeds[index]);
                      },
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
            Lottie.asset('assets/animations/medicine.json', height: 180),
            const SizedBox(height: 20),
            const Text(
              "Furrr AI is checking meds...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Safety check for ${PetProfileService().currentPet.breed}s",
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
      case 'emergency':
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
                    analysis.medName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    onPressed: () {
                      final textToSpeak = "${analysis.medName} safety level is ${analysis.safetyLevel}. ${analysis.breedNuance} ${analysis.description}. Dosage info: ${analysis.dosageInfo}";
                      TtsService().speak(textToSpeak);
                    },
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const Text("Read AI Summary", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            _buildResultSection(
              title: "Breed Safety (${PetProfileService().currentPet.breed})",
              content: analysis.breedNuance,
              icon: Icons.pets_rounded,
              color: AppColors.primary,
            ),
            
            _buildResultSection(
              title: "Dosage & Use Guide",
              content: analysis.dosageInfo,
              icon: Icons.science_rounded,
              color: AppColors.accent,
            ),

            _buildResultSection(
              title: "About this Med",
              content: analysis.description,
              icon: Icons.info_rounded,
              color: AppColors.textPrimary,
            ),

            if (analysis.sideEffects.isNotEmpty)
              _buildListSection(
                title: "Potential Side Effects",
                items: analysis.sideEffects,
                icon: Icons.visibility_rounded,
                color: AppColors.error,
              ),

            _buildListSection(
              title: "Emergency Steps",
              items: analysis.actionSteps,
              icon: Icons.flash_on_rounded,
              color: AppColors.error,
            ),

            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => setState(() => _aiAnalysis = null),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Search another med"),
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

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: 15),
          Text(
            TranslationService.t('medication_guide'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1B2A22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          CustomSearchBar(
            controller: _searchController,
            hintText: TranslationService.t('search_meds'),
            onChanged: (value) {
              if (_aiAnalysis != null && value.toLowerCase() != _aiAnalysis!.medName.toLowerCase()) {
                setState(() => _aiAnalysis = null);
              }
            },
          ),
          if (_searchController.text.isNotEmpty && _aiAnalysis == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InkWell(
                onTap: () => _performAiSecurityCheck(_searchController.text),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF43A047)],
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
                        "Ask AI about this medication",
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

  Widget _buildMedCard(Medication med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
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
          onTap: () => _performAiSecurityCheck(med.name),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B2A22),
                      ),
                    ),
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
                  ],
                ),
                const SizedBox(height: 10),
                _medInfoRow(Icons.science_outlined, "Dosage", med.dosage),
                const SizedBox(height: 8),
                _medInfoRow(Icons.healing_outlined, "Used for", med.use),
                const Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        med.warning,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _medInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          "$title: ",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildBreedNote() {
    final pet = PetProfileService().currentPet;
    final content = PetProfileService().getBreedSpecificContent();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Note for ${pet.breed}: ${content['med_note']}",
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
