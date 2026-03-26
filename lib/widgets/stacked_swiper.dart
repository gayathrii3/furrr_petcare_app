import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StackedCardSwiper extends StatefulWidget {
  final List<Widget> cards;
  const StackedCardSwiper({super.key, required this.cards});

  @override
  State<StackedCardSwiper> createState() => _StackedCardSwiperState();
}

class _StackedCardSwiperState extends State<StackedCardSwiper> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page!;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // Reduced height for minimalist cards
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          double difference = index - _currentPage;
          
          Matrix4 matrix = Matrix4.identity();
          
          if (difference >= 0) {
            double scale = 1 - (difference * 0.1).clamp(0.0, 0.2);
            matrix = Matrix4.identity()
              ..translate(difference * -40.0, difference * 15.0, 0)
              ..scale(scale);
          } else {
            matrix = Matrix4.identity()
              ..translate(difference * 100.0, 0, 0)
              ..rotateZ(difference * 0.1);
          }

          return Opacity(
            opacity: (1 - difference.abs() * 0.3).clamp(0.4, 1.0),
            child: Transform(
              transform: matrix,
              alignment: Alignment.center,
              child: widget.cards[index],
            ),
          );
        },
      ),
    );
  }
}

class OngoingTaskCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const OngoingTaskCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
