import 'package:flutter/material.dart';
import '../../services/sound_service.dart';
import '../../theme/app_colors.dart';

enum PeepDirection { top, bottom, left, right, center }

class PeepingPug extends StatefulWidget {
  final PeepDirection direction;
  final double peepAmount;
  final double size;
  final bool isUpsideDown;
  final bool isFlipped;

  const PeepingPug({
    super.key,
    this.direction = PeepDirection.top,
    this.peepAmount = 0.5,
    this.size = 180,
    this.isUpsideDown = false,
    this.isFlipped = false,
  });

  @override
  State<PeepingPug> createState() => PeepingPugState();
}

class PeepingPugState extends State<PeepingPug> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _blinkController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _squishAnimation;

  @override
  void initState() {
    super.initState();
    SoundService.playBoing();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    Offset startOffset;
    switch (widget.direction) {
      case PeepDirection.top: startOffset = const Offset(0, -1); break;
      case PeepDirection.bottom: startOffset = const Offset(0, 1); break;
      case PeepDirection.left: startOffset = const Offset(-1, 0); break;
      case PeepDirection.right: startOffset = const Offset(1, 0); break;
      case PeepDirection.center: startOffset = Offset.zero; break;
    }

    _offsetAnimation = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    ));

    _squishAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    _entryController.forward();
  }

  void blink() {
    _blinkController.forward().then((_) => _blinkController.reverse());
  }

  @override
  void dispose() {
    _entryController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: ScaleTransition(
        scale: _squishAnimation,
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(widget.isUpsideDown ? 0.5 : 0.0),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(widget.isFlipped ? 3.14159 : 0),
            child: Image.asset(
              "assets/images/white_mascot.png",
              width: widget.size,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 80),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBackground extends StatelessWidget {
  final Widget child;
  final Widget? peepingPug;

  const AuthBackground({super.key, required this.child, this.peepingPug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Switched to clean white background
      body: Stack(
        children: [
          // White Top Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              color: Colors.white,
            ),
          ),
          
          // Peeping Puppy logic
          if (peepingPug != null) peepingPug!,
          
          SafeArea(child: child),
        ],
      ),
    );
  }
}
