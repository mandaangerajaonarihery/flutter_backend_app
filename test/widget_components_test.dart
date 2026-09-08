import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_backend_app/presentation/widgets/app_button.dart';
import 'package:flutter_backend_app/presentation/widgets/app_text_field.dart';
import 'package:flutter_backend_app/presentation/widgets/status_views.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('app button displays its label', (tester) async {
    await tester.pumpWidget(host(const AppButton(label: 'Continue', onPressed: null)));
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('loading button displays progress indicator', (tester) async {
    await tester.pumpWidget(host(const AppButton(label: 'Continue', isLoading: true, onPressed: null)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('text field exposes its label', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(host(AppTextField(controller: controller, label: 'Email')));
    expect(find.text('Email'), findsOneWidget);
    controller.dispose();
  });

  testWidgets('empty state displays its message', (tester) async {
    await tester.pumpWidget(host(const EmptyView(message: 'Nothing here')));
    expect(find.text('Nothing here'), findsOneWidget);
  });

  testWidgets('error state exposes retry action', (tester) async {
    var retried = false;
    await tester.pumpWidget(host(ErrorView(message: 'Network error', onRetry: () => retried = true)));
    await tester.tap(find.text('Réessayer'));
    expect(retried, isTrue);
  });
}
