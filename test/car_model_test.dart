import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/models/car_model.dart';

void main() {
  group('Car Model Tests', () {
    test('Car creation from constructor', () {
      final car = Car(
        id: 'test-id-123',
        brand: 'Toyota',
        model: 'Camry',
        year: '2020',
        vin: 'XW7XXXXXX00000001',
        plate: 'А777АА77',
        addedDate: DateTime(2023, 1, 1),
        mileage: 50000,
      );

      expect(car.id, 'test-id-123');
      expect(car.brand, 'Toyota');
      expect(car.model, 'Camry');
      expect(car.year, '2020');
      expect(car.vin, 'XW7XXXXXX00000001');
      expect(car.plate, 'А777АА77');
      expect(car.mileage, 50000);
    });

    test('Car toJson and fromJson', () {
      final car = Car(
        id: 'test-id-456',
        brand: 'Honda',
        model: 'Civic',
        year: '2019',
        vin: 'XW8XXXXXX00000002',
        plate: 'В888ВВ88',
        addedDate: DateTime(2023, 6, 15),
        mileage: 30000,
      );

      final json = car.toJson();
      final restoredCar = Car.fromJson(json);

      expect(restoredCar.id, car.id);
      expect(restoredCar.brand, car.brand);
      expect(restoredCar.model, car.model);
      expect(restoredCar.year, car.year);
      expect(restoredCar.vin, car.vin);
      expect(restoredCar.plate, car.plate);
      expect(restoredCar.mileage, car.mileage);
    });

    test('Car toJsonString and fromJsonString', () {
      final car = Car(
        id: 'test-id-789',
        brand: 'BMW',
        model: 'X5',
        year: '2021',
        vin: 'XW9XXXXXX00000003',
        plate: 'С999СС99',
        addedDate: DateTime(2023, 3, 20),
        mileage: 25000,
      );

      final jsonString = car.toJsonString();
      final restoredCar = Car.fromJsonString(jsonString);

      expect(restoredCar.id, car.id);
      expect(restoredCar.brand, car.brand);
      expect(restoredCar.model, car.model);
    });

    test('Car copyWith', () {
      final originalCar = Car(
        id: 'original-id',
        brand: 'Audi',
        model: 'A4',
        year: '2018',
        addedDate: DateTime(2023, 1, 1),
        mileage: 100000,
      );

      final updatedCar = originalCar.copyWith(
        mileage: 105000,
        plate: 'Е111ЕЕ11',
      );

      expect(updatedCar.id, 'original-id');
      expect(updatedCar.brand, 'Audi');
      expect(updatedCar.model, 'A4');
      expect(updatedCar.mileage, 105000);
      expect(updatedCar.plate, 'Е111ЕЕ11');
    });

    test('Car displayName getter', () {
      final car = Car(
        id: 'test-id',
        brand: 'Mercedes',
        model: 'C-Class',
        year: '2022',
        addedDate: DateTime.now(),
      );

      expect(car.displayName, 'Mercedes C-Class');
    });

    test('Car shortInfo with plate', () {
      final car = Car(
        id: 'test-id',
        brand: 'Toyota',
        model: 'Corolla',
        year: '2020',
        plate: 'А123ВС134',
        addedDate: DateTime.now(),
      );

      expect(car.shortInfo, 'А123ВС134');
    });

    test('Car shortInfo with VIN (3 chars)', () {
      final car = Car(
        id: 'test-id',
        brand: 'Toyota',
        model: 'Corolla',
        year: '2020',
        vin: 'XW7ABCD123456789',
        addedDate: DateTime.now(),
      );

      expect(car.shortInfo, 'XW7');
    });

    test('Car shortInfo default (no plate or VIN)', () {
      final car = Car(
        id: 'test-id',
        brand: 'Toyota',
        model: 'Corolla',
        year: '2020',
        addedDate: DateTime.now(),
      );

      expect(car.shortInfo, '799');
    });

    test('Car fromJson handles missing optional fields', () {
      final json = {
        'id': 'test-id',
        'brand': 'Honda',
        'model': 'Accord',
        'year': '2021',
      };

      final car = Car.fromJson(json);

      expect(car.id, 'test-id');
      expect(car.brand, 'Honda');
      expect(car.vin, isNull);
      expect(car.plate, isNull);
      expect(car.mileage, isNull);
    });

    test('Car copyWith with null values', () {
      final car = Car(
        id: 'test-id',
        brand: 'Toyota',
        model: 'Camry',
        year: '2020',
        vin: 'XW7XXXXXX00000001',
        plate: 'А777АА77',
        addedDate: DateTime.now(),
        mileage: 50000,
      );

      final updatedCar = car.copyWith(vin: null, plate: null);

      expect(updatedCar.vin, isNull);
      expect(updatedCar.plate, isNull);
      expect(updatedCar.brand, 'Toyota');
    });
  });
}