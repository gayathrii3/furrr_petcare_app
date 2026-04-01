import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomCameraIcon extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const CustomCameraIcon({
    super.key,
    this.size = 120,
    this.onTap,
  });

  @override
  State<CustomCameraIcon> createState() => _CustomCameraIconState();
}

class _CustomCameraIconState extends State<CustomCameraIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOutQuart)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Derived values for consistency
    final double width = widget.size;
    final double height = width * 0.75;
    final double cornerRadius = width * 0.12;
    final double lensSize = width * 0.55;

    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: width,
        height: height + (width * 0.1), // Extra space for top elements
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 1. Shutter Button (Orange)
            Positioned(
              top: 0,
              right: width * 0.15,
              child: Container(
                width: width * 0.18,
                height: width * 0.1,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF8C42),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ),
            ),

            // 2. Viewfinder / Flash bump (Dark Grey)
            Positioned(
              top: width * 0.02,
              left: width * 0.25,
              right: width * 0.25,
              child: Container(
                height: width * 0.12,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A4A4A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cornerRadius),
                    topRight: Radius.circular(cornerRadius),
                  ),
                ),
              ),
            ),

            // 3. Main Body
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A),
                borderRadius: BorderRadius.circular(cornerRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Lighter Grey Strip
                  Container(
                    width: width,
                    height: height * 0.45,
                    color: const Color(0xFF555555),
                  ),

                  // 4. Lens Outer (Dark Border)
                  Container(
                    width: lensSize,
                    height: lensSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF333333),
                        width: width * 0.04,
                      ),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(width * 0.05),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Icon(
                        Icons.pets,
                        color: AppColors.primaryOrange,
                        size: lensSize * 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
