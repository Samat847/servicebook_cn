import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servicebook_cn/models/car_model.dart';
import 'package:servicebook_cn/models/expense_model.dart';
import 'package:servicebook_cn/models/document_model.dart';
import 'package:servicebook_cn/models/profile_model.dart';
import 'package:servicebook_cn/services/car_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('CarStorage Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    group('Car CRUD Operations', () {
      test('Save and load car', () async {
        final car = Car(
          id: 'car-1',
          brand: 'Toyota',
          model: 'Camry',
          year: '2020',
          plate: 'А777АА77',
          addedDate: DateTime(2023, 1, 1),
          mileage: 50000,
        );

        await CarStorage.saveCar(car);
        final loadedCars = await CarStorage.loadCarsList();

        expect(loadedCars.length, 1);
        expect(loadedCars.first.id, 'car-1');
        expect(loadedCars.first.brand, 'Toyota');
        expect(loadedCars.first.model, 'Camry');
      });

      test('Save multiple cars', () async {
        final car1 = Car(
          id: 'car-1',
          brand: 'Toyota',
          model: 'Camry',
          year: '2020',
          addedDate: DateTime(2023, 1, 1),
        );

        final car2 = Car(
          id: 'car-2',
          brand: 'Honda',
          model: 'Civic',
          year: '2019',
          addedDate: DateTime(2023, 2, 1),
        );

        await CarStorage.saveCar(car1);
        await CarStorage.saveCar(car2);
        
        final loadedCars = await CarStorage.loadCarsList();
        expect(loadedCars.length, 2);
      });

      test('Update existing car', () async {
        final car = Car(
          id: 'car-1',
          brand: 'Toyota',
          model: 'Camry',
          year: '2020',
          addedDate: DateTime(2023, 1, 1),
          mileage: 50000,
        );

        await CarStorage.saveCar(car);
        
        final updatedCar = car.copyWith(mileage: 55000);
        await CarStorage.saveCar(updatedCar);

        final loadedCars = await CarStorage.loadCarsList();
        expect(loadedCars.length, 1);
        expect(loadedCars.first.mileage, 55000);
      });

      test('Delete car', () async {
        final car1 = Car(
          id: 'car-1',
          brand: 'Toyota',
          model: 'Camry',
          year: '2020',
          addedDate: DateTime(2023, 1, 1),
        );

        final car2 = Car(
          id: 'car-2',
          brand: 'Honda',
          model: 'Civic',
          year: '2019',
          addedDate: DateTime(2023, 2, 1),
        );

        await CarStorage.saveCar(car1);
        await CarStorage.saveCar(car2);
        await CarStorage.deleteCar('car-1');

        final loadedCars = await CarStorage.loadCarsList();
        expect(loadedCars.length, 1);
        expect(loadedCars.first.id, 'car-2');
      });

      test('Get car by ID', () async {
        final car = Car(
          id: 'unique-car-id',
          brand: 'BMW',
          model: 'X5',
          year: '2021',
          addedDate: DateTime(2023, 1, 1),
        );

        await CarStorage.saveCar(car);
        final foundCar = await CarStorage.getCarById('unique-car-id');

        expect(foundCar, isNotNull);
        expect(foundCar!.id, 'unique-car-id');
        expect(foundCar.brand, 'BMW');
      });

      test('Get car by non-existent ID returns null', () async {
        final foundCar = await CarStorage.getCarById('non-existent-id');
        expect(foundCar, isNull);
      });

      test('Update car mileage', () async {
        final car = Car(
          id: 'car-for-mileage',
          brand: 'Audi',
          model: 'A4',
          year: '2020',
          addedDate: DateTime(2023, 1, 1),
          mileage: 100000,
        );

        await CarStorage.saveCar(car);
        await CarStorage.updateCarMileage('car-for-mileage', 105000);

        final updatedCar = await CarStorage.getCarById('car-for-mileage');
        expect(updatedCar!.mileage, 105000);
      });
    });

    group('Expense CRUD Operations', () {
      test('Save and load expense', () async {
        final expense = Expense(
          id: 'expense-1',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: ['Топливо'],
        );

        await CarStorage.saveExpense(expense);
        final loadedExpenses = await CarStorage.loadExpensesList();

        expect(loadedExpenses.length, 1);
        expect(loadedExpenses.first.id, 'expense-1');
        expect(loadedExpenses.first.amount, 2500.0);
      });

      test('Load expenses by car ID', () async {
        final expense1 = Expense(
          id: 'expense-1',
          carId: 'car-1',
          title: 'Заправка 1',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        final expense2 = Expense(
          id: 'expense-2',
          carId: 'car-2',
          title: 'Заправка 2',
          date: DateTime(2023, 10, 16),
          mileage: 51000,
          amount: 3000.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        await CarStorage.saveExpense(expense1);
        await CarStorage.saveExpense(expense2);

        final car1Expenses = await CarStorage.loadExpensesList(carId: 'car-1');
        expect(car1Expenses.length, 1);
        expect(car1Expenses.first.carId, 'car-1');
      });

      test('Delete expense', () async {
        final expense = Expense(
          id: 'expense-to-delete',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        await CarStorage.saveExpense(expense);
        await CarStorage.deleteExpense('expense-to-delete');

        final loadedExpenses = await CarStorage.loadExpensesList();
        expect(loadedExpenses.length, 0);
      });

      test('Delete expenses by car ID', () async {
        final expense1 = Expense(
          id: 'expense-1',
          carId: 'car-to-delete',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        final expense2 = Expense(
          id: 'expense-2',
          carId: 'other-car',
          title: 'Заправка',
          date: DateTime(2023, 10, 16),
          mileage: 51000,
          amount: 3000.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        await CarStorage.saveExpense(expense1);
        await CarStorage.saveExpense(expense2);
        await CarStorage.deleteExpensesByCarId('car-to-delete');

        final loadedExpenses = await CarStorage.loadExpensesList();
        expect(loadedExpenses.length, 1);
        expect(loadedExpenses.first.carId, 'other-car');
      });

      test('Get expenses by category', () async {
        final fuelExpense = Expense(
          id: 'fuel-expense',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        final maintenanceExpense = Expense(
          id: 'maintenance-expense',
          carId: 'car-1',
          title: 'ТО',
          date: DateTime(2023, 10, 16),
          mileage: 51000,
          amount: 5000.0,
          category: ExpenseCategory.maintenance,
          workTypes: [],
        );

        await CarStorage.saveExpense(fuelExpense);
        await CarStorage.saveExpense(maintenanceExpense);

        final fuelExpenses = await CarStorage.getExpensesByCategory(ExpenseCategory.fuel);
        expect(fuelExpenses.length, 1);
        expect(fuelExpenses.first.category, ExpenseCategory.fuel);
      });

      test('Get expenses by date range', () async {
        final expense1 = Expense(
          id: 'expense-1',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 5, 1),
          mileage: 40000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        final expense2 = Expense(
          id: 'expense-2',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 7, 15),
          mileage: 45000,
          amount: 3000.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        final expense3 = Expense(
          id: 'expense-3',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 10, 1),
          mileage: 50000,
          amount: 3500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        await CarStorage.saveExpense(expense1);
        await CarStorage.saveExpense(expense2);
        await CarStorage.saveExpense(expense3);

        final rangeExpenses = await CarStorage.getExpensesByDateRange(
          DateTime(2023, 6, 1),
          DateTime(2023, 8, 31),
        );

        expect(rangeExpenses.length, 1);
        expect(rangeExpenses.first.id, 'expense-2');
      });
    });

    group('Document CRUD Operations', () {
      test('Save and load document', () async {
        final document = Document(
          id: 'doc-1',
          type: DocumentType.sts,
          title: 'СТС',
          number: 'А777АА123456',
          status: DocumentStatus.active,
        );

        await CarStorage.saveDocument(document);
        final loadedDocuments = await CarStorage.loadDocumentsList();

        expect(loadedDocuments.length, 1);
        expect(loadedDocuments.first.id, 'doc-1');
        expect(loadedDocuments.first.type, DocumentType.sts);
      });

      test('Get document by type', () async {
        final stsDocument = Document(
          id: 'doc-sts',
          type: DocumentType.sts,
          title: 'СТС',
          status: DocumentStatus.active,
        );

        final osagoDocument = Document(
          id: 'doc-osago',
          type: DocumentType.osago,
          title: 'ОСАГО',
          status: DocumentStatus.active,
        );

        await CarStorage.saveDocument(stsDocument);
        await CarStorage.saveDocument(osagoDocument);

        final foundSts = await CarStorage.getDocumentByType(DocumentType.sts);
        expect(foundSts, isNotNull);
        expect(foundSts!.type, DocumentType.sts);
      });

      test('Get expiring documents', () async {
        final activeDocument = Document(
          id: 'doc-active',
          type: DocumentType.sts,
          title: 'СТС',
          status: DocumentStatus.active,
          expiryDate: DateTime.now().add(const Duration(days: 15)),
        );

        final expiringSoonDocument = Document(
          id: 'doc-expiring',
          type: DocumentType.osago,
          title: 'ОСАГО',
          status: DocumentStatus.expiring,
          expiryDate: DateTime.now().add(const Duration(days: 10)),
        );

        await CarStorage.saveDocument(activeDocument);
        await CarStorage.saveDocument(expiringSoonDocument);

        final expiringDocs = await CarStorage.getExpiringDocuments(daysThreshold: 30);
        expect(expiringDocs.length, 2);
      });

      test('Get expired documents', () async {
        final activeDocument = Document(
          id: 'doc-active',
          type: DocumentType.sts,
          title: 'СТС',
          status: DocumentStatus.active,
        );

        final expiredDocument = Document(
          id: 'doc-expired',
          type: DocumentType.osago,
          title: 'ОСАГО',
          status: DocumentStatus.expired,
          expiryDate: DateTime.now().subtract(const Duration(days: 5)),
        );

        await CarStorage.saveDocument(activeDocument);
        await CarStorage.saveDocument(expiredDocument);

        final expiredDocs = await CarStorage.getExpiredDocuments();
        expect(expiredDocs.length, 1);
        expect(expiredDocs.first.id, 'doc-expired');
      });

      test('Delete document', () async {
        final document = Document(
          id: 'doc-to-delete',
          type: DocumentType.sts,
          title: 'СТС',
          status: DocumentStatus.active,
        );

        await CarStorage.saveDocument(document);
        await CarStorage.deleteDocument('doc-to-delete');

        final loadedDocuments = await CarStorage.loadDocumentsList();
        expect(loadedDocuments.length, 0);
      });
    });

    group('Profile Operations', () {
      test('Save and load user profile', () async {
        final profile = UserProfile(
          name: 'Иван Иванов',
          city: 'Москва',
          email: 'ivan@example.com',
        );

        await CarStorage.saveUserProfile(profile);
        final loadedProfile = await CarStorage.loadUserProfile();

        expect(loadedProfile.name, 'Иван Иванов');
        expect(loadedProfile.city, 'Москва');
        expect(loadedProfile.email, 'ivan@example.com');
      });

      test('Load profile returns default for empty storage', () async {
        final profile = await CarStorage.loadUserProfile();

        expect(profile.name, '');
        expect(profile.city, '');
      });
    });

    group('Auth Operations', () {
      test('Save and check authentication status', () async {
        await CarStorage.saveAuthStatus(true);
        final isAuth = await CarStorage.isAuthenticated();

        expect(isAuth, true);
      });

      test('Default authentication status is false', () async {
        final isAuth = await CarStorage.isAuthenticated();
        expect(isAuth, false);
      });
    });

    group('Clear Operations', () {
      test('Clear all data', () async {
        final car = Car(
          id: 'car-1',
          brand: 'Toyota',
          model: 'Camry',
          year: '2020',
          addedDate: DateTime(2023, 1, 1),
        );

        final expense = Expense(
          id: 'expense-1',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        await CarStorage.saveCar(car);
        await CarStorage.saveExpense(expense);

        await CarStorage.clearAll();

        final cars = await CarStorage.loadCarsList();
        final expenses = await CarStorage.loadExpensesList();

        expect(cars.length, 0);
        expect(expenses.length, 0);
      });

      test('Clear expenses only', () async {
        final car = Car(
          id: 'car-1',
          brand: 'Toyota',
          model: 'Camry',
          year: '2020',
          addedDate: DateTime(2023, 1, 1),
        );

        final expense = Expense(
          id: 'expense-1',
          carId: 'car-1',
          title: 'Заправка',
          date: DateTime(2023, 10, 15),
          mileage: 50000,
          amount: 2500.0,
          category: ExpenseCategory.fuel,
          workTypes: [],
        );

        await CarStorage.saveCar(car);
        await CarStorage.saveExpense(expense);

        await CarStorage.clearExpenses();

        final cars = await CarStorage.loadCarsList();
        final expenses = await CarStorage.loadExpensesList();

        expect(cars.length, 1);
        expect(expenses.length, 0);
      });
    });
  });
}