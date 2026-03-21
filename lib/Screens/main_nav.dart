import 'package:flutter/material.dart';
import 'package:furrr/Screens/Home/home_screen.dart';
import 'package:furrr/Screens/Wound Analyzer/woundAI_screen.dart';
import 'package:furrr/Screens/Vets/vets_screen.dart';
import 'package:furrr/Screens/Community/community_screen.dart';
import '../widgets/nav_bar.dart';
import '../widgets/language_selector.dart';
import '../services/translation_service.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;
  // No need for local _selectedLanguage, use TranslationService
  final List<Widget> _screens = const [
    FurrrHomePage(),
    WoundAiScreen(),
    VetsScreen(),
    CommunityScreen(),
  ];

  @override
  void initState() {
    super.initState();
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        selectedLanguage: TranslationService().currentLanguage,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}