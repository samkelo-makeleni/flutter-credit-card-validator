import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_view.dart';
import 'scoped_models/settings_viewmodel.dart';
import 'scoped_models/credit_card_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => CreditCardViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Card Validator',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeView(),
    );
  }
}
