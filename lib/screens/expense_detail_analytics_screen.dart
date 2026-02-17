import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetailAnalyticsScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const ExpenseDetailAnalyticsScreen({super.key, required this.car});

  @override
  State<ExpenseDetailAnalyticsScreen> createState() =>
      _ExpenseDetailAnalyticsScreenState();
}

class _ExpenseDetailAnalyticsScreenState
    extends State<ExpenseDetailAnalyticsScreen> {
  String _selectedPeriod = 'Месяц';

  final List<Map<String, dynamic>> _allOperations = [
    {
      'date': DateTime(2024, 10, 24),
      'description': 'Заправка АИ-95 • Газпромнефть',
      'amount': 2450.0,
      'category': 'Топливо',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
    },
    {
      'date': DateTime(2024, 10, 18),
      'description': 'Мойка Люкс Комплекс',
      'amount': 900.0,
      'category': 'Мойка',
      'icon': Icons.local_car_wash,
      'color': Colors.blue,
    },
    {
      'date': DateTime(2024, 10, 15),
      'description': 'Замена масла ТО-1 • Geely Service',
      'amount': 4500.0,
      'category': 'Обслуживание',
      'icon': Icons.build,
      'color': Colors.green,
    },
    {
      'date': DateTime(2024, 10, 10),
      'description': 'Заправка АИ-95 • Лукойл',
      'amount': 2100.0,
      'category': 'Топливо',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
    },
    {
      'date': DateTime(2024, 10, 5),
      'description': 'Шиномонтаж • Сезонная замена',
      'amount': 3200.0,
      'category': 'Обслуживание',
      'icon': Icons.tire_repair,
      'color': Colors.green,
    },
    {
      'date': DateTime(2024, 9, 28),
      'description': 'Заправка АИ-95 • Shell',
      'amount': 2800.0,
      'category': 'Топливо',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
    },
    {
      'date': DateTime(2024, 9, 20),
      'description': 'Диагностика подвески',
      'amount': 1500.0,
      'category': 'Диагностика',
      'icon': Icons.search,
      'color': Colors.purple,
    },
    {
      'date': DateTime(2024, 9, 15),
      'description': 'Замена тормозных колодок',
      'amount': 6500.0,
      'category': 'Ремонт',
      'icon': Icons.car_repair,
      'color': Colors.red,
    },
  ];

  List<Map<String, dynamic>> get _filteredOperations {
    final now = DateTime.now();
    DateTime cutoffDate;

    switch (_selectedPeriod) {
      case 'Месяц':
        cutoffDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case '3 месяца':
        cutoffDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case 'Год':
        cutoffDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case 'Всё время':
        return _allOperations;
      default:
        cutoffDate = DateTime(now.year, now.month - 1, now.day);
    }

    return _allOperations
        .where((op) => (op['date'] as DateTime).isAfter(cutoffDate))
        .toList();
  }

  Map<String, double> get _expensesByCategory {
    final Map<String, double> result = {};
    for (var op in _filteredOperations) {
      final category = op['category'] as String;
      final amount = op['amount'] as double;
      result[category] = (result[category] ?? 0) + amount;
    }
    return result;
  }

  double get _totalExpenses {
    return _filteredOperations.fold(
      0,
      (sum, op) => sum + (op['amount'] as double),
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
          'Детальная аналитика',
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
          // Period selector
          _buildPeriodSelector(),

          // Chart section
          _buildExpenseChart(),

          // Total expenses
          _buildTotalExpenses(),

          // Operation list section
          Expanded(
            child: _buildOperationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Месяц', '3 месяца', 'Год', 'Всё время'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: periods.map((period) {
            final isSelected = _selectedPeriod == period;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(period),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  }
                },
                selectedColor: const Color(0xFF1E88E5),
                backgroundColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExpenseChart() {
    final expenses = _expensesByCategory;
    if (expenses.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                'Нет данных за выбранный период',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final sortedEntries = expenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxValue = sortedEntries.first.value;

    final categoryColors = {
      'Топливо': Colors.orange,
      'Обслуживание': Colors.green,
      'Мойка': Colors.blue,
      'Ремонт': Colors.red,
      'Диагностика': Colors.purple,
      'Запчасти': Colors.teal,
      'Страховка': Colors.indigo,
    };

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Расходы по категориям',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...sortedEntries.map((entry) {
            final percentage = (entry.value / _totalExpenses * 100).toInt();
            final color = categoryColors[entry.key] ?? Colors.grey;
            final barWidth = (entry.value / maxValue * 200).clamp(50.0, 200.0);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getCategoryIcon(entry.key),
                      color: color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 8,
                          width: barWidth,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${_formatPrice(entry.value.toInt())} ₽',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Топливо':
        return Icons.local_gas_station;
      case 'Обслуживание':
        return Icons.build;
      case 'Мойка':
        return Icons.local_car_wash;
      case 'Ремонт':
        return Icons.car_repair;
      case 'Диагностика':
        return Icons.search;
      case 'Запчасти':
        return Icons.shopping_bag;
      case 'Страховка':
        return Icons.security;
      default:
        return Icons.receipt;
    }
  }

  Widget _buildTotalExpenses() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E88E5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Всего расходов',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'за выбранный период',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          Text(
            '${_formatPrice(_totalExpenses.toInt())} ₽',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationList() {
    final operations = _filteredOperations.toList()
      ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    if (operations.isEmpty) {
      return Center(
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
              'Нет операций за выбранный период',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'История операций',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: operations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                final op = operations[index];
                return _buildOperationRow(op);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationRow(Map<String, dynamic> op) {
    final date = op['date'] as DateTime;
    final day = date.day.toString();
    final month = DateFormat('MMM', 'ru').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
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
                    fontSize: 18,
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  op['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  op['category'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-${_formatPrice(op['amount'].toInt())} ₽',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
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
