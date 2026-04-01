import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'auth/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final String _text = "FURRR";
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _controller.forward().then((_) => _navigateToWelcome());
  }

  void _navigateToWelcome() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryOrange, // Perfectly matched background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Puppy Mascot (Peeping over the line)
            Image.asset(
              "assets/images/splash_mascot.png",
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 120),
            ),
            
            // Curved Staggered Text "FURRR" (Positioned below the mascot)
            const SizedBox(height: 15),
            _buildCurvedStaggeredText(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurvedStaggeredText() {
    final letters = _text.split("");
    final double arcRadius = 140.0;
    final double startAngle = -pi / 6;
    final double endAngle = pi / 6;    
    final double step = (endAngle - startAngle) / (letters.length - 1);

    return Container(
      height: 100,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: List.generate(letters.length, (index) {
          final double angle = startAngle + (step * index);
          
          final double start = (index * 0.12).clamp(0.0, 1.0);
          final double end = (start + 0.3).clamp(0.0, 1.0);
          
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          );

          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(
                    arcRadius * sin(angle),
                    -arcRadius * (1 - cos(angle)) * 0.7, // Milder inward curve
                  )
                  ..rotateZ(-angle * 0.5), // Subtle letter tilt
                child: Text(
                  letters[index],
                  style: GoogleFonts.pangolin(
                    textStyle: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
