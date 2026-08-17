import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _categoryKey = 'default_category';

  Future<void> saveDefaultCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _categoryKey,
      category,
    );
  }

  Future<String?> getDefaultCategory() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_categoryKey);
  }
}