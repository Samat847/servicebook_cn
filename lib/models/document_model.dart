import 'dart:convert';

enum DocumentType {
  sts('СТС', 'sts', 'description', 0xFF2196F3),
  pts('ПТС', 'pts', 'article', 0xFF9C27B0),
  driverLicense('Водительское удостоверение', 'driver_license', 'assignment_ind', 0xFF4CAF50),
  osago('ОСАГО', 'osago', 'car_crash', 0xFFFF9800),
  diagnosticCard('Диагностическая карта', 'diagnostic_card', 'verified', 0xFF009688),
  casco('КАСКО', 'casco', 'shield', 0xFF3F51B5);

  final String displayName;
  final String code;
  final String iconName;
  final int colorValue;

  const DocumentType(this.displayName, this.code, this.iconName, this.colorValue);

  static DocumentType fromCode(String code) {
    return DocumentType.values.firstWhere(
      (t) => t.code == code,
      orElse: () => DocumentType.sts,
    );
  }
}

enum DocumentStatus {
  active('Действует', 'active', 0xFF4CAF50),
  expiring('Истекает', 'expiring', 0xFFFF9800),
  expired('Истек', 'expired', 0xFFF44336);

  final String displayName;
  final String code;
  final int colorValue;

  const DocumentStatus(this.displayName, this.code, this.colorValue);

  static DocumentStatus fromCode(String code) {
    return DocumentStatus.values.firstWhere(
      (s) => s.code == code,
      orElse: () => DocumentStatus.active,
    );
  }
}

class Document {
  final String id;
  final DocumentType type;
  final String title;
  final String? number;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final DocumentStatus status;
  final String? organization;
  final Map<String, dynamic>? additionalData;
  final DateTime createdAt;
  final DateTime updatedAt;

  Document({
    required this.id,
    required this.type,
    required this.title,
    this.number,
    this.issueDate,
    this.expiryDate,
    this.status = DocumentStatus.active,
    this.organization,
    this.additionalData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      type: DocumentType.fromCode(json['type'] as String),
      title: json['title'] as String,
      number: json['number'] as String?,
      issueDate: json['issueDate'] != null 
          ? DateTime.parse(json['issueDate'] as String) 
          : null,
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate'] as String) 
          : null,
      status: DocumentStatus.fromCode(json['status'] as String? ?? 'active'),
      organization: json['organization'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.code,
      'title': title,
      'number': number,
      'issueDate': issueDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'status': status.code,
      'organization': organization,
      'additionalData': additionalData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Document copyWith({
    String? id,
    DocumentType? type,
    String? title,
    String? number,
    DateTime? issueDate,
    DateTime? expiryDate,
    DocumentStatus? status,
    String? organization,
    Map<String, dynamic>? additionalData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Document(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      number: number ?? this.number,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      organization: organization ?? this.organization,
      additionalData: additionalData ?? this.additionalData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Document.fromJsonString(String jsonString) {
    return Document.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  String get expiryDisplay {
    if (expiryDate == null) return 'Бессрочно';
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate!.difference(now).inDays;
    
    if (daysUntilExpiry < 0) {
      return 'Истек ${expiryDate!.year}';
    } else if (daysUntilExpiry < 30) {
      return 'Истекает через $daysUntilExpiry дн.';
    } else if (daysUntilExpiry < 365) {
      return 'Истекает ${expiryDate!.year}';
    } else {
      return 'Действует до ${expiryDate!.year}';
    }
  }

  DocumentStatus get calculatedStatus {
    if (expiryDate == null) return DocumentStatus.active;
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate!.difference(now).inDays;
    
    if (daysUntilExpiry < 0) return DocumentStatus.expired;
    if (daysUntilExpiry < 30) return DocumentStatus.expiring;
    return DocumentStatus.active;
  }

  String get subtitle {
    if (number != null && number!.isNotEmpty) {
      return number!;
    }
    if (organization != null && organization!.isNotEmpty) {
      return organization!;
    }
    return type.displayName;
  }
}

class DriverLicense extends Document {
  final List<String> categories;
  final String? frontPhotoPath;
  final String? backPhotoPath;

  DriverLicense({
    required super.id,
    required super.title,
    super.number,
    super.issueDate,
    super.expiryDate,
    super.status,
    required this.categories,
    this.frontPhotoPath,
    this.backPhotoPath,
    super.createdAt,
    super.updatedAt,
  }) : super(
    type: DocumentType.driverLicense,
    additionalData: {
      'categories': categories,
      'frontPhotoPath': frontPhotoPath,
      'backPhotoPath': backPhotoPath,
    },
  );

  factory DriverLicense.fromDocument(Document doc) {
    final data = doc.additionalData ?? {};
    return DriverLicense(
      id: doc.id,
      title: doc.title,
      number: doc.number,
      issueDate: doc.issueDate,
      expiryDate: doc.expiryDate,
      status: doc.status,
      categories: (data['categories'] as List<dynamic>?)?.cast<String>() ?? [],
      frontPhotoPath: data['frontPhotoPath'] as String?,
      backPhotoPath: data['backPhotoPath'] as String?,
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
    );
  }

  String get categoriesDisplay => categories.join(', ');
}

class InsurancePolicy extends Document {
  final String? company;
  final double? amount;

  InsurancePolicy({
    required super.id,
    required super.title,
    super.number,
    super.issueDate,
    super.expiryDate,
    super.status,
    this.company,
    this.amount,
    super.createdAt,
    super.updatedAt,
  }) : super(
    type: DocumentType.osago,
    organization: company,
    additionalData: amount != null ? {'amount': amount} : null,
  );

  factory InsurancePolicy.fromDocument(Document doc) {
    final data = doc.additionalData ?? {};
    return InsurancePolicy(
      id: doc.id,
      title: doc.title,
      number: doc.number,
      issueDate: doc.issueDate,
      expiryDate: doc.expiryDate,
      status: doc.status,
      company: doc.organization,
      amount: data['amount'] as double?,
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
    );
  }
}
