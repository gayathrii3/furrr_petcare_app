import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

class PawsLoading extends StatelessWidget {
  final double size;
  final Color? color;
  const PawsLoading({super.key, this.size = 100, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/paws.json',
        width: size,
        height: size,
        fit: BoxFit.contain,
        repeat: true,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(
              const ['**'],
              value: color ?? AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
