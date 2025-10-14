
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_credit_card_validator/main.dart' as app;

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('App smoke test', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Credit Card Validator'), findsOneWidget);
  });
}
