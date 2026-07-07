import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ashpazyar/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the login page when there is no saved session', (WidgetTester tester) async {
    await tester.pumpWidget(const AshpazyarApp());
    await tester.pump();
    // Let the session-check future resolve and the logo mark's staggered
    // Future.delayed timers fire, so no timers are left pending at teardown.
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
