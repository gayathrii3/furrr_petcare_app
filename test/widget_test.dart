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
  testWidgets('Vets Screen smoke test', (WidgetTester tester) async {
    // Build the Vets screen in isolation.
    await tester.pumpWidget(const MaterialApp(home: VetsScreen()));

    // Verify that the title and at least one vet clinic are present.
    expect(find.text('Find Vets'), findsOneWidget);
    expect(find.text('Happy Paws Clinic'), findsOneWidget);
  });
}
