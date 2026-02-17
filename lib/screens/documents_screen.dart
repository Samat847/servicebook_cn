import 'package:flutter/material.dart';
import 'driver_license_screen.dart';
import 'insurance_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _documents = [
    {
      'id': '1',
      'type': 'sts',
      'title': 'СТС',
      'subtitle': 'Серия 99 АА №123456',
      'icon': Icons.description,
      'color': Colors.blue,
      'status': 'active',
      'expiry': 'Бессрочно',
    },
    {
      'id': '2',
      'type': 'driver_license',
      'title': 'Водительское удостоверение',
      'subtitle': '12 34 567890',
      'icon': Icons.assignment_ind,
      'color': Colors.green,
      'status': 'active',
      'expiry': '2028',
    },
    {
      'id': '3',
      'type': 'osago',
      'title': 'ОСАГО',
      'subtitle': 'Росгосстрах',
      'icon': Icons.car_crash,
      'color': Colors.orange,
      'status': 'expiring',
      'expiry': '2025',
    },
    {
      'id': '4',
      'type': 'pts',
      'title': 'ПТС',
      'subtitle': 'Электронный',
      'icon': Icons.article,
      'color': Colors.purple,
      'status': 'active',
      'expiry': 'Бессрочно',
    },
    {
      'id': '5',
      'type': 'diagnostic_card',
      'title': 'Диагностическая карта',
      'subtitle': 'Действует',
      'icon': Icons.verified,
      'color': Colors.teal,
      'status': 'expiring',
      'expiry': '2025',
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
          MaterialPageRoute(builder: (context) => const DriverLicenseScreen()),
        );
        break;
      case 'osago':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InsuranceScreen()),
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
                            document['icon'],
                            color: document['color'],
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document['title'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                document['subtitle'],
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
                    _buildDetailRow('Статус', document['status'] == 'expiring' ? 'Истекает' : 'Действует'),
                    _buildDetailRow('Срок действия', document['expiry']),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Документы',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDocumentDialog,
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        children: [
          // Фильтры
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
                  _buildFilterChip('СТС', 'sts'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Права', 'driver_license'),
                  const SizedBox(width: 8),
                  _buildFilterChip('ОСАГО', 'osago'),
                  const SizedBox(width: 8),
                  _buildFilterChip('ПТС', 'pts'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Список документов
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (document['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            document['icon'],
            color: document['color'],
            size: 26,
          ),
        ),
        title: Row(
          children: [
            Text(
              document['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isExpiring) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Истекает',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              document['subtitle'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Действует до: ${document['expiry']}',
              style: TextStyle(
                fontSize: 12,
                color: isExpiring ? Colors.red.shade600 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: () => _navigateToDocumentDetail(document),
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_ind, color: Colors.green),
              title: const Text('Водительское удостоверение'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DriverLicenseScreen()),
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
                  MaterialPageRoute(builder: (context) => const InsuranceScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Colors.purple),
              title: const Text('ПТС'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
