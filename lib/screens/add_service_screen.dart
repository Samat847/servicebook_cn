import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import '../services/notification_service.dart';

class AddServiceScreen extends StatefulWidget {
  final Car car;
  final Expense? existingExpense;
  final ExpenseCategory? initialCategory;
  final String? initialWorkType;

  const AddServiceScreen({
    super.key, 
    required this.car,
    this.existingExpense,
    this.initialCategory,
    this.initialWorkType,
  });

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final List<String> _selectedWorkTypes = [];
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _hasReceiptPhoto = false;
  String? _receiptPhotoPath;
  bool _isConfirmed = false;
  bool _isPartner = false;
  bool _isLoading = false;
  String? _errorMessage;

  ExpenseCategory _selectedCategory = ExpenseCategory.maintenance;

  final List<Map<String, dynamic>> _workTypes = [
    {'title': 'ТО', 'icon': Icons.build},
    {'title': 'Двигатель', 'icon': Icons.engineering},
    {'title': 'Подвеска', 'icon': Icons.car_repair},
    {'title': 'Кузов', 'icon': Icons.car_crash},
    {'title': 'Масло', 'icon': Icons.oil_barrel},
    {'title': 'Резина', 'icon': Icons.tire_repair},
    {'title': 'Другое...', 'icon': Icons.more_horiz},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Обслуживание', 'value': ExpenseCategory.maintenance, 'icon': Icons.build, 'color': Colors.blue},
    {'name': 'Ремонт', 'value': ExpenseCategory.repair, 'icon': Icons.car_repair, 'color': Colors.red},
    {'name': 'Топливо', 'value': ExpenseCategory.fuel, 'icon': Icons.local_gas_station, 'color': Colors.orange},
    {'name': 'Мойка', 'value': ExpenseCategory.wash, 'icon': Icons.local_car_wash, 'color': Colors.green},
    {'name': 'Шины', 'value': ExpenseCategory.tires, 'icon': Icons.tire_repair, 'color': Colors.brown},
    {'name': 'Запчасти', 'value': ExpenseCategory.parts, 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'name': 'Страховка', 'value': ExpenseCategory.insurance, 'icon': Icons.security, 'color': Colors.indigo},
    {'name': 'Диагностика', 'value': ExpenseCategory.diagnostics, 'icon': Icons.search, 'color': Colors.teal},
    {'name': 'Другое', 'value': ExpenseCategory.other, 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final expense = widget.existingExpense;
    if (expense != null) {
      _selectedDate = expense.date;
      _mileageController.text = expense.mileage.toString();
      _costController.text = expense.amount.toStringAsFixed(0);
      _placeController.text = expense.place ?? '';
      _commentController.text = expense.comment ?? '';
      _hasReceiptPhoto = expense.hasReceipt;
      _receiptPhotoPath = expense.receiptPhotoPath;
      _isConfirmed = expense.isConfirmed;
      _isPartner = expense.isPartner;
      _selectedCategory = expense.category;
      _selectedWorkTypes.addAll(expense.workTypes);
    } else {
      if (widget.car.mileage != null) {
        _mileageController.text = widget.car.mileage.toString();
      }
      if (widget.initialCategory != null) {
        _selectedCategory = widget.initialCategory!;
      }
      if (widget.initialWorkType != null) {
        _selectedWorkTypes.add(widget.initialWorkType!);
      }
    }
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _costController.dispose();
    _placeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickReceiptPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        _receiptPhotoPath = image.path;
        _hasReceiptPhoto = true;
      });
    }
  }

  void _toggleWorkType(String type) {
    setState(() {
      if (_selectedWorkTypes.contains(type)) {
        _selectedWorkTypes.remove(type);
      } else {
        _selectedWorkTypes.add(type);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (_selectedWorkTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите тип работы')),
      );
      return;
    }

    if (_mileageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите пробег')),
      );
      return;
    }

    if (_costController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите стоимость')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final expense = Expense(
        id: widget.existingExpense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        carId: widget.car.id,
        title: _selectedWorkTypes.join(', '),
        date: _selectedDate,
        mileage: int.parse(_mileageController.text.replaceAll(RegExp(r'\D'), '')),
        amount: double.parse(_costController.text.replaceAll(RegExp(r'\D'), '')),
        category: _selectedCategory,
        place: _placeController.text.isNotEmpty ? _placeController.text : null,
        workTypes: List.from(_selectedWorkTypes),
        comment: _commentController.text.isNotEmpty ? _commentController.text : null,
        hasReceipt: _hasReceiptPhoto,
        receiptPhotoPath: _receiptPhotoPath,
        isConfirmed: _isConfirmed,
        isPartner: _isPartner,
        createdAt: widget.existingExpense?.createdAt ?? DateTime.now(),
      );

      await CarStorage.saveExpense(expense);

      // Update car mileage if current expense mileage is higher
      if (widget.car.mileage == null || expense.mileage > widget.car.mileage!) {
        await CarStorage.saveCar(widget.car.copyWith(mileage: expense.mileage));
      }

      // Schedule notification if it's a maintenance/service record
      if (expense.isServiceRecord) {
        final nextServiceDate = DateTime(expense.date.year, expense.date.month + 6, expense.date.day);
        await NotificationService.scheduleServiceNotification(
          id: expense.id.hashCode,
          carName: widget.car.displayName,
          nextServiceDate: nextServiceDate,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingExpense != null ? 'Запись обновлена' : 'Запись сохранена'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка сохранения: $e';
        _isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          widget.existingExpense != null ? 'Редактировать запись' : 'Новая запись',
          style: const TextStyle(
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
                  // Информация об автомобиле
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.directions_car,
                            color: Color(0xFF1E88E5),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.car.displayName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.car.plate ?? 'Без номера',
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
                  ),

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

                  // Заголовок
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Добавить обслуживание',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Заполните основные данные по работе и расходам, чтобы мы учли их в аналитике.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Категория
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Категория',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category['value'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category['value'] as ExpenseCategory;
                              });
                            },
                            child: Container(
                              width: 80,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? (category['color'] as Color).withOpacity(0.2) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? category['color'] as Color : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category['icon'] as IconData,
                                    color: category['color'] as Color,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    category['name'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      color: isSelected ? category['color'] as Color : Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Тип работы
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Тип работы',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'можно выбрать несколько',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _workTypes.map((type) {
                        final isSelected = _selectedWorkTypes.contains(type['title']);
                        return FilterChip(
                          label: Text(type['title']),
                          avatar: Icon(
                            type['icon'],
                            size: 16,
                            color: isSelected ? Colors.white : Colors.grey.shade600,
                          ),
                          selected: isSelected,
                          onSelected: (_) => _toggleWorkType(type['title']),
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: const Color(0xFF1E88E5),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Дата выполнения
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Дата выполнения',
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
                      onTap: () => _selectDate(context),
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
                              '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Пробег
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Пробег',
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
                      controller: _mileageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '15 420',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        suffixText: 'км',
                        suffixStyle: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Стоимость
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Стоимость',
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
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixText: '₽ ',
                        prefixStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Место
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Место',
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
                      controller: _placeController,
                      decoration: InputDecoration(
                        hintText: 'Название СТО, АЗС или магазина',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Фото чека
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Фото чека',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'до 5 фото',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _receiptPhotoPath != null ? Icons.check : Icons.add_a_photo,
                              color: _receiptPhotoPath != null ? Colors.green : Colors.grey,
                            ),
                            onPressed: _pickReceiptPhoto,
                          ),
                        ),
                        if (_receiptPhotoPath != null) ...[
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _pickReceiptPhoto,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(_receiptPhotoPath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Комментарий
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Комментарий',
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
                      controller: _commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Например: «ТО-1 у дилера, замена масла и фильтров, диагностика подвески»',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Подтверждение работ
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Подтверждение работ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isConfirmed,
                          onChanged: (value) {
                            setState(() {
                              _isConfirmed = value ?? false;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        const Expanded(
                          child: Text(
                            'Есть фото чека по ключевым узлам (двигатель, коробка, регламент ТО)',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 56, right: 16, bottom: 8),
                    child: Text(
                      _isConfirmed
                          ? 'Подтверждено'
                          : 'Не подтверждено. Без фото по ключевым узлам отметим запись как «не подтверждено».',
                      style: TextStyle(
                        fontSize: 13,
                        color: _isConfirmed ? Colors.green.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Партнёрская покупка
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isPartner,
                            onChanged: (value) {
                              setState(() {
                                _isPartner = value ?? false;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Покупка у партнёра',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Отметьте, если покупка совершена у партнёра приложения — мы учтём скидку в статистике экономии.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Кнопка "Сохранить запись"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveExpense,
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
                                widget.existingExpense != null ? 'Обновить запись' : 'Сохранить запись',
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Отменить и вернуться назад',
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

  String _getMonthName(int month) {
    const months = [
      'Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня',
      'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'
    ];
    return months[month - 1];
  }
}
