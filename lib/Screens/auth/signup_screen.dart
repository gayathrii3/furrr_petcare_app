import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/auth/auth_layout.dart';
import '../main_nav.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<PeepingPugState> _pugKey = GlobalKey<PeepingPugState>();
  final FocusNode _userFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      peepingPug: Positioned(
        top: 100,
        left: -80,
        child: PeepingPug(
          key: _pugKey,
          direction: PeepDirection.left,
          peepAmount: 0.6,
          size: 240,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100), // Spacer for peeping pug
              const Text(
                "CREATE\nACCOUNT",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 2,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Signup Card
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
                    _buildTextField("Username", Icons.person_outline, focusNode: _userFocus),
                    const SizedBox(height: 16),
                    _buildTextField("Email", Icons.email_outlined, focusNode: _emailFocus),
                    const SizedBox(height: 16),
                    _buildTextField("Mobile Number", Icons.phone_android_outlined, focusNode: _phoneFocus),
                    const SizedBox(height: 16),
                    _buildTextField("Password", Icons.lock_outline, isPassword: true, focusNode: _passFocus),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (v) {},
                          activeColor: AppColors.primary,
                          checkColor: Colors.black,
                          side: const BorderSide(color: AppColors.primary),
                        ),
                        const Expanded(
                          child: Text(
                            "I agree with the terms and conditions",
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                          "REGISTER",
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?", style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
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
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
