import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_credit_card_validator/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_credit_card_validator/scoped_models/credit_card_viewmodel.dart';
import 'package:flutter_application_credit_card_validator/scoped_models/settings_viewmodel.dart';

void main() {
  testWidgets('App smoke test - renders home view', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
          ChangeNotifierProvider(create: (_) => CreditCardViewModel()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Credit Card Validator'), findsOneWidget);
    expect(find.text('Validate & Save'), findsOneWidget);
  });
}
