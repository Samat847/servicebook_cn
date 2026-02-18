import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class STSDetailScreen extends StatefulWidget {
  const STSDetailScreen({super.key});

  @override
  State<STSDetailScreen> createState() => _STSDetailScreenState();
}

class _STSDetailScreenState extends State<STSDetailScreen> {
  final TextEditingController _seriesController = TextEditingController(text: '99 АА');
  final TextEditingController _numberController = TextEditingController(text: '123456');
  final TextEditingController _vinController = TextEditingController(text: 'LVSHCAMB1CE012345');
  final TextEditingController _ownerController = TextEditingController(text: 'Иванов Иван Иванович');
  final TextEditingController _makeController = TextEditingController(text: 'Toyota');
  final TextEditingController _modelController = TextEditingController(text: 'Camry');
  DateTime _issueDate = DateTime(2022, 3, 15);
  String? _frontPhotoPath;
  String? _backPhotoPath;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void dispose() {
    _seriesController.dispose();
    _numberController.dispose();
    _vinController.dispose();
    _ownerController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _issueDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _issueDate = picked;
      });
    }
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

  Future<void> _saveSTS() async {
    if (_seriesController.text.isEmpty || _numberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите серию и номер СТС')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('СТС сохранено')),
      );
    }
  }

  void _downloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Скачиваем PDF...')),
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
          'СТС',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Document preview
                  if (!_isEditing) ...[
                    _buildDocumentPreview(),
                    const SizedBox(height: 16),
                  ],

                  // Photo upload
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Фото документа',
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
                            onTap: _isEditing ? () => _pickPhoto(true) : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildPhotoCard(
                            label: 'Обратная сторона',
                            photoPath: _backPhotoPath,
                            onTap: _isEditing ? () => _pickPhoto(false) : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form fields
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Данные документа',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _seriesController,
                          label: 'Серия',
                          hint: '99 АА',
                          icon: Icons.badge,
                          readOnly: !_isEditing,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _numberController,
                          label: 'Номер',
                          hint: '123456',
                          icon: Icons.numbers,
                          readOnly: !_isEditing,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _vinController,
                          label: 'VIN',
                          hint: 'LVSHCAMB1CE012345',
                          icon: Icons.qr_code,
                          readOnly: !_isEditing,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _ownerController,
                          label: 'Собственник',
                          hint: 'ФИО полностью',
                          icon: Icons.person,
                          readOnly: !_isEditing,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Данные автомобиля',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _makeController,
                          label: 'Марка',
                          hint: 'Toyota',
                          icon: Icons.directions_car,
                          readOnly: !_isEditing,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _modelController,
                          label: 'Модель',
                          hint: 'Camry',
                          icon: Icons.directions_car_filled,
                          readOnly: !_isEditing,
                        ),
                        const SizedBox(height: 16),

                        // Issue date
                        const Text(
                          'Дата выдачи',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _isEditing ? () => _selectDate(context) : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: _isEditing ? Colors.white : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd MMMM yyyy', 'ru').format(_issueDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _isEditing ? Colors.black : Colors.grey.shade700,
                                  ),
                                ),
                                if (_isEditing)
                                  const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info note
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'СТС действительно бессрочно, пока не изменятся данные о собственнике или автомобиле.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!_isEditing) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _downloadPdf,
                              icon: const Icon(Icons.download),
                              label: const Text('Скачать PDF'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1E88E5),
                                side: const BorderSide(color: Color(0xFF1E88E5)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Редактировать'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E88E5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Buttons
                  if (_isEditing) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveSTS,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Сохранить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: const Text(
                          'Отменить',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildDocumentPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ДЕЙСТВУЕТ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.verified,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'СТС',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_seriesController.text} ${_numberController.text}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'VIN: ${_vinController.text}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Авто: ${_makeController.text} ${_modelController.text}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Выдан: ${DateFormat('dd.MM.yyyy').format(_issueDate)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard({
    required String label,
    String? photoPath,
    required VoidCallback? onTap,
  }) {
    final bool canInteract = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: photoPath != null
                ? const Color(0xFF1E88E5)
                : canInteract
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
            width: photoPath != null ? 2 : 1,
          ),
        ),
        child: photoPath != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
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
                  Icon(
                    canInteract ? Icons.add_a_photo : Icons.photo,
                    color: canInteract ? Colors.grey.shade400 : Colors.grey.shade300,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: canInteract ? Colors.grey.shade600 : Colors.grey.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool readOnly,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E88E5)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade100 : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
