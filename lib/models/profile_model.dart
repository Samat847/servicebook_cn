import 'dart:convert';

class UserProfile {
  final String name;
  final String city;
  final String? email;
  final String? phone;
  final String? photoPath;
  final DateTime? updatedAt;

  UserProfile({
    required this.name,
    required this.city,
    this.email,
    this.phone,
    this.photoPath,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      photoPath: json['photoPath'] as String?,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'email': email,
      'phone': phone,
      'photoPath': photoPath,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? name,
    String? city,
    String? email,
    String? phone,
    String? photoPath,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      city: city ?? this.city,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserProfile.fromJsonString(String jsonString) {
    return UserProfile.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  bool get isComplete => name.isNotEmpty && city.isNotEmpty;

  String get displayName => name.isNotEmpty ? name : 'Пользователь';
}
