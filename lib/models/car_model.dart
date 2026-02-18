import 'dart:convert';

class Car {
  final String id;
  final String brand;
  final String model;
  final String year;
  final String? vin;
  final String? plate;
  final DateTime addedDate;
  final int? mileage;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    this.vin,
    this.plate,
    required this.addedDate,
    this.mileage,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      vin: json['vin'] as String?,
      plate: json['plate'] as String?,
      addedDate: DateTime.parse(json['addedDate'] as String),
      mileage: json['mileage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'vin': vin,
      'plate': plate,
      'addedDate': addedDate.toIso8601String(),
      'mileage': mileage,
    };
  }

  Car copyWith({
    String? id,
    String? brand,
    String? model,
    String? year,
    String? vin,
    String? plate,
    DateTime? addedDate,
    int? mileage,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      vin: vin ?? this.vin,
      plate: plate ?? this.plate,
      addedDate: addedDate ?? this.addedDate,
      mileage: mileage ?? this.mileage,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Car.fromJsonString(String jsonString) {
    return Car.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  String get displayName => '$brand $model';

  String get shortInfo => plate != null && plate!.isNotEmpty ? plate! : (vin != null && vin!.length >= 3 ? vin!.substring(0, 3) : '799');
}
