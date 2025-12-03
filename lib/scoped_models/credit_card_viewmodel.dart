import 'package:flutter/material.dart';
import '../models/credit_card.dart';
import '../services/local_storage_service.dart';

String normalize(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

String inferCardType(String number) {
  final n = normalize(number);
  if (n.startsWith('4')) return 'Visa';
  if (RegExp(r'^(5[1-5]|2)').hasMatch(n)) return 'MasterCard';
  if (n.startsWith('34') || n.startsWith('37')) return 'American Express';
  if (n.startsWith('6011') || n.startsWith('65')) return 'Discover';
  return 'Unknown';
}
bool luhnCheck(String number) {
  final n = normalize(number);
  final digits = n.split('').map(int.parse).toList().reversed.toList();
  int sum = 0;
  for (var i = 0; i < digits.length; i++) {
    var d = digits[i];
    if (i % 2 == 1) {
      d *= 2;
      if (d > 9) d -= 9;
    }
    sum += d;
  }
  return sum % 10 == 0;
}

class CreditCardViewModel extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final List<CreditCardModel> _cards = [];
  List<CreditCardModel> get cards => _cards;

  String inferred = '';

  CreditCardViewModel() {
    loadCards();
  }

  void infer(String number) {
    inferred = inferCardType(number);
    notifyListeners();
  }

  Future<void> loadCards() async {
    _cards.clear();
    _cards.addAll(await _storage.loadCards());
    notifyListeners();
  }

  Future<bool> addCard(CreditCardModel card, List<String> banned) async {
    final norm = normalize(card.number);
    if (banned
        .map((e) => e.toLowerCase())
        .contains(card.issuingCountry.toLowerCase())) {
      return false;
    }
    if (!luhnCheck(norm)) return false;
    if (_cards.any((c) => c.number == norm)) return false;

    final toSave = CreditCardModel(
      number: norm,
      type: card.type,
      cvv: card.cvv,
      issuingCountry: card.issuingCountry,
    );
    _cards.add(toSave);
    await _storage.saveCards(_cards);
    notifyListeners();
    return true;
  }

  Future<void> deleteAt(int i) async {
    _cards.removeAt(i);
    await _storage.saveCards(_cards);
    notifyListeners();
  }
}
