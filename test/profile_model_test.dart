import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/models/profile_model.dart';

void main() {
  group('UserProfile Model Tests', () {
    test('UserProfile creation with required fields', () {
      final profile = UserProfile(
        name: 'Иван Иванов',
        city: 'Москва',
      );

      expect(profile.name, 'Иван Иванов');
      expect(profile.city, 'Москва');
      expect(profile.email, isNull);
      expect(profile.phone, isNull);
      expect(profile.photoPath, isNull);
      expect(profile.updatedAt, isNull);
    });

    test('UserProfile creation with all fields', () {
      final now = DateTime.now();
      final profile = UserProfile(
        name: 'Петр Петров',
        city: 'Санкт-Петербург',
        email: 'petrov@example.com',
        phone: '+79001234567',
        photoPath: '/path/to/photo.jpg',
        updatedAt: now,
      );

      expect(profile.name, 'Петр Петров');
      expect(profile.city, 'Санкт-Петербург');
      expect(profile.email, 'petrov@example.com');
      expect(profile.phone, '+79001234567');
      expect(profile.photoPath, '/path/to/photo.jpg');
      expect(profile.updatedAt, now);
    });

    test('UserProfile toJson and fromJson', () {
      final profile = UserProfile(
        name: 'Алексей Смирнов',
        city: 'Казань',
        email: 'alex@example.com',
        phone: '+79001112233',
      );

      final json = profile.toJson();
      final restoredProfile = UserProfile.fromJson(json);

      expect(restoredProfile.name, profile.name);
      expect(restoredProfile.city, profile.city);
      expect(restoredProfile.email, profile.email);
      expect(restoredProfile.phone, profile.phone);
    });

    test('UserProfile toJsonString and fromJsonString', () {
      final profile = UserProfile(
        name: 'Николай Козлов',
        city: 'Екатеринбург',
        email: 'nikolay@example.com',
      );

      final jsonString = profile.toJsonString();
      final restoredProfile = UserProfile.fromJsonString(jsonString);

      expect(restoredProfile.name, 'Николай Козлов');
      expect(restoredProfile.city, 'Екатеринбург');
      expect(restoredProfile.email, 'nikolay@example.com');
    });

    test('UserProfile copyWith', () {
      final originalProfile = UserProfile(
        name: 'Иван',
        city: 'Москва',
        email: 'ivan@example.com',
      );

      final updatedProfile = originalProfile.copyWith(
        name: 'Иван Иванов',
        phone: '+79001234567',
      );

      expect(updatedProfile.name, 'Иван Иванов');
      expect(updatedProfile.city, 'Москва');
      expect(updatedProfile.email, 'ivan@example.com');
      expect(updatedProfile.phone, '+79001234567');
    });

    test('UserProfile copyWith can clear optional fields', () {
      final profile = UserProfile(
        name: 'Тест',
        city: 'Город',
        email: 'test@example.com',
        phone: '+79001234567',
        photoPath: '/path/to/photo.jpg',
      );

      final updatedProfile = profile.copyWith(
        email: null,
        phone: null,
        photoPath: null,
      );

      expect(updatedProfile.email, isNull);
      expect(updatedProfile.phone, isNull);
      expect(updatedProfile.photoPath, isNull);
      expect(updatedProfile.name, 'Тест');
    });

    test('UserProfile isComplete getter', () {
      final completeProfile = UserProfile(
        name: 'Иван Иванов',
        city: 'Москва',
      );
      expect(completeProfile.isComplete, true);

      final incompleteProfile1 = UserProfile(
        name: '',
        city: 'Москва',
      );
      expect(incompleteProfile1.isComplete, false);

      final incompleteProfile2 = UserProfile(
        name: 'Иван Иванов',
        city: '',
      );
      expect(incompleteProfile2.isComplete, false);

      final emptyProfile = UserProfile(
        name: '',
        city: '',
      );
      expect(emptyProfile.isComplete, false);
    });

    test('UserProfile displayName getter', () {
      final profileWithName = UserProfile(
        name: 'Мария Сидорова',
        city: 'Новосибирск',
      );
      expect(profileWithName.displayName, 'Мария Сидорова');

      final profileWithoutName = UserProfile(
        name: '',
        city: 'Воронеж',
      );
      expect(profileWithoutName.displayName, 'Пользователь');
    });

    test('UserProfile fromJson handles missing fields', () {
      final json = {
        'name': 'Тестовое имя',
        'city': 'Тестовый город',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.name, 'Тестовое имя');
      expect(profile.city, 'Тестовый город');
      expect(profile.email, isNull);
      expect(profile.phone, isNull);
      expect(profile.photoPath, isNull);
    });

    test('UserProfile fromJson handles null values', () {
      final json = <String, dynamic>{
        'name': null,
        'city': null,
        'email': null,
        'phone': null,
        'photoPath': null,
        'updatedAt': null,
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.name, '');
      expect(profile.city, '');
      expect(profile.email, isNull);
    });

    test('UserProfile toJson includes all fields', () {
      final now = DateTime.now();
      final profile = UserProfile(
        name: 'Полный профиль',
        city: 'Город',
        email: 'full@example.com',
        phone: '+79001234567',
        photoPath: '/path/to/photo.jpg',
        updatedAt: now,
      );

      final json = profile.toJson();

      expect(json['name'], 'Полный профиль');
      expect(json['city'], 'Город');
      expect(json['email'], 'full@example.com');
      expect(json['phone'], '+79001234567');
      expect(json['photoPath'], '/path/to/photo.jpg');
      expect(json['updatedAt'], now.toIso8601String());
    });

    test('UserProfile isComplete with only name', () {
      final profile = UserProfile(
        name: 'Только имя',
        city: '',
      );
      expect(profile.isComplete, false);
    });

    test('UserProfile isComplete with only city', () {
      final profile = UserProfile(
        name: '',
        city: 'Только город',
      );
      expect(profile.isComplete, false);
    });

    test('UserProfile displayName with only spaces in name', () {
      final profile = UserProfile(
        name: '   ',
        city: 'Город',
      );
      expect(profile.displayName, 'Пользователь');
    });
  });
}