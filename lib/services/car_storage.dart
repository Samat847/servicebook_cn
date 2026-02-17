import 'package:shared_preferences/shared_preferences.dart';

class CarStorage {
  static const String _carsKey = 'my_cars_list';
  static const String _profileNameKey = 'profile_name';
  static const String _profileCityKey = 'profile_city';
  static const String _authKey = 'is_authenticated';
  static const String _contactKey = 'user_contact';
  static const String _isEmailKey = 'is_email';
  static const String _firstLaunchKey = 'is_first_launch';

  static Future<void> saveCars(List<Map<String, dynamic>> cars) async {
    final prefs = await SharedPreferences.getInstance();
    
    final carStrings = cars.map((car) {
      return '${car['brand']}|${car['model']}|${car['year']}|${car['vin'] ?? ''}|${car['plate'] ?? ''}|${car['addedDate']}';
    }).toList();
    
    await prefs.setStringList(_carsKey, carStrings);
  }
  
  static Future<List<Map<String, dynamic>>> loadCars() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final carStrings = prefs.getStringList(_carsKey) ?? [];
      
      final List<Map<String, dynamic>> cars = [];
      
      for (final carString in carStrings) {
        final parts = carString.split('|');
        if (parts.length >= 6) {
          final car = {
            'brand': parts[0],
            'model': parts[1],
            'year': parts[2],
            'vin': parts[3].isEmpty ? null : parts[3],
            'plate': parts[4].isEmpty ? null : parts[4],
            'addedDate': parts[5],
          };
          cars.add(car);
        }
      }
      
      return cars;
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveProfile({String? name, String? city}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString(_profileNameKey, name);
    if (city != null) await prefs.setString(_profileCityKey, city);
  }

  static Future<Map<String, String>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_profileNameKey) ?? '';
    final city = prefs.getString(_profileCityKey) ?? '';
    return {'name': name, 'city': city};
  }

  static Future<void> saveAuthStatus(bool isAuth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, isAuth);
  }

  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authKey) ?? false;
  }

  static Future<void> saveContact(String contact, bool isEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contactKey, contact);
    await prefs.setBool(_isEmailKey, isEmail);
  }

  static Future<Map<String, dynamic>> loadContact() async {
    final prefs = await SharedPreferences.getInstance();
    final contact = prefs.getString(_contactKey) ?? '';
    final isEmail = prefs.getBool(_isEmailKey) ?? false;
    return {'contact': contact, 'isEmail': isEmail};
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}