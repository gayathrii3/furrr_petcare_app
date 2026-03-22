import 'package:flutter/material.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../services/vet_service.dart';
import '../../models/vet.dart';
import '../../theme/app_colors.dart';

class VetsScreen extends StatefulWidget {
  const VetsScreen({super.key});

  @override
  State<VetsScreen> createState() => _VetsScreenState();
}

class _VetsScreenState extends State<VetsScreen> {
  List<Vet> _vets = [];
  bool _isLoading = true;
  String? _error;

  String _selectedFilter = "All";
  List<String> _filters = ["All"];

  @override
  void initState() {
    super.initState();
    _fetchVets();
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

  Future<void> _fetchVets() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final vets = await VetService().getNearbyVets();
      if (mounted) {
        setState(() {
          _vets = vets;
          _isLoading = false;
          _getFilters();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _getFilters() {
    final specialties = _vets.expand((v) => v.specialties).toSet().toList();
    specialties.sort();
    setState(() {
      _filters = ["All", ...specialties];
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
            _buildFilterBar(),
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: 15),
          Text(
            TranslationService.t('vets'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    if (_filters.length <= 1) return const SizedBox.shrink();
    
    return Container(
      height: 60,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppColors.textDark : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white.withOpacity(0.15),
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              Text(
                "Error Locating Vets",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchVets,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text("Retry", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_vets.isEmpty) {
      return const Center(child: Text("No vets found in your area. Try increasing search range."));
    }

    final filteredVets = _vets.where((vet) {
      return _selectedFilter == "All" || vet.specialties.contains(_selectedFilter);
    }).toList();

    if (filteredVets.isEmpty) {
      return const Center(child: Text("No vets match your filter."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredVets.length,
      itemBuilder: (context, index) {
        return _buildVetCard(filteredVets[index]);
      },
    );
  }

  Widget _buildVetCard(Vet vet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.local_hospital, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              vet.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: vet.isOpen ? AppColors.primary.withOpacity(0.15) : AppColors.error.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vet.isOpen ? "OPEN" : "CLOSED",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: vet.isOpen ? AppColors.primary : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            vet.rating.toString(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on, color: AppColors.primary, size: 14),
                          const SizedBox(width: 4),
                          Text(vet.distance, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              vet.address,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vet.specialties.map((s) => _buildSpecialtyChip(s)).toList(),
            ),
            const Divider(height: 30, thickness: 0.8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(vet.phone, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                  child: const Text("Book", style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtyChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
    );
  }
}
