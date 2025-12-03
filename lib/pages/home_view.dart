import 'package:flutter/material.dart';
import 'credit_card_form_view.dart';
import 'saved_cards_view.dart';
import 'settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Credit Card Validator')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsView()),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 120,),
            CreditCardFormView(),
            SizedBox(height: 12),
            Expanded(child: SavedCardsView()),
          ],
        ),
      ),
    );
  }
}
