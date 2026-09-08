import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_backend_app/presentation/widgets/app_button.dart';
import 'package:flutter_backend_app/presentation/widgets/status_views.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user opens the explorer and sees an empty state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: EmptyView(message: 'No products found.'))));
    expect(find.text('No products found.'), findsOneWidget);
  });

  testWidgets('user performs an action and sees the updated state', (tester) async {
    var completed = false;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: AppButton(label: 'Load data', onPressed: () => completed = true))));
    await tester.tap(find.text('Load data'));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });
}
