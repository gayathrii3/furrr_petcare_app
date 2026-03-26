import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/auth/auth_layout.dart';
import '../main_nav.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<PeepingPugState> _pugKey = GlobalKey<PeepingPugState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _passFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_emailFocus.hasFocus || _passFocus.hasFocus) {
      _pugKey.currentState?.blink();
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      peepingPug: Positioned(
        top: -40,
        left: 0,
        right: 0,
        child: PeepingPug(
          key: _pugKey,
          direction: PeepDirection.top,
          peepAmount: 0.6,
          size: 220,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 120), // Spacer for peeping pug
            const Text(
              "SIGN IN",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            
            // Login Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField("Email", Icons.email_outlined, focusNode: _emailFocus),
                  const SizedBox(height: 20),
                  _buildTextField("Password", Icons.lock_outline, isPassword: true, focusNode: _passFocus),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?", style: TextStyle(color: AppColors.textSecondary)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool isPassword = false, FocusNode? focusNode}) {
    return TextField(
      focusNode: focusNode,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }
}
