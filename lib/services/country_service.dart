import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_config.dart';

class CountryService {
  Future<List<String>> fetchCountryNames() async {
    final res = await http.get(Uri.parse(AppConfig.countriesApi));
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body) as List<dynamic>;
    final names = data
        .map((e) {
          final name = (e['name'] ?? {})['common'] ?? '';
          return name as String;
        })
        .where((s) => s.isNotEmpty)
        .toList();
    return names;
  }
}
