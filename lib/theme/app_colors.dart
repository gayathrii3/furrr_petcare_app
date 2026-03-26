import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Dark Theme)
  static const Color background = Color(0xFF121212); // Deep Black/Charcoal
  static const Color primary = Color(0xFFFFD95A);    // Soft Bold Yellow/Gold
  static const Color secondary = Color(0xFF1E1E1E);  // Dark Surface/Card BG
  static const Color accent = Color(0xFF2C2C2C);     // Lighter Charcoal
  
  // Surface Palette
  static const Color surface = Color(0xFF1A1A1A);    // Dark Surface
  static const Color cardBackground = Color(0xFFFFD95A); // Action Cards (Yellow from Image)
  
  // Text Palette (Optimized for Dark Theme)
  static const Color textPrimary = Color(0xFFFFFFFF);   // White
  static const Color textSecondary = Color(0xFFB0B0B0); // Light Gray
  static const Color textDark = Color(0xFF121212);      // For text on Yellow backgrounds
  
  // Status Colors
  static const Color success = Color(0xFF81B29A); 
  static const Color error = Color(0xFFE07A5F);   
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD95A), Color(0xFFE6B800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
