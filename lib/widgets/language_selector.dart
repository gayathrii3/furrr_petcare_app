import 'package:flutter/material.dart';

enum AppLanguage { en, hi, te, ta }

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
