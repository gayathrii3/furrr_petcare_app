import 'package:flutter/material.dart';
import 'package:furrr/screens/main_nav.dart';

void main() {
  runApp(const FurrrApp());
}

class FurrrApp extends StatelessWidget {
  const FurrrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNav(), 
    );
  }
}