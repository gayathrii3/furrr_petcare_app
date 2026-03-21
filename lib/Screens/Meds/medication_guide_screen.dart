import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';

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
      backgroundColor: const Color(0xFFF0FAF5),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFCDE9D6), width: 1.5),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: TranslationService.t('search_meds'),
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF5F8B73)),
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
        color: const Color(0xFFFFE8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE63946).withOpacity(0.3)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFE63946)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "IMPORTANT: Always consult your veterinarian before administering any medication.",
              style: TextStyle(
                color: Color(0xFFE63946),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCDE9D6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              const Icon(Icons.error_outline, size: 18, color: Color(0xFFE63946)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  med.warning,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE63946),
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
        Icon(icon, size: 16, color: const Color(0xFF5F8B73)),
        const SizedBox(width: 8),
        Text(
          "$title: ",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A22),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Color(0xFF5F8B73)),
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
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Note for ${pet.breed}: ${content['med_note']}",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
