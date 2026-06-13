import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/translation_service.dart';

class AppBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final AppLanguage selectedLanguage;
  final Function(int) onTabTapped;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.selectedLanguage,
    required this.onTabTapped,
  });

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void didUpdateWidget(AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double itemWidth = width / 4;
    final double activeOffset = widget.selectedIndex * itemWidth + (itemWidth / 2);

    return Container(
      height: 90,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background with Curve Cutout
          CustomPaint(
            size: Size(width, 90),
            painter: NavPainter(activeOffset),
          ),
          // Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded),
              _buildNavItem(1, Icons.camera_alt_rounded),
              _buildNavItem(2, Icons.medical_services_rounded),
              _buildNavItem(3, Icons.people_rounded),
            ],
          ),
          // Animated Yellow Circle
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            left: activeOffset - 30, // 30 is half of 60 radius
            top: -20,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Parabolic jump: y = 4 * height * t * (1 - t)
                // t goes from 0 to 1 as the controller plays
                final double t = _animation.value;
                final double jumpHeight = 50.0; // How high it jumps
                final double verticalOffset = 4 * jumpHeight * t * (1 - t);

                return Transform.translate(
                  offset: Offset(0, -verticalOffset),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForIndex(widget.selectedIndex),
                        color: AppColors.textDark,
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () => widget.onTabTapped(index),
      child: Container(
        width: 60,
        height: 60,
        color: Colors.transparent,
        child: Visibility(
          visible: !isSelected,
          child: Icon(
            icon,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
            size: 26,
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.camera_alt_rounded;
      case 2: return Icons.medical_services_rounded;
      case 3: return Icons.people_rounded;
      default: return Icons.home_rounded;
    }
  }
}

class NavPainter extends CustomPainter {
  final double x;
  NavPainter(this.x);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.background // Dark background color
      ..style = PaintingStyle.fill;

    // We use a dark color from the theme for the main bar
    paint.color = const Color(0xFF1E1E1E); // Solid dark surface color

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(x - 60, 0)
      ..quadraticBezierTo(x - 40, 0, x - 35, 10)
      ..arcToPoint(
        Offset(x + 35, 10),
        radius: const Radius.circular(40),
        clockwise: false,
      )
      ..quadraticBezierTo(x + 40, 0, x + 60, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
    
    // Add a top border line
    Paint linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
      
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant NavPainter oldDelegate) {
    return oldDelegate.x != x;
  }
}
