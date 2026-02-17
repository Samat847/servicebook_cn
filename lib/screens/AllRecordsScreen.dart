import 'package:flutter/material.dart';

class AllRecordsScreen extends StatefulWidget {
  const AllRecordsScreen({super.key});

  @override
  State<AllRecordsScreen> createState() => _AllRecordsScreenState();
}

class _AllRecordsScreenState extends State<AllRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  String _selectedSort = 'date_desc';
  bool _showFilters = false;

  final List<Map<String, dynamic>> _records = [
    {
      'id': '1',
      'title': 'Плановое ТО-1',
      'date': DateTime(2024, 10, 24),
      'mileage': 15420,
      'price': 18400,
      'category': 'maintenance',
      'place': 'Jetour Service',
      'icon': Icons.build,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Замена тормозной жидкости',
      'date': DateTime(2024, 9, 15),
      'mileage': 12800,
      'price': 3200,
      'category': 'repair',
      'place': 'Гараж #1',
      'icon': Icons.water_drop,
      'color': Colors.orange,
    },
    {
      'id': '3',
      'title': 'Покупка зимней резины',
      'date': DateTime(2024, 9, 2),
      'mileage': 12700,
      'price': 42000,
      'category': 'parts',
      'place': 'Магазин',
      'icon': Icons.shopping_bag,
      'color': Colors.green,
    },
    {
      'id': '4',
      'title': 'Замена масла',
      'date': DateTime(2024, 8, 10),
      'mileage': 11500,
      'price': 8500,
      'category': 'maintenance',
      'place': 'Гараж #1',
      'icon': Icons.oil_barrel,
      'color': Colors.purple,
    },
    {
      'id': '5',
      'title': 'Диагностика подвески',
      'date': DateTime(2024, 7, 20),
      'mileage': 10200,
      'price': 2000,
      'category': 'diagnostics',
      'place': 'СТО Автомир',
      'icon': Icons.search,
      'color': Colors.teal,
    },
    {
      'id': '6',
      'title': 'ОСАГО',
      'date': DateTime(2024, 6, 15),
      'mileage': 9800,
      'price': 8500,
      'category': 'insurance',
      'place': 'Росгосстрах',
      'icon': Icons.security,
      'color': Colors.red,
    },
    {
      'id': '7',
      'title': 'Замена фильтров',
      'date': DateTime(2024, 5, 5),
      'mileage': 8500,
      'price': 4500,
      'category': 'maintenance',
      'place': 'Jetour Service',
      'icon': Icons.filter_alt,
      'color': Colors.indigo,
    },
  ];

  List<Map<String, dynamic>> get _filteredRecords {
    var filtered = List<Map<String, dynamic>>.from(_records);

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered = filtered.where((record) => record['category'] == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((record) {
        return record['title'].toString().toLowerCase().contains(query) ||
            record['place'].toString().toLowerCase().contains(query);
      }).toList();
    }

    // Sort
    if (_selectedSort == 'date_desc') {
      filtered.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    } else if (_selectedSort == 'date_asc') {
      filtered.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    } else if (_selectedSort == 'price_desc') {
      filtered.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
    } else if (_selectedSort == 'price_asc') {
      filtered.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
    } else if (_selectedSort == 'mileage_desc') {
      filtered.sort((a, b) => (b['mileage'] as int).compareTo(a['mileage'] as int));
    }

    return filtered;
  }

  int get _totalExpenses => _filteredRecords.fold<int>(0, (sum, record) => sum + (record['price'] as int));

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
      body: Column(
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
                    '${_filteredRecords.length}',
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
                    '${_formatPrice(_totalExpenses)}',
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
            child: _filteredRecords.isEmpty
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
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredRecords.length,
                    itemBuilder: (context, index) {
                      return _buildRecordCard(_filteredRecords[index]);
                    },
                  ),
          ),
        ],
      ),
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
              _buildCategoryChip('ТО', 'maintenance'),
              _buildCategoryChip('Ремонт', 'repair'),
              _buildCategoryChip('Запчасти', 'parts'),
              _buildCategoryChip('Диагностика', 'diagnostics'),
              _buildCategoryChip('Страховка', 'insurance'),
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

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final date = record['date'] as DateTime;
    final formattedDate = '${date.day} ${_getMonthName(date.month)} ${date.year}';
    final color = record['color'] as Color;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showRecordDetail(record),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  record['icon'],
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['title'],
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
                          '${_formatMileage(record['mileage'])} км',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
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
                            record['place'],
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
                ),
              ),
              Text(
                _formatPrice(record['price']),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecordDetail(Map<String, dynamic> record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
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
                            color: (record['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            record['icon'],
                            color: record['color'],
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatPrice(record['price']),
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
                    _buildDetailRow('Дата', '${(record['date'] as DateTime).day}.${(record['date'] as DateTime).month}.${(record['date'] as DateTime).year}'),
                    _buildDetailRow('Пробег', '${_formatMileage(record['mileage'])} км'),
                    _buildDetailRow('Место', record['place']),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
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
                            onPressed: () => Navigator.pop(context),
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

  String _formatMileage(int mileage) {
    return mileage.toString().replaceAllMapped(
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
