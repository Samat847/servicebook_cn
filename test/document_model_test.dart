import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/models/document_model.dart';

void main() {
  group('Document Model Tests', () {
    group('DocumentType Tests', () {
      test('All document types have unique codes', () {
        final codes = DocumentType.values.map((d) => d.code).toList();
        expect(codes.length, codes.toSet().length);
      });

      test('DocumentType fromCode returns correct type', () {
        final stsType = DocumentType.fromCode('sts');
        expect(stsType, DocumentType.sts);

        final ptsType = DocumentType.fromCode('pts');
        expect(ptsType, DocumentType.pts);

        final osagoType = DocumentType.fromCode('osago');
        expect(osagoType, DocumentType.osago);

        final unknownType = DocumentType.fromCode('unknown_code');
        expect(unknownType, DocumentType.sts);
      });

      test('Document type properties', () {
        expect(DocumentType.sts.displayName, 'СТС');
        expect(DocumentType.sts.code, 'sts');
        expect(DocumentType.sts.iconName, 'description');

        expect(DocumentType.pts.displayName, 'ПТС');
        expect(DocumentType.pts.code, 'pts');

        expect(DocumentType.driverLicense.displayName, 'Водительское удостоверение');
        expect(DocumentType.driverLicense.code, 'driver_license');

        expect(DocumentType.osago.colorValue, 0xFFFF9800);
        expect(DocumentType.casco.iconName, 'shield');
      });

      test('Document types color values are valid', () {
        for (final docType in DocumentType.values) {
          expect(docType.colorValue, isA<int>());
          expect(docType.colorValue, greaterThan(0));
        }
      });
    });

    group('DocumentStatus Tests', () {
      test('All document statuses have unique codes', () {
        final codes = DocumentStatus.values.map((s) => s.code).toList();
        expect(codes.length, codes.toSet().length);
      });

      test('DocumentStatus fromCode returns correct status', () {
        final activeStatus = DocumentStatus.fromCode('active');
        expect(activeStatus, DocumentStatus.active);

        final expiringStatus = DocumentStatus.fromCode('expiring');
        expect(expiringStatus, DocumentStatus.expiring);

        final expiredStatus = DocumentStatus.fromCode('expired');
        expect(expiredStatus, DocumentStatus.expired);

        final unknownStatus = DocumentStatus.fromCode('unknown_code');
        expect(unknownStatus, DocumentStatus.active);
      });

      test('Document status properties', () {
        expect(DocumentStatus.active.displayName, 'Действует');
        expect(DocumentStatus.active.code, 'active');
        expect(DocumentStatus.active.colorValue, 0xFF4CAF50);

        expect(DocumentStatus.expiring.displayName, 'Истекает');
        expect(DocumentStatus.expiring.code, 'expiring');
        expect(DocumentStatus.expiring.colorValue, 0xFFFF9800);

        expect(DocumentStatus.expired.displayName, 'Истек');
        expect(DocumentStatus.expired.code, 'expired');
        expect(DocumentStatus.expired.colorValue, 0xFFF44336);
      });
    });

    group('Document Tests', () {
      final baseDocument = Document(
        id: 'doc-123',
        type: DocumentType.sts,
        title: 'СТС на Toyota Camry',
        number: 'А777АА123456',
        issueDate: DateTime(2020, 5, 15),
        expiryDate: DateTime(2025, 5, 15),
        status: DocumentStatus.active,
        filePath: '/path/to/sts.pdf',
        notes: 'Документ в порядке',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 10, 15),
      );

      test('Document creation with all fields', () {
        expect(baseDocument.id, 'doc-123');
        expect(baseDocument.type, DocumentType.sts);
        expect(baseDocument.title, 'СТС на Toyota Camry');
        expect(baseDocument.number, 'А777АА123456');
        expect(baseDocument.issueDate, DateTime(2020, 5, 15));
        expect(baseDocument.expiryDate, DateTime(2025, 5, 15));
        expect(baseDocument.status, DocumentStatus.active);
        expect(baseDocument.filePath, '/path/to/sts.pdf');
        expect(baseDocument.notes, 'Документ в порядке');
      });

      test('Document toJson and fromJson', () {
        final json = baseDocument.toJson();
        final restoredDocument = Document.fromJson(json);

        expect(restoredDocument.id, baseDocument.id);
        expect(restoredDocument.type, baseDocument.type);
        expect(restoredDocument.title, baseDocument.title);
        expect(restoredDocument.number, baseDocument.number);
        expect(restoredDocument.status, baseDocument.status);
      });

      test('Document toJsonString and fromJsonString', () {
        final jsonString = baseDocument.toJsonString();
        final restoredDocument = Document.fromJsonString(jsonString);

        expect(restoredDocument.id, baseDocument.id);
        expect(restoredDocument.type, baseDocument.type);
        expect(restoredDocument.title, baseDocument.title);
      });

      test('Document copyWith', () {
        final updatedDocument = baseDocument.copyWith(
          title: 'Обновленный СТС',
          number: 'В888ВВ654321',
          status: DocumentStatus.expiring,
        );

        expect(updatedDocument.id, baseDocument.id);
        expect(updatedDocument.title, 'Обновленный СТС');
        expect(updatedDocument.number, 'В888ВВ654321');
        expect(updatedDocument.status, DocumentStatus.expiring);
        expect(updatedDocument.type, DocumentType.sts);
      });

      test('Document with minimal required fields', () {
        final minimalDocument = Document(
          id: 'minimal-doc-123',
          type: DocumentType.driverLicense,
          title: 'Водительское удостоверение',
          status: DocumentStatus.active,
        );

        expect(minimalDocument.id, 'minimal-doc-123');
        expect(minimalDocument.type, DocumentType.driverLicense);
        expect(minimalDocument.number, isNull);
        expect(minimalDocument.issueDate, isNull);
        expect(minimalDocument.expiryDate, isNull);
        expect(minimalDocument.filePath, isNull);
      });

      test('Document daysUntilExpiry calculation', () {
        final futureDocument = Document(
          id: 'future-doc',
          type: DocumentType.osago,
          title: 'ОСАГО',
          status: DocumentStatus.active,
          expiryDate: DateTime.now().add(const Duration(days: 30)),
        );

        final daysUntilExpiry = futureDocument.daysUntilExpiry;
        expect(daysUntilExpiry, equals(30));
      });

      test('Document daysUntilExpiry with null expiryDate', () {
        final documentWithoutExpiry = Document(
          id: 'no-expiry',
          type: DocumentType.pts,
          title: 'ПТС',
          status: DocumentStatus.active,
        );

        final daysUntilExpiry = documentWithoutExpiry.daysUntilExpiry;
        expect(daysUntilExpiry, isNull);
      });

      test('Document daysUntilExpiry for expired document', () {
        final expiredDocument = Document(
          id: 'expired-doc',
          type: DocumentType.casco,
          title: 'КАСКО',
          status: DocumentStatus.expired,
          expiryDate: DateTime.now().subtract(const Duration(days: 10)),
        );

        final daysUntilExpiry = expiredDocument.daysUntilExpiry;
        expect(daysUntilExpiry, equals(-10));
      });

      test('Document isExpiringSoon detection', () {
        final expiringSoonDocument = Document(
          id: 'expiring-soon',
          type: DocumentType.diagnosticCard,
          title: 'Диагностическая карта',
          status: DocumentStatus.expiring,
          expiryDate: DateTime.now().add(const Duration(days: 25)),
        );

        expect(expiringSoonDocument.isExpiringSoon, true);

        final notExpiringSoonDocument = Document(
          id: 'not-expiring-soon',
          type: DocumentType.diagnosticCard,
          title: 'Диагностическая карта',
          status: DocumentStatus.active,
          expiryDate: DateTime.now().add(const Duration(days: 60)),
        );

        expect(notExpiringSoonDocument.isExpiringSoon, false);
      });

      test('Document displayInfo getter', () {
        final documentWithNumber = Document(
          id: 'doc-1',
          type: DocumentType.sts,
          title: 'СТС',
          number: 'А123БВ456789',
          status: DocumentStatus.active,
        );

        expect(documentWithNumber.displayInfo, 'А123БВ456789');

        final documentWithoutNumber = Document(
          id: 'doc-2',
          type: DocumentType.pts,
          title: 'ПТС',
          status: DocumentStatus.active,
        );

        expect(documentWithoutNumber.displayInfo, 'ПТС');
      });

      test('Document photo management', () {
        final documentWithPhotos = Document(
          id: 'photo-doc',
          type: DocumentType.driverLicense,
          title: 'Водительское удостоверение',
          status: DocumentStatus.active,
          filePath: '/path/to/license.pdf',
          photoPaths: ['/path/to/photo1.jpg', '/path/to/photo2.jpg'],
        );

        expect(documentWithPhotos.photoPaths.length, 2);
        expect(documentWithPhotos.hasPhotos, true);
      });

      test('Document hasPhotos getter', () {
        final documentWithPhotos = Document(
          id: 'doc-with-photos',
          type: DocumentType.sts,
          title: 'СТС',
          status: DocumentStatus.active,
          photoPaths: ['photo1.jpg'],
        );
        expect(documentWithPhotos.hasPhotos, true);

        final documentWithoutPhotos = Document(
          id: 'doc-without-photos',
          type: DocumentType.pts,
          title: 'ПТС',
          status: DocumentStatus.active,
        );
        expect(documentWithoutPhotos.hasPhotos, false);
      });

      test('Document fromJson handles missing optional fields', () {
        final json = {
          'id': 'json-doc',
          'type': 'sts',
          'title': 'СТС из JSON',
          'status': 'active',
        };

        final document = Document.fromJson(json);

        expect(document.id, 'json-doc');
        expect(document.type, DocumentType.sts);
        expect(document.number, isNull);
        expect(document.issueDate, isNull);
        expect(document.expiryDate, isNull);
      });

      test('Document copyWith can clear optional fields', () {
        final document = baseDocument.copyWith(
          number: null,
          expiryDate: null,
          notes: null,
          filePath: null,
        );

        expect(document.number, isNull);
        expect(document.expiryDate, isNull);
        expect(document.notes, isNull);
        expect(document.filePath, isNull);
      });
    });
  });
}