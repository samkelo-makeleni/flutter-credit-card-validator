import 'package:flutter/material.dart';
import 'package:flutter_application_credit_card_validator/scoped_models/credit_card_viewmodel.dart';
import 'package:flutter_application_credit_card_validator/scoped_models/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:card_scanner/card_scanner.dart';
import '../models/credit_card.dart';

class CreditCardFormView extends StatefulWidget {
  const CreditCardFormView({super.key});

  @override
  State<CreditCardFormView> createState() => _CreditCardFormViewState();
}

class _CreditCardFormViewState extends State<CreditCardFormView> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _cvv = TextEditingController();
  final _country = TextEditingController();

  @override
  void dispose() {
    _number.dispose();
    _cvv.dispose();
    _country.dispose();
    super.dispose();
  }

  bool _isCountryBanned(String country, List<String> banned) {
    return banned
        .map((e) => e.toLowerCase())
        .contains(country.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final cardVM = context.watch<CreditCardViewModel>();
    final settingsVM = context.watch<SettingsViewModel>();

    final countryInput = _country.text.trim();
    final isBanned = countryInput.isNotEmpty && _isCountryBanned(countryInput, settingsVM.banned);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _number,
                decoration: InputDecoration(
                  labelText: 'Card number',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        final details = await CardScanner.scanCard();
                        if (!mounted) return;
                        if (details == null) return;

                        final scannedNumber = details.cardNumber;
                        if (scannedNumber.isNotEmpty) {
                          _number.text = scannedNumber;
                          cardVM.infer(scannedNumber);
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('No card number detected')),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        messenger.showSnackBar(
                          SnackBar(content: Text('Card scan failed: $e')),
                        );
                      }
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: cardVM.infer,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter card number' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cvv,
                      decoration: const InputDecoration(labelText: 'CVC'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Enter cvc' : null,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _country,
                          decoration: InputDecoration(
                            labelText: 'Issuing country',
                            errorText: isBanned ? 'This country is banned' : null,
                            errorStyle: const TextStyle(color: Colors.red),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Enter country' : null,
                        ),
                        if (isBanned)
                          const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.warning, size: 16, color: Colors.red),
                                SizedBox(width: 4),
                                Text(
                                  'Country is banned',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Inferred: ${cardVM.inferred}'),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final messenger = ScaffoldMessenger.of(context);
                  final success = await cardVM.addCard(
                    CreditCardModel(
                      number: _number.text,
                      type: cardVM.inferred.isEmpty
                          ? 'Unknown'
                          : cardVM.inferred,
                      cvv: _cvv.text,
                      issuingCountry: _country.text.trim(),
                    ),
                    settingsVM.banned,
                  );
                  final msg = success
                      ? 'Card saved'
                      : 'Invalid / banned / duplicate';
                  messenger.showSnackBar(SnackBar(content: Text(msg)));
                  if (!mounted) return;
                  if (success) {
                    _number.clear();
                    _cvv.clear();
                    _country.clear();
                  }
                },
                child: const Text('Validate & Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
