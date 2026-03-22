import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color background = Color.fromARGB(255, 127, 96, 57); // Deep Espresso
  static const Color primary = Color(0xFFFACB3B);    // Golden Yellow
  static const Color secondary = Color(0xFFE3C9A6);  // Warm Tan
  static const Color accent = Color(0xFFE54D2B);     // Burnt Red
  
  // Surface Palette
  static const Color surface = Color(0xFF1E1A15);    // Soft Charcoal
  static const Color cardBackground = Color(0xFF26211B);
  
  // Text Palette
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD2B48C); // Warm Cream
  static const Color textDark = Color(0xFF110E0A);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE54D2B);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFACB3B), Color(0xFFE3B01A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
