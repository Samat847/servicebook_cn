import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import 'driver_license_screen.dart';
import 'insurance_screen.dart';
import 'documents_screen.dart';

class AllDocumentsScreen extends StatefulWidget {
  const AllDocumentsScreen({super.key});

  @override
  State<AllDocumentsScreen> createState() => _AllDocumentsScreenState();
}

class _AllDocumentsScreenState extends State<AllDocumentsScreen> {
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _documents = [
    {
      'id': '1',
      'type': 'driver_license',
      'title': 'Водительское удостоверение',
      'subtitle': 'Серия 12 34 №567890',
      'icon': Icons.assignment_ind,
      'color': Colors.green,
      'status': 'active',
      'expiry': DateTime(2028, 5, 15),
      'uploadDate': DateTime(2024, 1, 10),
    },
    {
      'id': '2',
      'type': 'osago',
      'title': 'ОСАГО',
      'subtitle': 'Росгосстрах • Полис XXX 1234567890',
      'icon': Icons.car_crash,
      'color': Colors.orange,
      'status': 'expiring',
      'expiry': DateTime(2025, 6, 20),
      'uploadDate': DateTime(2024, 6, 20),
    },
    {
      'id': '3',
      'type': 'sts',
      'title': 'СТС',
      'subtitle': 'Серия 99 АА №123456',
      'icon': Icons.description,
      'color': Colors.blue,
      'status': 'active',
      'expiry': null,
      'uploadDate': DateTime(2024, 2, 15),
    },
    {
      'id': '4',
      'type': 'pts',
      'title': 'ПТС',
      'subtitle': 'Электронный • 78 УН 123456',
      'icon': Icons.article,
      'color': Colors.purple,
      'status': 'active',
      'expiry': null,
      'uploadDate': DateTime(2024, 2, 15),
    },
    {
      'id': '5',
      'type': 'diagnostic_card',
      'title': 'Диагностическая карта',
      'subtitle': 'ТО № 1234567890123',
      'icon': Icons.verified,
      'color': Colors.teal,
      'status': 'expiring',
      'expiry': DateTime(2025, 3, 10),
      'uploadDate': DateTime(2024, 3, 10),
    },
    {
      'id': '6',
      'type': 'kasko',
      'title': 'КАСКО',
      'subtitle': 'Ингосстрах • Полис KSK 987654321',
      'icon': Icons.shield,
      'color': Colors.indigo,
      'status': 'active',
      'expiry': DateTime(2025, 8, 15),
      'uploadDate': DateTime(2024, 8, 15),
    },
  ];

  List<Map<String, dynamic>> get _filteredDocuments {
    if (_selectedFilter == 'all') return _documents;
    if (_selectedFilter == 'expiring') {
      return _documents.where((doc) => doc['status'] == 'expiring').toList();
    }
    return _documents.where((doc) => doc['type'] == _selectedFilter).toList();
  }

  void _navigateToDocumentDetail(Map<String, dynamic> document) {
    switch (document['type']) {
      case 'driver_license':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DriverLicenseScreen(),
          ),
        );
        break;
      case 'osago':
      case 'kasko':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InsuranceScreen(),
          ),
        );
        break;
      case 'sts':
      case 'pts':
      case 'diagnostic_card':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocumentsScreen(),
          ),
        );
        break;
      default:
        _showDocumentDetail(document);
    }
  }

  void _showDocumentDetail(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: (document['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            document['icon'] as IconData,
                            color: document['color'] as Color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document['title'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                document['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      'Статус',
                      _getStatusText(document['status'] as String),
                    ),
                    if (document['expiry'] != null)
                      _buildDetailRow(
                        'Срок действия',
                        _formatDate(document['expiry'] as DateTime),
                      ),
                    _buildDetailRow(
                      'Загружен',
                      _formatDate(document['uploadDate'] as DateTime),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Действия',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.visibility, color: Colors.blue),
                      title: const Text('Просмотреть'),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.orange),
                      title: const Text('Редактировать'),
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToDocumentDetail(document);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share, color: Colors.green),
                      title: const Text('Поделиться'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Действует';
      case 'expiring':
        return 'Истекает';
      case 'expired':
        return 'Просрочен';
      default:
        return 'Неизвестно';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Все документы',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Все', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Истекают', 'expiring'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Права', 'driver_license'),
                  const SizedBox(width: 8),
                  _buildFilterChip('ОСАГО', 'osago'),
                  const SizedBox(width: 8),
                  _buildFilterChip('СТС', 'sts'),
                  const SizedBox(width: 8),
                  _buildFilterChip('ПТС', 'pts'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Documents list
          Expanded(
            child: _filteredDocuments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Документы не найдены',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final document = _filteredDocuments[index];
                      return _buildDocumentCard(document);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDocumentDialog,
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
        backgroundColor: const Color(0xFF1E88E5),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFF1E88E5),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    final isExpiring = document['status'] == 'expiring';
    final isExpired = document['status'] == 'expired';
    final expiryDate = document['expiry'] as DateTime?;

    String expiryText;
    if (expiryDate != null) {
      final daysLeft = expiryDate.difference(DateTime.now()).inDays;
      if (isExpired) {
        expiryText = 'Просрочен с ${_formatDate(expiryDate)}';
      } else if (isExpiring && daysLeft < 30) {
        expiryText = 'Истекает через $daysLeft дней';
      } else {
        expiryText = 'Действует до ${_formatDate(expiryDate)}';
      }
    } else {
      expiryText = 'Бессрочно';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDocumentDetail(document),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (document['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  document['icon'] as IconData,
                  color: document['color'] as Color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            document['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isExpiring || isExpired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isExpired
                                  ? Colors.red.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isExpired ? 'Просрочен' : 'Истекает',
                              style: TextStyle(
                                fontSize: 10,
                                color: isExpired
                                    ? Colors.red.shade700
                                    : Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: isExpired
                              ? Colors.red.shade600
                              : isExpiring
                                  ? Colors.orange.shade600
                                  : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          expiryText,
                          style: TextStyle(
                            fontSize: 12,
                            color: isExpired
                                ? Colors.red.shade600
                                : isExpiring
                                    ? Colors.orange.shade600
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDocumentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить документ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.description, color: Colors.blue),
              title: const Text('СТС'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DocumentsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_ind, color: Colors.green),
              title: const Text('Водительское удостоверение'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DriverLicenseScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.car_crash, color: Colors.orange),
              title: const Text('ОСАГО'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InsuranceScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Colors.purple),
              title: const Text('ПТС'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DocumentsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
