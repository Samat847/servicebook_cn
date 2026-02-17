import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllOperationsScreen extends StatefulWidget {
  const AllOperationsScreen({super.key});

  @override
  State<AllOperationsScreen> createState() => _AllOperationsScreenState();
}

class _AllOperationsScreenState extends State<AllOperationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';

  final List<Map<String, dynamic>> _allOperations = [
    {
      'date': DateTime(2024, 10, 24),
      'description': 'Заправка АИ-95 • Газпромнефть',
      'amount': 2450.0,
      'category': 'Топливо',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 10, 18),
      'description': 'Мойка Люкс Комплекс',
      'amount': 900.0,
      'category': 'Мойка',
      'icon': Icons.local_car_wash,
      'color': Colors.blue,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 10, 15),
      'description': 'Замена масла ТО-1 • Geely Service',
      'amount': 4500.0,
      'category': 'Обслуживание',
      'icon': Icons.build,
      'color': Colors.green,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 10, 10),
      'description': 'Заправка АИ-95 • Лукойл',
      'amount': 2100.0,
      'category': 'Топливо',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 10, 5),
      'description': 'Шиномонтаж • Сезонная замена',
      'amount': 3200.0,
      'category': 'Обслуживание',
      'icon': Icons.tire_repair,
      'color': Colors.green,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 9, 28),
      'description': 'Заправка АИ-95 • Shell',
      'amount': 2800.0,
      'category': 'Топливо',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 9, 20),
      'description': 'Диагностика подвески',
      'amount': 1500.0,
      'category': 'Диагностика',
      'icon': Icons.search,
      'color': Colors.purple,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 9, 15),
      'description': 'Замена тормозных колодок',
      'amount': 6500.0,
      'category': 'Ремонт',
      'icon': Icons.car_repair,
      'color': Colors.red,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 9, 10),
      'description': 'ОСАГО • Росгосстрах',
      'amount': 12500.0,
      'category': 'Страховка',
      'icon': Icons.security,
      'color': Colors.indigo,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 9, 5),
      'description': 'Заправка АИ-95 • Татнефть',
      'amount': 1950.0,
      'category': 'Топливо',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 8, 28),
      'description': 'Полировка кузова',
      'amount': 8500.0,
      'category': 'Мойка',
      'icon': Icons.auto_fix_high,
      'color': Colors.blue,
      'car': 'Geely Monjaro',
    },
    {
      'date': DateTime(2024, 8, 20),
      'description': 'Замена свечей зажигания',
      'amount': 4200.0,
      'category': 'Обслуживание',
      'icon': Icons.electrical_services,
      'color': Colors.green,
      'car': 'Geely Monjaro',
    },
  ];

  List<Map<String, dynamic>> get _filteredOperations {
    var filtered = _allOperations;

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered = filtered
          .where((op) => op['category'] == _selectedCategory)
          .toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((op) {
        return op['description'].toString().toLowerCase().contains(query) ||
            op['category'].toString().toLowerCase().contains(query);
      }).toList();
    }

    // Sort by date (latest first)
    filtered.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    return filtered;
  }

  double get _totalExpenses {
    return _filteredOperations.fold(
      0,
      (sum, op) => sum + (op['amount'] as double),
    );
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
          'Все операции',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по операциям',
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
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Category filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Все', 'all'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Топливо', 'Топливо'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Обслуживание', 'Обслуживание'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Мойка', 'Мойка'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Ремонт', 'Ремонт'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Страховка', 'Страховка'),
                ],
              ),
            ),
          ),

          // Total expenses summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Всего расходов',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '${_filteredOperations.length} операций',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_formatPrice(_totalExpenses.toInt())} ₽',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Operations list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh data
                await Future.delayed(const Duration(seconds: 1));
              },
              child: _filteredOperations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Операции не найдены',
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
                      itemCount: _filteredOperations.length,
                      itemBuilder: (context, index) {
                        return _buildOperationCard(_filteredOperations[index]);
                      },
                    ),
            ),
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
      onSelected: (selected) {
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

  Widget _buildOperationCard(Map<String, dynamic> op) {
    final date = op['date'] as DateTime;
    final day = date.day.toString();
    final month = DateFormat('MMM', 'ru').format(date);
    final year = date.year.toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showOperationDetail(op),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (op['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      month,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      op['description'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          op['icon'] as IconData,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          op['category'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          op['car'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '-${_formatPrice(op['amount'].toInt())} ₽',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    year,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
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

  void _showOperationDetail(Map<String, dynamic> op) {
    final date = op['date'] as DateTime;
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
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: (op['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            op['icon'] as IconData,
                            color: op['color'] as Color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                op['description'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                op['category'],
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
                    _buildDetailRow('Сумма', '-${_formatPrice(op['amount'].toInt())} ₽'),
                    _buildDetailRow(
                      'Дата',
                      '${date.day} ${DateFormat('MMMM yyyy', 'ru').format(date)}',
                    ),
                    _buildDetailRow('Автомобиль', op['car']),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Закрыть'),
                      ),
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
}
