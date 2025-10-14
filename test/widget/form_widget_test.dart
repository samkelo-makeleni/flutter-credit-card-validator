import 'package:flutter_application_credit_card_validator/scoped_models/credit_card_viewmodel.dart' show CreditCardViewModel;
import 'package:flutter_application_credit_card_validator/scoped_models/settings_viewmodel.dart' show SettingsViewModel;
import 'package:flutter_application_credit_card_validator/pages/credit_card_form_view.dart' show CreditCardFormView;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('Form validation and save flow', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CreditCardViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ],
        child: const MaterialApp(home: Scaffold(body: CreditCardFormView())),
      ),
    );

    final number = find.byType(TextFormField).first;
    await tester.enterText(number, '4539578763621486');
    final cvv = find.byType(TextFormField).at(1);
    await tester.enterText(cvv, '123');
    final country = find.byType(TextFormField).at(2);
    await tester.enterText(country, 'South Africa');

    final btn = find.text('Validate & Save');
    await tester.tap(btn);
    await tester.pumpAndSettle();

    expect(find.text('Card saved'), findsOneWidget);
  });
}
