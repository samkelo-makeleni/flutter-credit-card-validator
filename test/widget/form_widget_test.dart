import 'package:flutter_application_credit_card_validator/scoped_models/credit_card_viewmodel.dart' show CreditCardViewModel;
import 'package:flutter_application_credit_card_validator/scoped_models/settings_viewmodel.dart' show SettingsViewModel;
import 'package:flutter_application_credit_card_validator/pages/credit_card_form_view.dart' show CreditCardFormView;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('Credit card form renders with all fields', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CreditCardViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ],
        child: const MaterialApp(home: Scaffold(body: CreditCardFormView())),
      ),
    );

    // Verify form elements are present
    expect(find.text('Card number'), findsOneWidget);
    expect(find.text('CVC'), findsOneWidget);
    expect(find.text('Issuing country'), findsOneWidget);
    expect(find.text('Validate & Save'), findsOneWidget);
    expect(find.text('Inferred: '), findsOneWidget);
  });

  testWidgets('Form validation requires all fields', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CreditCardViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ],
        child: const MaterialApp(home: Scaffold(body: CreditCardFormView())),
      ),
    );

    // Try to tap save without filling any fields
    final btn = find.text('Validate & Save');
    await tester.tap(btn);
    await tester.pump();

    // Should show validation error for empty card number
    expect(find.text('Enter card number'), findsOneWidget);
  });

  testWidgets('Form accepts valid card number input', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CreditCardViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ],
        child: const MaterialApp(home: Scaffold(body: CreditCardFormView())),
      ),
    );

    // Fill in card number
    final numberField = find.byType(TextFormField).first;
    await tester.enterText(numberField, '4539578763621486');
    await tester.pump();

    // Verify the card type is inferred
    expect(find.text('Inferred: Visa'), findsOneWidget);
  });
}
