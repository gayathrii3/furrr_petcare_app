import 'package:flutter/material.dart';
import 'language_selector.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final AppLanguage selectedLanguage;
  final Function(int) onTabTapped;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.selectedLanguage,
    required this.onTabTapped,
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
          _buildNavItem(
            index: 0,
            icon: Icons.home,
            label: t("Home", "होम", "హోమ్", "ஹோம்"),
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.medical_services,
            label: t("Wound AI", "वाउंड AI", "వౌండ్ AI", "வுண்ட் AI"),
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.local_hospital,
            label: t("Vets", "वेट्स", "వెట్స్", "வெட்ஸ்"),
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.groups,
            label: t("Community", "समुदाय", "కమ్యూనిటీ", "சமூகம்"),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: isSelected
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFDDEFE3) : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? const Color(0xFF0B5D3B) : const Color(0xFF476555),
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
                color: isSelected ? const Color(0xFF0B5D3B) : const Color(0xFF476555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
