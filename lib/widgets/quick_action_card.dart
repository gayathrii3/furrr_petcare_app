import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class QuickActionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final IconData faintIcon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.faintIcon,
    this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.94;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.textPrimary.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4A373).withOpacity(0.15), // Soft brown shadow
                blurRadius: 15,
                offset: const Offset(6, 6),
              ),
              BoxShadow(
                color: Colors.white,
                blurRadius: 12,
                offset: const Offset(-6, -6),
              ),
              BoxShadow(
                color: widget.iconColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  widget.faintIcon,
                  size: 22,
                  color: widget.iconColor.withOpacity(0.18),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Icon(
                    widget.icon,
                    size: 38,
                    color: widget.iconColor,
                  ),
                  const Spacer(),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.iconColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
