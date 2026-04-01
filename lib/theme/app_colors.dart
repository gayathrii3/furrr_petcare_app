import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Furrr Premium Theme)
  static const Color primaryOrange = Color(0xFFD48B3F); // Matched to mascot background
  static const Color buttonOrange = Color(0xFFF9B24E);
  static const Color background = Colors.white;         // Clean White Background
  static const Color surface = Color(0xFFF8F8F8);      // Very Light Grey for Cards
  static const Color secondary = Color(0xFF333333);     // Dark Grey/Black for accents
  
  // Backwards Compatibility Mapping (Points to new theme)
  static const Color primary = primaryOrange;
  static const Color textPrimary = Color(0xFF000000);   // Solid Black
  static const Color textSecondary = Color(0xFF666666); // Muted Grey
  static const Color accent = primaryOrange;            // For highlights and emphasis
  static const Color cardBackground = Colors.white;     // Clean White Cards
  static const Color textDark = Color(0xFF000000);
  static const Color backgroundLight = Colors.white;
  static const Color success = Color(0xFF81B29A); 
  static const Color error = Color(0xFFE07A5F);   

  // Home Screen Overhaul Colors
  static const Color headerDark = Color(0xFF333333);
  static const Color actionGreen = Color(0xFFE8F5E9);
  static const Color actionBlue = Color(0xFFE3F2FD);
  static const Color actionPurple = Color(0xFFF3E5F5);
  static const Color actionOrange = Color(0xFFFFF3E0);
  static const Color actionPink = Color(0xFFFCE4EC);
  static const Color actionTeal = Color(0xFFE0F2F1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, buttonOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFF8F8F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
