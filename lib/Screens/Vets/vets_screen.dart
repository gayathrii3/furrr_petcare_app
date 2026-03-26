import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_back_button.dart';
import '../../services/translation_service.dart';
import '../../services/pet_profile_service.dart';
import '../../services/vet_service.dart';
import '../../models/vet.dart';
import '../../theme/app_colors.dart';

class VetsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const VetsScreen({super.key, this.onBack});

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

  Future<void> _callVet(String? phone, String clinicName) async {
    if (phone == null || phone.isEmpty || phone == 'Contact via Maps') {
      // If phone is missing, try to search on web
      final query = Uri.encodeComponent('$clinicName veterinary phone number');
      final url = Uri.parse('https://www.google.com/search?q=$query');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showError("Could not search for clinic contact.");
      }
      return;
    }

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone.replaceAll(RegExp(r'\s+'), ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showError("Could not initiate phone call.");
    }
  }

  Future<void> _openInMaps(Vet vet) async {
    Uri url;
    if (vet.lat != null && vet.lng != null) {
      // Open specifically at coordinates
      url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${vet.lat},${vet.lng}&query_place_id=${vet.placeId}");
    } else {
      // Fallback to name search
      final query = Uri.encodeComponent("${vet.name} ${vet.address}");
      url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showError("Could not open maps.");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.background,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          CustomBackButton(onTap: widget.onBack),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              TranslationService.t('vets'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      color: Colors.transparent,
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
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.secondary,
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
      return Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Lottie.asset(
            'assets/animations/paws.json',
            fit: BoxFit.contain,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(
                  const ['**'],
                  value: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off_outlined, size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                "Error Locating Vets",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchVets,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Retry", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_vets.isEmpty) {
      return const Center(
        child: Text("No vets found in your area.", style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final filteredVets = _vets.where((vet) {
      return _selectedFilter == "All" || vet.specialties.contains(_selectedFilter);
    }).toList();

    if (filteredVets.isEmpty) {
      return const Center(
        child: Text("No vets match your filter.", style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: filteredVets.length,
      itemBuilder: (context, index) {
        return _buildVetCard(filteredVets[index]);
      },
    );
  }

  Widget _buildVetCard(Vet vet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openInMaps(vet),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
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
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: vet.isOpen ? AppColors.primary.withOpacity(0.15) : Colors.redAccent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                vet.isOpen ? "OPEN" : "CLOSED",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: vet.isOpen ? AppColors.primary : Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              vet.rating.toString(),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.location_on_rounded, color: AppColors.textSecondary, size: 14),
                            const SizedBox(width: 4),
                            Text(vet.distance, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                vet.address,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _callVet(vet.phone, vet.name),
                      icon: const Icon(Icons.call_rounded, size: 18),
                      label: const Text("Call Clinic", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textDark,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: IconButton(
                      onPressed: () => _openInMaps(vet),
                      icon: const Icon(Icons.directions_rounded, color: AppColors.primary),
                      tooltip: "Get Directions",
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
