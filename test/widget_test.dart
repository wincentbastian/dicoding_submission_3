import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/pages/setting_screen.dart';

void main() {
  // Build the widget
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    final textFormField = find.byKey(ValueKey("Appbar"));

    await tester.pumpWidget(MaterialApp(
      home: SettingScreen(),
    ));

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFormField, findsOneWidget);
  });
}
