import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  List<String> _banned = [];
  List<String> get banned => _banned;

  SettingsViewModel() {
    load();
  }

  Future<void> load() async {
    _banned = await _storage.loadBanned();
    notifyListeners();
  }

  Future<void> add(String country) async {
    if (country.trim().isEmpty) return;
    _banned.add(country);
    await _storage.saveBanned(_banned);
    notifyListeners();
  }

  Future<void> removeAt(int i) async {
    _banned.removeAt(i);
    await _storage.saveBanned(_banned);
    notifyListeners();
  }
}
