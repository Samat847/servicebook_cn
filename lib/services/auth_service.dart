import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loginKey = 'user_login';
  static const String _passwordHashKey = 'user_password_hash';
  static const String _authTypeKey = 'auth_type';
  
  static const int AUTH_TYPE_PHONE = 0;
  static const int AUTH_TYPE_PASSWORD = 1;

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<bool> registerUser(String login, String password) async {
    if (login.isEmpty || password.isEmpty) return false;
    
    final prefs = await SharedPreferences.getInstance();
    
    final existingLogin = prefs.getString(_loginKey);
    if (existingLogin != null && existingLogin.isNotEmpty) {
      return false;
    }
    
    await prefs.setString(_loginKey, login);
    await prefs.setString(_passwordHashKey, _hashPassword(password));
    await prefs.setInt(_authTypeKey, AUTH_TYPE_PASSWORD);
    await prefs.setBool('is_authenticated', true);
    
    return true;
  }

  static Future<bool> loginUser(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    final storedLogin = prefs.getString(_loginKey);
    final storedPasswordHash = prefs.getString(_passwordHashKey);
    final authType = prefs.getInt(_authTypeKey);
    
    if (authType != AUTH_TYPE_PASSWORD) {
      return false;
    }
    
    if (storedLogin == null || storedPasswordHash == null) {
      return false;
    }
    
    if (storedLogin != login) {
      return false;
    }
    
    final inputPasswordHash = _hashPassword(password);
    if (inputPasswordHash != storedPasswordHash) {
      return false;
    }
    
    await prefs.setBool('is_authenticated', true);
    return true;
  }

  static Future<bool> isPasswordAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_authTypeKey) == AUTH_TYPE_PASSWORD;
  }

  static Future<bool> hasLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final login = prefs.getString(_loginKey);
    return login != null && login.isNotEmpty;
  }

  static Future<String?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginKey);
  }

  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    
    final authType = prefs.getInt(_authTypeKey);
    if (authType != AUTH_TYPE_PASSWORD) {
      return false;
    }
    
    final storedPasswordHash = prefs.getString(_passwordHashKey);
    if (storedPasswordHash == null) {
      return false;
    }
    
    final oldPasswordHash = _hashPassword(oldPassword);
    if (oldPasswordHash != storedPasswordHash) {
      return false;
    }
    
    await prefs.setString(_passwordHashKey, _hashPassword(newPassword));
    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', false);
  }

  static Future<bool> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_loginKey);
    await prefs.remove(_passwordHashKey);
    await prefs.remove(_authTypeKey);
    await prefs.setBool('is_authenticated', false);
    
    return true;
  }
}
