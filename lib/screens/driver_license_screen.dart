import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/car_storage.dart';

class DriverLicenseScreen extends StatefulWidget {
  final Document? existingDocument;

  const DriverLicenseScreen({super.key, this.existingDocument});

  @override
  State<DriverLicenseScreen> createState() => _DriverLicenseScreenState();
}

class _DriverLicenseScreenState extends State<DriverLicenseScreen> {
  final TextEditingController _licenseNumberController = TextEditingController();
  DateTime _issueDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365 * 10));
  List<String> _selectedCategories = ['B'];
  String? _frontPhotoPath;
  String? _backPhotoPath;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _availableCategories = ['A', 'B', 'C', 'D', 'BE', 'CE', 'DE', 'M'];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    if (widget.existingDocument != null) {
      final doc = widget.existingDocument!;
      _licenseNumberController.text = doc.number ?? '';
      if (doc.issueDate != null) _issueDate = doc.issueDate!;
      if (doc.expiryDate != null) _expiryDate = doc.expiryDate!;
      
      // Load additional data
      final additionalData = doc.additionalData ?? {};
      _selectedCategories = (additionalData['categories'] as List<dynamic>?)?.cast<String>() ?? ['B'];
      _frontPhotoPath = additionalData['frontPhotoPath'] as String?;
      _backPhotoPath = additionalData['backPhotoPath'] as String?;
    }
  }

  @override
  void dispose() {
    _licenseNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIssueDate ? _issueDate : _expiryDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
    );
    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          _issueDate = picked;
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  Future<void> _pickPhoto(bool isFront) async {
    setState(() {
      if (isFront) {
        _frontPhotoPath = 'photo_path';
      } else {
        _backPhotoPath = 'photo_path';
      }
    });
  }

  Future<void> _saveLicense() async {
    if (_licenseNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите номер удостоверения')),
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одну категорию')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final document = Document(
        id: widget.existingDocument?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: DocumentType.driverLicense,
        title: 'Водительское удостоверение',
        number: _licenseNumberController.text,
        issueDate: _issueDate,
        expiryDate: _expiryDate,
        status: _calculateStatus(),
        additionalData: {
          'categories': _selectedCategories,
          'frontPhotoPath': _frontPhotoPath,
          'backPhotoPath': _backPhotoPath,
        },
        createdAt: widget.existingDocument?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await CarStorage.saveDocument(document);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingDocument != null ? 'Данные обновлены' : 'Водительское удостоверение сохранено'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка сохранения: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  DocumentStatus _calculateStatus() {
    final now = DateTime.now();
    final daysUntilExpiry = _expiryDate.difference(now).inDays;
    
    if (daysUntilExpiry < 0) return DocumentStatus.expired;
    if (daysUntilExpiry < 30) return DocumentStatus.expiring;
    return DocumentStatus.active;
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
          'Водительское удостоверение',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  if (_errorMessage != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Фото удостоверения
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Фото удостоверения',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildPhotoCard(
                            label: 'Лицевая сторона',
                            photoPath: _frontPhotoPath,
                            onTap: () => _pickPhoto(true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPhotoCard(
                            label: 'Обратная сторона',
                            photoPath: _backPhotoPath,
                            onTap: () => _pickPhoto(false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Номер удостоверения
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Номер удостоверения',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _licenseNumberController,
                      decoration: InputDecoration(
                        hintText: '12 34 567890',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Дата выдачи
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Дата выдачи',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd MMM yyyy', 'ru').format(_issueDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Срок действия
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Срок действия',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd MMM yyyy', 'ru').format(_expiryDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Категории
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Категории',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableCategories.map((category) {
                        final isSelected = _selectedCategories.contains(category);
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) => _toggleCategory(category),
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: const Color(0xFF1E88E5),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Кнопка сохранения
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('save_driver_license_button'),
                        onPressed: _isLoading ? null : _saveLicense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.existingDocument != null ? 'Обновить' : 'Сохранить',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Отмена
                  Center(
                    child: TextButton(
                      key: const Key('cancel_driver_license_button'),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildPhotoCard({
    required String label,
    String? photoPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: photoPath != null ? const Color(0xFF1E88E5) : Colors.grey.shade300,
            width: photoPath != null ? 2 : 1,
          ),
        ),
        child: photoPath != null
            ? Stack(
                children: [
                  const Center(
                    child: Icon(Icons.check_circle, color: Colors.green, size: 48),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: Colors.grey.shade400, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
