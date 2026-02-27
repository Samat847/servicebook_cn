import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import 'add_service_screen.dart';

class AllRecordsScreen extends StatefulWidget {
  final Car? car;

  const AllRecordsScreen({super.key, this.car});

  @override
  State<AllRecordsScreen> createState() => _AllRecordsScreenState();
}

class _AllRecordsScreenState extends State<AllRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  String _selectedSort = 'date_desc';
  bool _showFilters = false;
  bool _isLoading = true;
  String? _errorMessage;

  List<Expense> _expenses = [];
  List<Car> _cars = [];

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
      final cars = await CarStorage.loadCarsList();
      List<Expense> expenses;
      
      if (widget.car != null) {
        expenses = await CarStorage.loadExpensesList(carId: widget.car!.id);
      } else {
        expenses = await CarStorage.loadExpensesList();
      }

      setState(() {
        _cars = cars;
        _expenses = expenses;
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

  Future<void> _deleteExpense(String id) async {
    try {
      await CarStorage.deleteExpense(id);
      await _refreshData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Запись удалена'),
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

  List<Expense> get _filteredExpenses {
    var filtered = List<Expense>.from(_expenses);

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered = filtered.where((expense) => expense.category.code == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((expense) {
        return expense.title.toLowerCase().contains(query) ||
            (expense.place?.toLowerCase().contains(query) ?? false) ||
            expense.category.displayName.toLowerCase().contains(query);
      }).toList();
    }

    // Sort
    if (_selectedSort == 'date_desc') {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    } else if (_selectedSort == 'date_asc') {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    } else if (_selectedSort == 'price_desc') {
      filtered.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (_selectedSort == 'price_asc') {
      filtered.sort((a, b) => a.amount.compareTo(b.amount));
    } else if (_selectedSort == 'mileage_desc') {
      filtered.sort((a, b) => b.mileage.compareTo(a.mileage));
    }

    return filtered;
  }

  double get _totalExpenses => _filteredExpenses.fold<double>(0, (sum, expense) => sum + expense.amount);

  Car? _getCarById(String carId) {
    try {
      return _cars.firstWhere((c) => c.id == carId);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Все записи',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            color: _showFilters ? Colors.blue : Colors.black,
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
                      // Фильтры и поиск
                      if (_showFilters) _buildFiltersSection(),
                      const SizedBox(height: 8),

                      // Статистика
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
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
                            Expanded(
                              child: _buildStatItem(
                                'Записей',
                                '${_filteredExpenses.length}',
                                Icons.description,
                                Colors.blue,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Всего расходов',
                                '${_formatPrice(_totalExpenses.toInt())}',
                                Icons.account_balance_wallet,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Список записей
                      Expanded(
                        child: _filteredExpenses.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inbox,
                                      size: 64,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Записи не найдены',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (_expenses.isEmpty && _cars.isNotEmpty)
                                      TextButton(
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddServiceScreen(car: _cars.first),
                                            ),
                                          );
                                          if (result == true) {
                                            await _refreshData();
                                          }
                                        },
                                        child: const Text('Добавить первую запись'),
                                      ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _filteredExpenses.length,
                                itemBuilder: (context, index) {
                                  return _buildRecordCard(_filteredExpenses[index]);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: _cars.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddServiceScreen(car: widget.car ?? _cars.first),
                  ),
                );
                if (result == true) {
                  await _refreshData();
                }
              },
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Поиск
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск по названию или месту',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 12),

          // Фильтр по категории
          const Text(
            'Категория',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('Все', 'all'),
              _buildCategoryChip('ТО', ExpenseCategory.maintenance.code),
              _buildCategoryChip('Ремонт', ExpenseCategory.repair.code),
              _buildCategoryChip('Запчасти', ExpenseCategory.parts.code),
              _buildCategoryChip('Топливо', ExpenseCategory.fuel.code),
              _buildCategoryChip('Мойка', ExpenseCategory.wash.code),
              _buildCategoryChip('Страховка', ExpenseCategory.insurance.code),
              _buildCategoryChip('Диагностика', ExpenseCategory.diagnostics.code),
            ],
          ),
          const SizedBox(height: 12),

          // Сортировка
          const Text(
            'Сортировка',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedSort,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: const [
              DropdownMenuItem(value: 'date_desc', child: Text('Сначала новые')),
              DropdownMenuItem(value: 'date_asc', child: Text('Сначала старые')),
              DropdownMenuItem(value: 'price_desc', child: Text('По цене: дорогие')),
              DropdownMenuItem(value: 'price_asc', child: Text('По цене: дешевые')),
              DropdownMenuItem(value: 'mileage_desc', child: Text('По пробегу')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSort = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = _selectedCategory == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedCategory = value;
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

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCard(Expense expense) {
    final formattedDate = '${expense.date.day} ${_getMonthName(expense.date.month)} ${expense.date.year}';
    final car = _getCarById(expense.carId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showRecordDetail(expense),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(expense.category.colorValue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(expense.category),
                  color: Color(expense.category.colorValue),
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.speed,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${expense.formattedMileage} км',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    if (car != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            car.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (expense.place != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              expense.place!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expense.formattedAmount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  if (expense.isConfirmed)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '✓',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    final iconMap = {
      'local_gas_station': Icons.local_gas_station,
      'build': Icons.build,
      'local_car_wash': Icons.local_car_wash,
      'car_repair': Icons.car_repair,
      'security': Icons.security,
      'shopping_bag': Icons.shopping_bag,
      'search': Icons.search,
      'tire_repair': Icons.tire_repair,
      'more_horiz': Icons.more_horiz,
    };
    return iconMap[category.iconName] ?? Icons.receipt;
  }

  void _showRecordDetail(Expense expense) {
    final car = _getCarById(expense.carId);

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
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(expense.category.colorValue).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(expense.category),
                            color: Color(expense.category.colorValue),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                expense.formattedAmount,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1E88E5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow('Дата', '${expense.date.day}.${expense.date.month}.${expense.date.year}'),
                    _buildDetailRow('Пробег', '${expense.formattedMileage} км'),
                    _buildDetailRow('Категория', expense.category.displayName),
                    if (expense.place != null) _buildDetailRow('Место', expense.place!),
                    if (car != null) _buildDetailRow('Автомобиль', car.displayName),
                    if (expense.comment != null && expense.comment!.isNotEmpty)
                      _buildDetailRow('Комментарий', expense.comment!),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.pop(context);
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddServiceScreen(
                                    car: car ?? _cars.first,
                                    existingExpense: expense,
                                  ),
                                ),
                              );
                              if (result == true) {
                                await _refreshData();
                              }
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Редактировать'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteConfirmation(expense);
                            },
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('Удалить'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _showDeleteConfirmation(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить запись?'),
        content: Text('Вы уверены, что хотите удалить запись "${expense.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteExpense(expense.id);
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

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Янв', 'Фев', 'Мар', 'Апр', 'Мая', 'Июн',
      'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'
    ];
    return months[month - 1];
  }
}
