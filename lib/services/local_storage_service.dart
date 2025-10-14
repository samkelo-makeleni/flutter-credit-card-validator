import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/credit_card.dart';

class LocalStorageService {
  static const _cardsKey = 'cards_v1';
  static const _bannedKey = 'banned_v1';

  Future<List<CreditCardModel>> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_cardsKey);
    if (s == null) return [];
    final list = (jsonDecode(s) as List)
        .map((e) => CreditCardModel.fromJson(e))
        .toList();
    return list;
  }

  Future<void> saveCards(List<CreditCardModel> cards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cardsKey,
      jsonEncode(cards.map((c) => c.toJson()).toList()),
    );
  }

  Future<List<String>> loadBanned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bannedKey) ?? ['Iran', 'North Korea'];
  }

  Future<void> saveBanned(List<String> banned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bannedKey, banned);
  }
}
