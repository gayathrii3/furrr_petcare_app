import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  double _dragOffset = 0.0;
  final double _buttonHeight = 80.0;
  final double _pawSize = 64.0;
  late AnimationController _snapController;
  late Animation<double> _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(0.0, maxWidth - _pawSize - 16);
    });
  }

  void _onDragEnd(DragEndDetails details, double maxWidth) {
    if (_dragOffset > (maxWidth - _pawSize - 16) * 0.8) {
      // Completed! Go to login with CUSTOM TRANSITION (Slide from bottom)
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AuthScreen(initialIsSignUp: false),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutQuart;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      ).then((_) {
        // Reset offset when coming back
        setState(() {
          _dragOffset = 0.0;
        });
      });
    } else {
      // Snap back
      _snapAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
        CurvedAnimation(parent: _snapController, curve: Curves.easeOut),
      )..addListener(() {
          setState(() {
            _dragOffset = _snapAnimation.value;
          });
        });
      _snapController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth - 80;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Orange Hero Section with ASYMMETRICAL Sweeping Curve
          ClipPath(
            clipper: WelcomeHeroSweepingClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.58,
              width: double.infinity,
              color: AppColors.primaryOrange,
              child: Stack(
                children: [
                  // Multiple faint paw prints
                  _buildFaintPaw(bottom: 60, right: 30, size: 80, rotation: -15),
                  _buildFaintPaw(bottom: 120, right: 100, size: 50, rotation: 10),
                  _buildFaintPaw(bottom: 40, right: 140, size: 60, rotation: -40),
                  
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                              "FURRR",
                              style: GoogleFonts.pangolin(
                                textStyle: const TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _buildHandwrittenText("where every wag has a reason. Every whimper finds an answer"),
                                  _buildHandwrittenText("Every Paw Print leads to careYour Pet's world, safe & loved"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Column for Interactive Slide Button and Mascot
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.6),
              
              const Spacer(),
              
              // Interactive "Slide to Start" Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: _buttonHeight,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: AppColors.buttonOrange,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // "Get started" Text (with fading effect)
                      Center(
                        child: Opacity(
                          opacity: (1.0 - (_dragOffset / (buttonWidth - _pawSize))).clamp(0.2, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Get started",
                                style: GoogleFonts.pangolin(
                                  textStyle: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.keyboard_double_arrow_right, color: Colors.black45, size: 24),
                            ],
                          ),
                        ),
                      ),

                      // Draggable Paw Circle
                      Positioned(
                        left: 8 + _dragOffset,
                        top: 8,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) => _onDragUpdate(details, buttonWidth),
                          onHorizontalDragEnd: (details) => _onDragEnd(details, buttonWidth),
                          child: Container(
                            width: _pawSize,
                            height: _pawSize,
                            decoration: const BoxDecoration(
                              color: Color(0xFF333333),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.pets,
                              color: AppColors.buttonOrange,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Mascot Image at actual bottom (using white-background version)
              Image.asset(
                "assets/images/white_mascot.png",
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaintPaw({required double bottom, required double right, required double size, required double rotation}) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Opacity(
        opacity: 0.1,
        child: Transform.rotate(
          angle: rotation * 3.14159 / 180,
          child: Icon(Icons.pets, size: size, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildHandwrittenText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.pangolin(
        textStyle: const TextStyle(
          fontSize: 24,
          color: Colors.black,
          height: 1.3,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class WelcomeHeroSweepingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.45); // Start on left side

    // A single, very round sweep that reveals the white in the bottom-left
    var controlPoint = Offset(size.width * 0.2, size.height * 1.05);
    var endPoint = Offset(size.width, size.height * 0.85);

    path.quadraticBezierTo(
      controlPoint.dx, controlPoint.dy,
      endPoint.dx, endPoint.dy
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
