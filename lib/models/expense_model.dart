import 'dart:convert';

enum ExpenseCategory {
  fuel('Топливо', 'fuel', 'local_gas_station', 0xFFFF9800),
  maintenance('Обслуживание', 'maintenance', 'build', 0xFF2196F3),
  wash('Мойка', 'wash', 'local_car_wash', 0xFF4CAF50),
  repair('Ремонт', 'repair', 'car_repair', 0xFFF44336),
  insurance('Страховка', 'insurance', 'security', 0xFF3F51B5),
  parts('Запчасти', 'parts', 'shopping_bag', 0xFF9C27B0),
  diagnostics('Диагностика', 'diagnostics', 'search', 0xFF009688),
  tires('Шины', 'tires', 'tire_repair', 0xFF795548),
  other('Другое', 'other', 'more_horiz', 0xFF607D8B);

  final String displayName;
  final String code;
  final String iconName;
  final int colorValue;

  const ExpenseCategory(this.displayName, this.code, this.iconName, this.colorValue);

  static ExpenseCategory fromCode(String code) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.code == code,
      orElse: () => ExpenseCategory.other,
    );
  }

  static ExpenseCategory fromDisplayName(String name) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.displayName == name,
      orElse: () => ExpenseCategory.other,
    );
  }
}

class Expense {
  final String id;
  final String carId;
  final String title;
  final DateTime date;
  final int mileage;
  final double amount;
  final ExpenseCategory category;
  final String? place;
  final List<String> workTypes;
  final String? comment;
  final bool hasReceipt;
  final bool isConfirmed;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.carId,
    required this.title,
    required this.date,
    required this.mileage,
    required this.amount,
    required this.category,
    this.place,
    this.workTypes = const [],
    this.comment,
    this.hasReceipt = false,
    this.isConfirmed = false,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      carId: json['carId'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      mileage: json['mileage'] as int,
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategory.fromCode(json['category'] as String),
      place: json['place'] as String?,
      workTypes: (json['workTypes'] as List<dynamic>?)?.cast<String>() ?? [],
      comment: json['comment'] as String?,
      hasReceipt: json['hasReceipt'] as bool? ?? false,
      isConfirmed: json['isConfirmed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'title': title,
      'date': date.toIso8601String(),
      'mileage': mileage,
      'amount': amount,
      'category': category.code,
      'place': place,
      'workTypes': workTypes,
      'comment': comment,
      'hasReceipt': hasReceipt,
      'isConfirmed': isConfirmed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Expense copyWith({
    String? id,
    String? carId,
    String? title,
    DateTime? date,
    int? mileage,
    double? amount,
    ExpenseCategory? category,
    String? place,
    List<String>? workTypes,
    String? comment,
    bool? hasReceipt,
    bool? isConfirmed,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      title: title ?? this.title,
      date: date ?? this.date,
      mileage: mileage ?? this.mileage,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      place: place ?? this.place,
      workTypes: workTypes ?? this.workTypes,
      comment: comment ?? this.comment,
      hasReceipt: hasReceipt ?? this.hasReceipt,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Expense.fromJsonString(String jsonString) {
    return Expense.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  String get formattedAmount {
    final String amountStr = amount.toStringAsFixed(0);
    return amountStr.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  String get formattedMileage {
    return mileage.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  bool get isServiceRecord => 
    category == ExpenseCategory.maintenance ||
    category == ExpenseCategory.repair ||
    category == ExpenseCategory.diagnostics ||
    category == ExpenseCategory.parts;
}
