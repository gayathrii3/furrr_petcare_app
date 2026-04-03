import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/auth/auth_layout.dart';
import '../main_nav.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsSignUp;
  const AuthScreen({super.key, this.initialIsSignUp = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isSignUp;
  final GlobalKey<PeepingPugState> _pugKey = GlobalKey<PeepingPugState>();
  
  // Focus Nodes for Signup
  final FocusNode _userFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialIsSignUp;
    _userFocus.addListener(_onFocusChange);
    _emailFocus.addListener(_onFocusChange);
    _phoneFocus.addListener(_onFocusChange);
    _passFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_userFocus.hasFocus || _emailFocus.hasFocus || _phoneFocus.hasFocus || _passFocus.hasFocus) {
      _pugKey.currentState?.blink();
    }
  }

  @override
  void dispose() {
    _userFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return AuthBackground(
      peepingPug: Positioned(
        top: 5,
        left: 0,
        right: 0,
        child: PeepingPug(
          key: _pugKey,
          direction: PeepDirection.top,
          peepAmount: 0.6,
          size: 220,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _isSignUp ? _buildSignupForm(screenHeight) : _buildLoginForm(screenHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(double screenHeight) {
    return Column(
      key: const ValueKey('login'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: screenHeight * 0.35),
        const SizedBox(height: 5),
        Text(
          "SIGN IN",
          style: GoogleFonts.pangolin(
            textStyle: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 1.5,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.primaryOrange.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTextField("Email", Icons.email_outlined, focusNode: _emailFocus),
              const SizedBox(height: 16),
              _buildTextField("Password", Icons.lock_outline, isPassword: true, focusNode: _passFocus),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.pangolin(
                      textStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildButton("LOGIN"),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?", 
              style: GoogleFonts.pangolin(textStyle: const TextStyle(color: Colors.black87, fontSize: 14)),
            ),
            TextButton(
              onPressed: _toggleAuthMode,
              child: Text(
                "Sign Up",
                style: GoogleFonts.pangolin(
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignupForm(double screenHeight) {
    return Column(
      key: const ValueKey('signup'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: screenHeight * 0.32),
        const SizedBox(height: 5),
        Text(
          "CREATE ACCOUNT",
          style: GoogleFonts.pangolin(
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 1.2,
              height: 1.0,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTextField("Username", Icons.person_outline, focusNode: _userFocus),
              const SizedBox(height: 12),
              _buildTextField("Email", Icons.email_outlined, focusNode: _emailFocus),
              const SizedBox(height: 12),
              _buildTextField("Mobile Number", Icons.phone_android_outlined, focusNode: _phoneFocus),
              const SizedBox(height: 12),
              _buildTextField("Password", Icons.lock_outline, isPassword: true, focusNode: _passFocus),
              const SizedBox(height: 8),
              _buildAgreementCheckbox(),
              const SizedBox(height: 16),
              _buildButton("REGISTER"),
            ],
          ),
        ),
        
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?", 
              style: GoogleFonts.pangolin(textStyle: const TextStyle(color: Colors.black87, fontSize: 14)),
            ),
            TextButton(
              onPressed: _toggleAuthMode,
              child: Text(
                "Log In",
                style: GoogleFonts.pangolin(
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool isPassword = false, FocusNode? focusNode}) {
    return TextField(
      focusNode: focusNode,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.pangolin(textStyle: const TextStyle(color: Colors.black54, fontSize: 18)),
        prefixIcon: Icon(icon, color: Colors.black87, size: 24),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          shadowColor: AppColors.primaryOrange.withOpacity(0.4),
        ),
        child: Text(
          text,
          style: GoogleFonts.pangolin(
            textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.1),
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementCheckbox() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: true,
            onChanged: (v) {},
            activeColor: AppColors.primaryOrange,
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.black26, width: 1.5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "I agree with terms & conditions",
            style: GoogleFonts.pangolin(
              textStyle: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
