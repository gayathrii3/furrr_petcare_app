import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.08), // Light theme-orange tint
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.pangolin(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary, // Consistent text color
                  fontWeight: FontWeight.w600,
                ),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.pangolin(
                  textStyle: TextStyle(
                    color: AppColors.textPrimary.withOpacity(0.4),
                    fontSize: 16,
                  ),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // Circular Search Button
          Container(
            margin: const EdgeInsets.all(4),
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange, // Strict Brand Orange
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
