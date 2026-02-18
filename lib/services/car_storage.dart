import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class CarStorage {
  static const String _carsKey = 'my_cars_list_v2';
  static const String _expensesKey = 'expenses_list';
  static const String _documentsKey = 'documents_list';
  static const String _profileKey = 'user_profile_v2';
  static const String _authKey = 'is_authenticated';
  static const String _contactKey = 'user_contact';
  static const String _isEmailKey = 'is_email';
  static const String _firstLaunchKey = 'is_first_launch';

  // ==================== CARS CRUD ====================
  
  static Future<void> saveCar(Car car) async {
    final prefs = await SharedPreferences.getInstance();
    final cars = await loadCarsList();
    final index = cars.indexWhere((c) => c.id == car.id);
    
    if (index >= 0) {
      cars[index] = car;
    } else {
      cars.add(car);
    }
    
    final carStrings = cars.map((c) => c.toJsonString()).toList();
    await prefs.setStringList(_carsKey, carStrings);
  }

  static Future<void> saveCars(List<Car> cars) async {
    final prefs = await SharedPreferences.getInstance();
    final carStrings = cars.map((c) => c.toJsonString()).toList();
    await prefs.setStringList(_carsKey, carStrings);
  }

  static Future<List<Car>> loadCarsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final carStrings = prefs.getStringList(_carsKey) ?? [];
      
      return carStrings.map((s) => Car.fromJsonString(s)).toList();
    } catch (e) {
      return [];
    }
  }

  @Deprecated('Use loadCarsList() instead')
  static Future<List<Map<String, dynamic>>> loadCars() async {
    final cars = await loadCarsList();
    return cars.map((c) => c.toJson()).toList();
  }

  static Future<Car?> getCarById(String id) async {
    final cars = await loadCarsList();
    try {
      return cars.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteCar(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cars = await loadCarsList();
    cars.removeWhere((c) => c.id == id);
    final carStrings = cars.map((c) => c.toJsonString()).toList();
    await prefs.setStringList(_carsKey, carStrings);
    
    // Optionally delete related expenses
    await deleteExpensesByCarId(id);
  }

  static Future<void> updateCarMileage(String carId, int mileage) async {
    final car = await getCarById(carId);
    if (car != null) {
      await saveCar(car.copyWith(mileage: mileage));
    }
  }

  // ==================== EXPENSES CRUD ====================

  static Future<void> saveExpense(Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final expenses = await loadExpensesList();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    
    if (index >= 0) {
      expenses[index] = expense;
    } else {
      expenses.add(expense);
    }
    
    final expenseStrings = expenses.map((e) => e.toJsonString()).toList();
    await prefs.setStringList(_expensesKey, expenseStrings);
  }

  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expenseStrings = expenses.map((e) => e.toJsonString()).toList();
    await prefs.setStringList(_expensesKey, expenseStrings);
  }

  static Future<List<Expense>> loadExpensesList({String? carId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expenseStrings = prefs.getStringList(_expensesKey) ?? [];
      
      var expenses = expenseStrings.map((s) => Expense.fromJsonString(s)).toList();
      
      if (carId != null) {
        expenses = expenses.where((e) => e.carId == carId).toList();
      }
      
      // Sort by date, newest first
      expenses.sort((a, b) => b.date.compareTo(a.date));
      
      return expenses;
    } catch (e) {
      return [];
    }
  }

  static Future<Expense?> getExpenseById(String id) async {
    final expenses = await loadExpensesList();
    try {
      return expenses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteExpense(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final expenses = await loadExpensesList();
    expenses.removeWhere((e) => e.id == id);
    final expenseStrings = expenses.map((e) => e.toJsonString()).toList();
    await prefs.setStringList(_expensesKey, expenseStrings);
  }

  static Future<void> deleteExpensesByCarId(String carId) async {
    final prefs = await SharedPreferences.getInstance();
    final expenses = await loadExpensesList();
    expenses.removeWhere((e) => e.carId == carId);
    final expenseStrings = expenses.map((e) => e.toJsonString()).toList();
    await prefs.setStringList(_expensesKey, expenseStrings);
  }

  static Future<List<Expense>> getExpensesByCategory(ExpenseCategory category) async {
    final expenses = await loadExpensesList();
    return expenses.where((e) => e.category == category).toList();
  }

  static Future<List<Expense>> getExpensesByDateRange(DateTime from, DateTime to, {String? carId}) async {
    var expenses = await loadExpensesList(carId: carId);
    return expenses.where((e) => 
      e.date.isAfter(from.subtract(const Duration(days: 1))) && 
      e.date.isBefore(to.add(const Duration(days: 1)))
    ).toList();
  }

  static Future<Map<String, dynamic>> getExpenseStats({String? carId, DateTime? from, DateTime? to}) async {
    var expenses = await loadExpensesList(carId: carId);
    
    if (from != null && to != null) {
      expenses = expenses.where((e) => 
        e.date.isAfter(from.subtract(const Duration(days: 1))) && 
        e.date.isBefore(to.add(const Duration(days: 1)))
      ).toList();
    }

    final totalAmount = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    
    final byCategory = <String, double>{};
    for (final expense in expenses) {
      byCategory[expense.category.code] = 
        (byCategory[expense.category.code] ?? 0) + expense.amount;
    }

    final byMonth = <String, double>{};
    for (final expense in expenses) {
      final monthKey = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      byMonth[monthKey] = (byMonth[monthKey] ?? 0) + expense.amount;
    }

    return {
      'total': totalAmount,
      'count': expenses.length,
      'average': expenses.isEmpty ? 0 : totalAmount / expenses.length,
      'byCategory': byCategory,
      'byMonth': byMonth,
    };
  }

  static Future<List<Expense>> getRecentExpenses({int limit = 5, String? carId}) async {
    final expenses = await loadExpensesList(carId: carId);
    return expenses.take(limit).toList();
  }

  // ==================== DOCUMENTS CRUD ====================

  static Future<void> saveDocument(Document document) async {
    final prefs = await SharedPreferences.getInstance();
    final documents = await loadDocumentsList();
    final index = documents.indexWhere((d) => d.id == document.id);
    
    if (index >= 0) {
      documents[index] = document;
    } else {
      documents.add(document);
    }
    
    final documentStrings = documents.map((d) => d.toJsonString()).toList();
    await prefs.setStringList(_documentsKey, documentStrings);
  }

  static Future<void> saveDocuments(List<Document> documents) async {
    final prefs = await SharedPreferences.getInstance();
    final documentStrings = documents.map((d) => d.toJsonString()).toList();
    await prefs.setStringList(_documentsKey, documentStrings);
  }

  static Future<List<Document>> loadDocumentsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documentStrings = prefs.getStringList(_documentsKey) ?? [];
      
      return documentStrings.map((s) => Document.fromJsonString(s)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Document?> getDocumentById(String id) async {
    final documents = await loadDocumentsList();
    try {
      return documents.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<Document?> getDocumentByType(DocumentType type) async {
    final documents = await loadDocumentsList();
    try {
      return documents.firstWhere((d) => d.type == type);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteDocument(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final documents = await loadDocumentsList();
    documents.removeWhere((d) => d.id == id);
    final documentStrings = documents.map((d) => d.toJsonString()).toList();
    await prefs.setStringList(_documentsKey, documentStrings);
  }

  static Future<List<Document>> getExpiringDocuments({int daysThreshold = 30}) async {
    final documents = await loadDocumentsList();
    final now = DateTime.now();
    
    return documents.where((d) {
      if (d.expiryDate == null) return false;
      final daysUntilExpiry = d.expiryDate!.difference(now).inDays;
      return daysUntilExpiry <= daysThreshold && daysUntilExpiry >= 0;
    }).toList();
  }

  static Future<List<Document>> getExpiredDocuments() async {
    final documents = await loadDocumentsList();
    final now = DateTime.now();
    
    return documents.where((d) {
      if (d.expiryDate == null) return false;
      return d.expiryDate!.isBefore(now);
    }).toList();
  }

  // ==================== PROFILE CRUD ====================

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, profile.copyWith(updatedAt: DateTime.now()).toJsonString());
  }

  static Future<UserProfile> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileString = prefs.getString(_profileKey);
      if (profileString != null) {
        return UserProfile.fromJsonString(profileString);
      }
    } catch (e) {
      // Fall through to empty profile
    }
    return UserProfile(name: '', city: '');
  }

  @Deprecated('Use saveUserProfile() instead')
  static Future<void> saveProfile({String? name, String? city}) async {
    final currentProfile = await loadUserProfile();
    await saveUserProfile(currentProfile.copyWith(
      name: name,
      city: city,
    ));
  }

  @Deprecated('Use loadUserProfile() instead')
  static Future<Map<String, String>> loadProfile() async {
    final profile = await loadUserProfile();
    return {
      'name': profile.name,
      'city': profile.city,
    };
  }

  // ==================== AUTH ====================

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

  // ==================== UTILITY ====================

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> clearExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expensesKey);
  }

  static Future<void> clearDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_documentsKey);
  }
}
