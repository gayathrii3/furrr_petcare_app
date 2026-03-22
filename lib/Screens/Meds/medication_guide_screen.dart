import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../theme/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _filteredMeds = List.from(_meds);
    _searchController.addListener(_onSearchChanged);
    TranslationService().addListener(_onLanguageChanged);
    PetProfileService().addListener(_onProfileChanged);
  }

  @override
  void dispose() {
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
            _buildBreedNote(),
            _buildDisclaimer(),
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
        ),
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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: TranslationService.t('search_meds'),
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "IMPORTANT: Always consult your veterinarian before administering any medication.",
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.4,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            med.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1B2A22),
            ),
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
