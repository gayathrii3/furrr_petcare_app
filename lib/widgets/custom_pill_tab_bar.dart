import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CustomPillTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const CustomPillTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 58, // Slightly taller for more "inside" feel
      decoration: BoxDecoration(
        color: const Color(0xFF333333), // Darker charcoal for better contrast
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double tabWidth = totalWidth / tabs.length;
          const double padding = 7.0; // Increased padding for "inside" look

          return Stack(
            children: [
              // 1. Sliding Indicator Pill (The "Inset" Circle/Pill)
              AnimatedBuilder(
                animation: controller.animation!,
                builder: (context, child) {
                  final double offset = controller.animation!.value * tabWidth;
                  return Positioned(
                    left: offset + padding,
                    top: padding,
                    bottom: padding,
                    child: Container(
                      width: tabWidth - (padding * 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // 2. Tab Labels
              Row(
                children: List.generate(tabs.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.animateTo(index),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: controller.animation!,
                          builder: (context, child) {
                            final double distance = (controller.animation!.value - index).abs();
                            final double opacity = (1.0 - distance).clamp(0.4, 1.0);
                            final bool isActive = distance < 0.5;

                            return Text(
                              tabs[index],
                              style: GoogleFonts.pangolin(
                                textStyle: TextStyle(
                                  color: isActive ? Colors.black : Colors.white.withOpacity(opacity),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
