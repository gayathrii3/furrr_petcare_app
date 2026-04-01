// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:furrr/Screens/Vets/vets_screen.dart';

void main() {
  testWidgets('Vets Screen title test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VetsScreen()));
    await tester.pumpAndSettle();
    
    // Search for the title more flexibly
    final titleFinder = find.textContaining('Vets');
    expect(titleFinder, findsWidgets);
  });

  testWidgets('Vets Screen clinic find test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VetsScreen()));
    await tester.pumpAndSettle();
    
    // Look for demo clinic
    final clinicFinder = find.textContaining('Happy Paws');
    expect(clinicFinder, findsWidgets);
  });
}
