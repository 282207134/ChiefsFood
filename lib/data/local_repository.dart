import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Stores demo data only. Passwords and payment card details never enter storage.
class LocalRepository {
  LocalRepository(this.preferences);
  final SharedPreferences preferences;
  Map<String, dynamic> read() {
    try {
      return jsonDecode(preferences.getString('chiefs_food_v1') ?? '{}')
          as Map<String, dynamic>;
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  Future<void> save(Map<String, dynamic> value) async {
    final saved = await preferences.setString(
      'chiefs_food_v1',
      jsonEncode(value),
    );
    if (!saved) throw StateError('Could not save your changes on this device.');
  }
}
