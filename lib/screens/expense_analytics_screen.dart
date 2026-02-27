import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import 'expense_detail_analytics_screen.dart';
import 'all_operations_screen.dart';

class ExpenseAnalyticsScreen extends StatefulWidget {
  final Car car;

  const ExpenseAnalyticsScreen({super.key, required this.car});

  @override
  State<ExpenseAnalyticsScreen> createState() => _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState extends State<ExpenseAnalyticsScreen> {
  String _selectedPeriod = 'month';
  bool _isLoading = true;
  String? _errorMessage;

  double _totalAmount = 0;
  double _previousPeriodAmount = 0;
  Map<String, double> _byCategory = {};
  List<Expense> _recentExpenses = [];

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
      final now = DateTime.now();
      DateTime from;
      DateTime to;
      DateTime previousFrom;
      DateTime previousTo;

      switch (_selectedPeriod) {
        case 'month':
          from = DateTime(now.year, now.month, 1);
          to = DateTime(now.year, now.month + 1, 0);
          previousFrom = DateTime(now.year, now.month - 1, 1);
          previousTo = DateTime(now.year, now.month, 0);
          break;
        case 'quarter':
          final quarter = ((now.month - 1) ~/ 3) + 1;
          from = DateTime(now.year, (quarter - 1) * 3 + 1, 1);
          to = DateTime(now.year, quarter * 3 + 1, 0);
          previousFrom = DateTime(now.year, (quarter - 2) * 3 + 1, 1);
          previousTo = DateTime(now.year, (quarter - 1) * 3 + 1, 0);
          break;
        case 'year':
          from = DateTime(now.year, 1, 1);
          to = DateTime(now.year, 12, 31);
          previousFrom = DateTime(now.year - 1, 1, 1);
          previousTo = DateTime(now.year - 1, 12, 31);
          break;
        default:
          from = DateTime(2000);
          to = now;
          previousFrom = DateTime(2000);
          previousTo = now;
      }

      final stats = await CarStorage.getExpenseStats(
        carId: widget.car.id,
        from: from,
        to: to,
      );

      final previousStats = await CarStorage.getExpenseStats(
        carId: widget.car.id,
        from: previousFrom,
        to: previousTo,
      );

      final expenses = await CarStorage.getRecentExpenses(limit: 3, carId: widget.car.id);

      setState(() {
        _totalAmount = stats['total'] as double;
        _previousPeriodAmount = previousStats['total'] as double;
        _byCategory = (stats['byCategory'] as Map<String, dynamic>).cast<String, double>();
        _recentExpenses = expenses;
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

  double get _changePercent {
    if (_previousPeriodAmount == 0) return 0;
    return ((_totalAmount - _previousPeriodAmount) / _previousPeriodAmount) * 100;
  }

  bool get _isIncrease => _changePercent > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Расходы',
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Переключатель периода
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          child: Row(
                            children: [
                              _buildPeriodChip('Месяц', 'month'),
                              const SizedBox(width: 8),
                              _buildPeriodChip('Квартал', 'quarter'),
                              const SizedBox(width: 8),
                              _buildPeriodChip('Год', 'year'),
                              const SizedBox(width: 8),
                              _buildPeriodChip('Все', 'all'),
                            ],
                          ),
                        ),

                        // Блок с суммой и изменением
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                              Text(
                                '${_formatPrice(_totalAmount.toInt())} ₽',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (_selectedPeriod != 'all') ...[
                                Row(
                                  children: [
                                    Icon(
                                      _isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                                      size: 16,
                                      color: _isIncrease ? Colors.red.shade600 : Colors.green.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_changePercent.abs().toStringAsFixed(1)}% к прошлому ${_getPeriodLabel()}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _isIncrease ? Colors.red.shade600 : Colors.green.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // График категорий
                        if (_byCategory.isNotEmpty) ...[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
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
                                  'Распределение по категориям',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ..._buildCategoryBars(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Категории
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Категории',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                key: const Key('analytics_details_button'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExpenseDetailAnalyticsScreen(car: widget.car),
                                    ),
                                  );
                                },
                                child: const Text('Детали'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: _buildCategoryTiles(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // История операций
                        if (_recentExpenses.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Text(
                              'История операций',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: _recentExpenses.map((expense) {
                                  return _buildOperationRow(expense);
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton(
                              key: const Key('show_all_operations_button'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllOperationsScreen(car: widget.car),
                                  ),
                                );
                              },
                            child: const Text('Показать все операции'),
                            ),
                          ),
                        ],
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
    );
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case 'month':
        return 'месяцу';
      case 'quarter':
        return 'кварталу';
      case 'year':
        return 'году';
      default:
        return 'периоду';
    }
  }

  List<Widget> _buildCategoryBars() {
    if (_byCategory.isEmpty) return [];

    final maxAmount = _byCategory.values.reduce((a, b) => a > b ? a : b);

    return _byCategory.entries.map((entry) {
      final category = ExpenseCategory.fromCode(entry.key);
      final percent = maxAmount > 0 ? (entry.value / maxAmount) : 0;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(category.colorValue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(category),
                color: Color(category.colorValue),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Text(
                category.displayName,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percent.toDouble(),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(category.colorValue),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 70,
              child: Text(
                _formatPrice(entry.value.toInt()),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildCategoryTiles() {
    if (_byCategory.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Нет данных',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      ];
    }

    return _byCategory.entries.map((entry) {
      final category = ExpenseCategory.fromCode(entry.key);
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _buildCategoryTile(
          icon: _getCategoryIcon(category),
          title: category.displayName,
          amount: '${_formatPrice(entry.value.toInt())} ₽',
          color: Color(category.colorValue),
        ),
      );
    }).toList();
  }

  Widget _buildOperationRow(Expense expense) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    expense.date.day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      expense.category.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '-${expense.formattedAmount} ₽',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
      ],
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

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
        });
        _loadData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E88E5) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
