import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static Future saveKeyInLocal(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  static getKeyValueFromLocal(String key) async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(key)) {
      final value = pref.getString(key);
      return value as String;
    }
    return '';
  }

  static Future<bool> hasKeyInLocal(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey(key);
  }

  static Future removeKeyFromLocal(String key) async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(key)) {
      await pref.remove(key);
    }
  }
}
