import 'dart:async';
import 'package:flutter/material.dart';
import 'main_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pawController;
  late Animation<double> _pawAnimation;

  List<bool> _letterVisible = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();

    // Paw pop animation
    _pawController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pawAnimation = CurvedAnimation(parent: _pawController, curve: Curves.elasticOut);
    _pawController.forward();

    // Staggered letter animation
    Timer(const Duration(milliseconds: 700), () {
      for (int i = 0; i < _letterVisible.length; i++) {
        Timer(Duration(milliseconds: i * 200), () {
          if (mounted) {
            setState(() {
              _letterVisible[i] = true;
            });
          }
        });
      }
    });

    // Navigate to MainNav after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNav()),
        );
      }
    });
  }

  @override
  void dispose() {
    _pawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006949),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Paw Icon pop animation
            ScaleTransition(
              scale: _pawAnimation,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.pets,
                  size: 64,
                  color: Color(0xFF006949),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Staggered "Furrr" letters
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                String letter = "Furrr"[index];
                Color color = (index < 3) ? Colors.white : Colors.white54;
                return AnimatedOpacity(
                  opacity: _letterVisible[index] ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: 64,
                      color: color,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}