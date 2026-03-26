import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/auth/auth_layout.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Welcome to Furrr!",
      subtitle: "Your all-in-one pet care assistant. Scan wounds, track meds, and connect with vets instantly.",
      image: "assets/images/pug_character.png",
    ),
    OnboardingData(
      title: "AI Wound Analyzer",
      subtitle: "Simply snap a photo and our AI will check the severity of any wound in seconds.",
      image: "assets/images/pug_character.png",
    ),
    OnboardingData(
      title: "Global Vet Access",
      subtitle: "Connect with real vets and find clinical support anywhere, anytime.",
      image: "assets/images/pug_character.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], index);
            },
          ),
          
          // Bottom Navigation
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Action Buttons
                if (_currentPage == _pages.length - 1)
                  Column(
                    children: [
                      _buildPrimaryButton("Get Started", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                      }),
                      const SizedBox(height: 16),
                      _buildSecondaryButton("Create Account", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                      }),
                    ],
                  )
                else
                  _buildPrimaryButton("Continue", () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data, int index) {
    PeepDirection direction;
    bool upsideDown = false;
    bool flipped = false;

    switch (index) {
      case 0: direction = PeepDirection.left; break;
      case 1: direction = PeepDirection.right; flipped = true; break;
      case 2: direction = PeepDirection.top; upsideDown = true; break;
      default: direction = PeepDirection.center;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          // Character with Peeping Animation
          SizedBox(
            height: 250,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: PeepingPug(
                    key: ValueKey('pug_$index'),
                    direction: direction,
                    isUpsideDown: upsideDown,
                    isFlipped: flipped,
                    size: 220,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 120), // Spacer for bottom controls
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;

  OnboardingData({required this.title, required this.subtitle, required this.image});
}
