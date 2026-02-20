import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/models/expense_model.dart';

void main() {
  group('Expense Model Tests', () {
    group('ExpenseCategory Tests', () {
      test('All expense categories have unique codes', () {
        final codes = ExpenseCategory.values.map((c) => c.code).toList();
        expect(codes.length, codes.toSet().length);
      });

      test('ExpenseCategory fromCode returns correct category', () {
        final fuelCategory = ExpenseCategory.fromCode('fuel');
        expect(fuelCategory, ExpenseCategory.fuel);

        final maintenanceCategory = ExpenseCategory.fromCode('maintenance');
        expect(maintenanceCategory, ExpenseCategory.maintenance);

        final unknownCategory = ExpenseCategory.fromCode('unknown_code');
        expect(unknownCategory, ExpenseCategory.other);
      });

      test('ExpenseCategory fromDisplayName returns correct category', () {
        final fuelCategory = ExpenseCategory.fromDisplayName('Топливо');
        expect(fuelCategory, ExpenseCategory.fuel);

        final washCategory = ExpenseCategory.fromDisplayName('Мойка');
        expect(washCategory, ExpenseCategory.wash);

        final unknownCategory = ExpenseCategory.fromDisplayName('Неизвестная категория');
        expect(unknownCategory, ExpenseCategory.other);
      });

      test('Expense category properties', () {
        expect(ExpenseCategory.fuel.displayName, 'Топливо');
        expect(ExpenseCategory.fuel.code, 'fuel');
        expect(ExpenseCategory.fuel.iconName, 'local_gas_station');
        expect(ExpenseCategory.fuel.colorValue, isA<int>());

        expect(ExpenseCategory.maintenance.displayName, 'Обслуживание');
        expect(ExpenseCategory.maintenance.code, 'maintenance');
        expect(ExpenseCategory.repair.colorValue, 0xFFF44336);
      });
    });

    group('Expense Tests', () {
      final baseExpense = Expense(
        id: 'expense-123',
        carId: 'car-456',
        title: 'Заправка',
        date: DateTime(2023, 10, 15),
        mileage: 50000,
        amount: 2500.0,
        category: ExpenseCategory.fuel,
        place: 'Лукойл',
        workTypes: ['Топливо'],
        comment: 'Полный бак',
        hasReceipt: true,
        receiptPhotoPath: '/path/to/receipt.jpg',
        photoPaths: ['/path/to/photo1.jpg'],
        isConfirmed: true,
        createdAt: DateTime(2023, 10, 15, 10, 30),
      );

      test('Expense creation with all fields', () {
        expect(baseExpense.id, 'expense-123');
        expect(baseExpense.carId, 'car-456');
        expect(baseExpense.title, 'Заправка');
        expect(baseExpense.date, DateTime(2023, 10, 15));
        expect(baseExpense.mileage, 50000);
        expect(baseExpense.amount, 2500.0);
        expect(baseExpense.category, ExpenseCategory.fuel);
        expect(baseExpense.place, 'Лукойл');
        expect(baseExpense.comment, 'Полный бак');
        expect(baseExpense.hasReceipt, true);
        expect(baseExpense.isConfirmed, true);
      });

      test('Expense toJson and fromJson', () {
        final json = baseExpense.toJson();
        final restoredExpense = Expense.fromJson(json);

        expect(restoredExpense.id, baseExpense.id);
        expect(restoredExpense.carId, baseExpense.carId);
        expect(restoredExpense.title, baseExpense.title);
        expect(restoredExpense.amount, baseExpense.amount);
        expect(restoredExpense.category, baseExpense.category);
      });

      test('Expense toJsonString and fromJsonString', () {
        final jsonString = baseExpense.toJsonString();
        final restoredExpense = Expense.fromJsonString(jsonString);

        expect(restoredExpense.id, baseExpense.id);
        expect(restoredExpense.title, baseExpense.title);
        expect(restoredExpense.amount, baseExpense.amount);
      });

      test('Expense copyWith', () {
        final updatedExpense = baseExpense.copyWith(
          amount: 3000.0,
          place: 'Газпромнефть',
          comment: 'Новый комментарий',
        );

        expect(updatedExpense.id, baseExpense.id);
        expect(updatedExpense.amount, 3000.0);
        expect(updatedExpense.place, 'Газпромнефть');
        expect(updatedExpense.comment, 'Новый комментарий');
        expect(updatedExpense.category, ExpenseCategory.fuel);
      });

      test('Expense with minimal required fields', () {
        final minimalExpense = Expense(
          id: 'minimal-123',
          carId: 'car-456',
          title: 'Минимальная трата',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 100.0,
          category: ExpenseCategory.other,
          workTypes: [],
        );

        expect(minimalExpense.id, 'minimal-123');
        expect(minimalExpense.place, isNull);
        expect(minimalExpense.comment, isNull);
        expect(minimalExpense.hasReceipt, false);
        expect(minimalExpense.isConfirmed, false);
      });

      test('Expense equality', () {
        final expense1 = Expense(
          id: 'expense-123',
          carId: 'car-456',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: ['Топливо'],
        );

        final expense2 = Expense(
          id: 'expense-123',
          carId: 'car-456',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: ['Топливо'],
        );

        expect(expense1.id, expense2.id);
        expect(expense1.title, expense2.title);
        expect(expense1.amount, equals(expense2.amount));
      });

      test('Expense workTypes processing', () {
        final expenseWithWorkTypes = Expense(
          id: 'test-123',
          carId: 'car-456',
          title: 'ТО',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 5000.0,
          category: ExpenseCategory.maintenance,
          workTypes: ['Замена масла', 'Замена фильтра', 'Диагностика'],
        );

        expect(expenseWithWorkTypes.workTypes.length, 3);
        expect(expenseWithWorkTypes.workTypes, contains('Замена масла'));
        expect(expenseWithWorkTypes.workTypes, contains('Замена фильтра'));
      });

      test('Expense photo management', () {
        final expenseWithPhotos = Expense(
          id: 'photo-test-123',
          carId: 'car-456',
          title: 'ТО с фото',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 3000.0,
          category: ExpenseCategory.maintenance,
          workTypes: ['Замена масла'],
          hasReceipt: true,
          receiptPhotoPath: '/path/to/receipt.jpg',
          photoPaths: ['/path/to/photo1.jpg', '/path/to/photo2.jpg', '/path/to/photo3.jpg'],
        );

        expect(expenseWithPhotos.hasReceipt, true);
        expect(expenseWithPhotos.receiptPhotoPath, '/path/to/receipt.jpg');
        expect(expenseWithPhotos.photoPaths.length, 3);
      });

      test('Expense createdAt default', () {
        final expenseWithDefaultCreatedAt = Expense(
          id: 'default-created-123',
          carId: 'car-456',
          title: 'Тест',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 100.0,
          category: ExpenseCategory.other,
          workTypes: [],
        );

        expect(expenseWithDefaultCreatedAt.createdAt, isA<DateTime>());
      });
    });
  });
}