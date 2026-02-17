import 'package:shared_preferences/shared_preferences.dart';

class ProfileStorage {
  static const String _nameKey = 'profile_name';
  static const String _cityKey = 'profile_city';
  static const String _isLoggedInKey = 'is_logged_in';
  
  // Сохраняем имя
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }
  
  // Загружаем имя
  static Future<String> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? '';
  }
  
  // Сохраняем город
  static Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityKey, city);
  }
  
  // Загружаем город
  static Future<String> loadCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cityKey) ?? '';
  }
  
  // Сохраняем статус входа
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }
  
  // Проверяем, вошел ли пользователь
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  
  // Очищаем данные профиля
  static Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_cityKey);
    await prefs.remove(_isLoggedInKey);
  }
}