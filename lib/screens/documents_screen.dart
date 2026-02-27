import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import 'driver_license_screen.dart';
import 'insurance_screen.dart';
import 'sts_detail_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _selectedFilter = 'all';
  bool _isLoading = true;
  String? _errorMessage;
  List<Document> _documents = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final documents = await CarStorage.loadDocumentsList();
      setState(() {
        _documents = documents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка загрузки данных: $e';
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  Future<void> _deleteDocument(String id) async {
    try {
      await CarStorage.deleteDocument(id);
      await _refreshData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Документ удален'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка удаления: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Document> get _filteredDocuments {
    if (_selectedFilter == 'all') return _documents;
    if (_selectedFilter == 'expiring') {
      return _documents.where((doc) => doc.calculatedStatus == DocumentStatus.expiring).toList();
    }
    if (_selectedFilter == 'expired') {
      return _documents.where((doc) => doc.calculatedStatus == DocumentStatus.expired).toList();
    }
    return _documents.where((doc) => doc.type.code == _selectedFilter).toList();
  }

  void _navigateToDocumentDetail(Document document) {
    switch (document.type) {
      case DocumentType.driverLicense:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverLicenseScreen(existingDocument: document),
          ),
        ).then((result) {
          if (result == true) _refreshData();
        });
        break;
      case DocumentType.osago:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InsuranceScreen(existingDocument: document),
          ),
        ).then((result) {
          if (result == true) _refreshData();
        });
        break;
      case DocumentType.sts:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => STSDetailScreen(existingDocument: document),
          ),
        ).then((result) {
          if (result == true) _refreshData();
        });
        break;
      default:
        _showDocumentDetail(document);
    }
  }

  void _showDocumentDetail(Document document) {
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
                            color: Color(document.type.colorValue).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getDocumentIcon(document.type),
                            color: Color(document.type.colorValue),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                document.subtitle,
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
                    _buildDetailRow('Статус', document.calculatedStatus.displayName),
                    _buildDetailRow('Срок действия', document.expiryDisplay),
                    if (document.issueDate != null)
                      _buildDetailRow('Дата выдачи', DateFormat('dd.MM.yyyy').format(document.issueDate!)),
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
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Удалить', style: TextStyle(color: Colors.red)),
                      onTap: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(document);
                      },
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

  void _showDeleteConfirmation(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить документ?'),
        content: Text('Вы уверены, что хотите удалить "${document.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDocument(document.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Удалить'),
          ),
        ],
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

  IconData _getDocumentIcon(DocumentType type) {
    final iconMap = {
      'description': Icons.description,
      'article': Icons.article,
      'assignment_ind': Icons.assignment_ind,
      'car_crash': Icons.car_crash,
      'verified': Icons.verified,
      'shield': Icons.shield,
    };
    return iconMap[type.iconName] ?? Icons.description;
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_errorMessage!, style: TextStyle(color: Colors.red[700])),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Column(
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
                              _buildFilterChip('СТС', DocumentType.sts.code),
                              const SizedBox(width: 8),
                              _buildFilterChip('Права', DocumentType.driverLicense.code),
                              const SizedBox(width: 8),
                              _buildFilterChip('ОСАГО', DocumentType.osago.code),
                              const SizedBox(width: 8),
                              _buildFilterChip('ПТС', DocumentType.pts.code),
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
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: _showAddDocumentDialog,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Добавить документ'),
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

  Widget _buildDocumentCard(Document document) {
    final isExpiring = document.calculatedStatus == DocumentStatus.expiring;
    final isExpired = document.calculatedStatus == DocumentStatus.expired;

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
            color: Color(document.type.colorValue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getDocumentIcon(document.type),
            color: Color(document.type.colorValue),
            size: 26,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                document.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isExpiring || isExpired) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isExpired ? Colors.red.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isExpired ? 'Истек' : 'Истекает',
                  style: TextStyle(
                    fontSize: 10,
                    color: isExpired ? Colors.red.shade700 : Colors.orange.shade700,
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
              document.subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              document.expiryDisplay,
              style: TextStyle(
                fontSize: 12,
                color: isExpiring || isExpired ? Colors.red.shade600 : Colors.grey.shade500,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const STSDetailScreen(),
                  ),
                ).then((result) {
                  if (result == true) _refreshData();
                });
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
                ).then((result) {
                  if (result == true) _refreshData();
                });
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
                ).then((result) {
                  if (result == true) _refreshData();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Colors.purple),
              title: const Text('ПТС'),
              onTap: () {
                Navigator.pop(context);
                _showNotImplementedSnackBar();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotImplementedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция в разработке')),
    );
  }
}
