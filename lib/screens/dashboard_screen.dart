import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import '../l10n/app_localizations.dart';
import 'add_service_screen.dart';
import 'sell_report_screen.dart';
import 'expense_analytics_screen.dart';
import 'AllRecordsScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  Car? _selectedCar;
  List<Expense> _recentExpenses = [];
  double _monthlyExpenses = 0;
  int _nextServiceMileage = 4580;
  
  // Подсказки
  List<SmartTip> _smartTips = [];
  int _currentTipIndex = 0;
  Timer? _tipTimer;
  final PageController _tipPageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _tipTimer?.cancel();
    _tipPageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cars = await CarStorage.loadCarsList();
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      if (cars.isNotEmpty) {
        _selectedCar = cars.first;
        
        // Load all expenses for the selected car
        final expenses = await CarStorage.loadExpensesList(carId: _selectedCar!.id);
        _recentExpenses = expenses.take(3).toList();
        
        // Calculate monthly expenses
        final monthlyStats = await CarStorage.getExpenseStats(
          carId: _selectedCar!.id,
          from: startOfMonth,
          to: endOfMonth,
        );
        _monthlyExpenses = monthlyStats['total'] as double;
        
        // Calculate next service mileage
        if (_selectedCar!.mileage != null) {
          Expense? lastServiceExpense;
          try {
            lastServiceExpense = expenses.firstWhere((e) => e.category == ExpenseCategory.maintenance);
          } catch (e) {
            lastServiceExpense = null;
          }
          if (lastServiceExpense != null) {
            final nextServiceAt = lastServiceExpense.mileage + 15000;
            _nextServiceMileage = nextServiceAt - _selectedCar!.mileage!;
            if (_nextServiceMileage < 0) _nextServiceMileage = 0;
          }
        }

        // Generate smart tips
        _smartTips = await _generateSmartTips(expenses);
      }

      setState(() {
        _isLoading = false;
      });

      // Start auto-scroll for tips
      _startTipAutoScroll();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '${l10n?.dataLoadingError} $e';
      });
    }
  }

  Future<List<SmartTip>> _generateSmartTips(List<Expense> expenses) async {
    final tips = <SmartTip>[];
    final now = DateTime.now();
    final localL10n = l10n;

    // 1. Средний расход топлива
    final fuelExpenses = expenses.where((e) => e.category == ExpenseCategory.fuel).toList();
    if (fuelExpenses.isNotEmpty && _selectedCar!.mileage != null) {
      // Берем последние заправки за последние 3 месяца
      final recentFuel = fuelExpenses.where((e) => 
        e.date.isAfter(now.subtract(const Duration(days: 90)))).toList();
      
      if (recentFuel.isNotEmpty) {
        // Рассчитываем примерный расход на основе данных
        // Считаем что каждая заправка - примерно 40-50 литров в среднем
        final totalAmount = recentFuel.fold<double>(0, (sum, e) => sum + e.amount);
        final avgPricePerLiter = 55.0; // Примерная цена за литр
        final estimatedLiters = totalAmount / avgPricePerLiter;
        
        // Находим пробег за период
        final firstFuel = recentFuel.last;
        final lastFuel = recentFuel.first;
        final mileageDiff = lastFuel.mileage - firstFuel.mileage;
        
        if (mileageDiff > 0 && estimatedLiters > 0) {
          final consumption = (estimatedLiters / mileageDiff) * 100;
          tips.add(SmartTip(
            icon: '⛽',
            title: localL10n.avgConsumption,
            value: '${consumption.toStringAsFixed(1)} л/100 км',
            color: Colors.blue,
          ));
        }
      }
    }

    // 2. До следующего ТО
    if (_nextServiceMileage > 0) {
      tips.add(SmartTip(
        icon: '🔧',
        title: localL10n.untilNextService,
        value: '$_nextServiceMileage ${localL10n.untilNextServiceShort}',
        color: Colors.orange,
      ));
    }

    // 3. Истекающий документ
    final documents = await CarStorage.loadDocumentsList();
    final expiringDocs = documents.where((d) {
      if (d.expiryDate == null) return false;
      final daysUntilExpiry = d.expiryDate!.difference(now).inDays;
      return daysUntilExpiry <= 60 && daysUntilExpiry >= 0;
    }).toList()..sort((a, b) => 
      (a.expiryDate ?? DateTime.now()).compareTo(b.expiryDate ?? DateTime.now()));

    if (expiringDocs.isNotEmpty) {
      final doc = expiringDocs.first;
      final daysLeft = doc.expiryDate!.difference(now).inDays;
      tips.add(SmartTip(
        icon: '📄',
        title: doc.type.displayName,
        value: '${localL10n.documentExpiring} $daysLeft ${localL10n.documentDays}',
        color: daysLeft <= 30 ? Colors.red : Colors.orange,
      ));
    }

    // 4. Экономия / Расходы за месяц
    if (_monthlyExpenses > 0) {
      tips.add(SmartTip(
        icon: '💰',
        title: localL10n.monthlySpending,
        value: '${_formatPrice(_monthlyExpenses.toInt())} ₽',
        color: Colors.green,
      ));
    }

    // 5. Напоминание о давлении в шинах (раз в месяц)
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final shouldShowTireReminder = now.day >= 15 && now.day <= 20;
    if (shouldShowTireReminder) {
      tips.add(SmartTip(
        icon: '🛞',
        title: localL10n.reminder,
        value: localL10n.checkTirePressure,
        color: Colors.purple,
      ));
    }

    // Если нет подсказок, добавляем заглушку
    if (tips.isEmpty) {
      tips.add(SmartTip(
        icon: '📝',
        title: localL10n.tipAdvice,
        value: localL10n.tipAddFirstRecord,
        color: Colors.grey,
      ));
    }

    return tips;
  }

  void _startTipAutoScroll() {
    _tipTimer?.cancel();
    if (_smartTips.length > 1) {
      _tipTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _currentTipIndex = (_currentTipIndex + 1) % _smartTips.length;
        _tipPageController.animateToPage(
          _currentTipIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red[700]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: Text(l10n?.retry ?? 'Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    if (_selectedCar == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                l10n?.noCars ?? 'Нет автомобилей',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.noCarsDescription ?? 'Добавьте автомобиль в разделе "Гараж"',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // AppBar с заголовком
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 1,
              title: Text(
                l10n?.myGarage ?? 'Мой Гараж',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),

            // Основной контент
            SliverList(
              delegate: SliverChildListDelegate([
                // Информация об автомобиле
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCar!.brand,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _selectedCar!.shortInfo,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.speed,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedCar!.mileage?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ') ?? '0'} км',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Icon(
                                Icons.confirmation_number,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedCar!.plate ?? (l10n?.withoutPlate ?? 'Без номера'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Статистика в две колонки
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Расходы в текущем месяце
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n?.monthlyExpenses ?? 'Расходы в месяце',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_formatPrice(_monthlyExpenses.toInt())} ₽',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Следующее ТО
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n?.nextService ?? 'Следующее ТО',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n?.inKM(_nextServiceMileage) ?? 'через $_nextServiceMileage км',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Быстрые действия
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAction(
                        key: const Key('add_service_button'),
                        icon: Icons.add_circle_outline,
                        label: l10n?.addRecord ?? 'Добавить запись',
                        color: Colors.blue,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddServiceScreen(car: _selectedCar!),
                            ),
                          );
                          if (result == true) {
                            await _refreshData();
                          }
                        },
                      ),
                      _buildQuickAction(
                        key: const Key('sell_report_button'),
                        icon: Icons.description_outlined,
                        label: l10n?.sellReport ?? 'Отчет для продажи',
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellReportScreen(car: _selectedCar!),
                            ),
                          );
                        },
                      ),
                      _buildQuickAction(
                        key: const Key('analytics_button'),
                        icon: Icons.insights_outlined,
                        label: l10n?.analytics ?? 'Аналитика',
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpenseAnalyticsScreen(car: _selectedCar!),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Блок «Быстрые действия и подсказки»
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.quickActions ?? 'Быстрые действия',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Иконки быстрых действий
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickActionIcon(
                        emoji: '⛽',
                        label: l10n?.refuel ?? 'Заправить',
                        color: Colors.blue,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddServiceScreen(
                                car: _selectedCar!,
                                initialCategory: ExpenseCategory.fuel,
                                initialWorkType: l10n?.fuelWorkType ?? 'Топливо',
                              ),
                            ),
                          );
                          if (result == true) {
                            await _refreshData();
                          }
                        },
                      ),
                      _buildQuickActionIcon(
                        emoji: '🧼',
                        label: l10n?.carWash ?? 'Мойка',
                        color: Colors.green,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddServiceScreen(
                                car: _selectedCar!,
                                initialCategory: ExpenseCategory.wash,
                                initialWorkType: l10n?.washWorkType ?? 'Мойка',
                              ),
                            ),
                          );
                          if (result == true) {
                            await _refreshData();
                          }
                        },
                      ),
                      _buildQuickActionIcon(
                        emoji: '🔧',
                        label: l10n?.service ?? 'ТО',
                        color: Colors.orange,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddServiceScreen(
                                car: _selectedCar!,
                                initialCategory: ExpenseCategory.maintenance,
                                initialWorkType: 'ТО',
                              ),
                            ),
                          );
                          if (result == true) {
                            await _refreshData();
                          }
                        },
                      ),
                      _buildQuickActionIcon(
                        emoji: '🛞',
                        label: l10n?.tires ?? 'Шины',
                        color: Colors.purple,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddServiceScreen(
                                car: _selectedCar!,
                                initialCategory: ExpenseCategory.tires,
                                initialWorkType: l10n?.tiresWorkType ?? 'Резина',
                              ),
                            ),
                          );
                          if (result == true) {
                            await _refreshData();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Заголовок подсказок
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 20, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        l10n?.smartTips ?? 'Умные подсказки',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Карусель подсказок
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 80,
                    child: _smartTips.isEmpty
                        ? _buildTipCard(SmartTip(
                            icon: '📝',
                            title: l10n?.tipAdvice ?? 'Совет',
                            value: l10n?.tipAddFirstRecord ?? 'Добавьте первую запись',
                            color: Colors.grey,
                          ))
                        : PageView.builder(
                            controller: _tipPageController,
                            itemCount: _smartTips.length,
                            onPageChanged: (index) {
                              _currentTipIndex = index;
                            },
                            itemBuilder: (context, index) {
                              return _buildTipCard(_smartTips[index]);
                            },
                          ),
                  ),
                ),

                // Индикаторы страниц
                if (_smartTips.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_smartTips.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentTipIndex
                                ? Colors.blue
                                : Colors.grey.shade300,
                          ),
                        );
                      }),
                    ),
                  ),
                const SizedBox(height: 16),

                // История работ
                if (_recentExpenses.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n?.workHistory ?? 'История работ',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllRecordsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            l10n?.all ?? 'Все',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Список истории работ
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _recentExpenses.map((expense) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(expense.category.colorValue).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: _getCategoryIcon(expense.category),
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
                                      Text(
                                        '${_formatDate(expense.date)} • ${expense.place ?? 'Не указано'}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  expense.formattedAmount,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllRecordsScreen(),
                          ),
                        );
                      },
                      child: Text(l10n?.allRecords ?? 'Все записи'),
                    ),
                  ),
                ],

                const SizedBox(height: 80),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionIcon({
    required String emoji,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(SmartTip tip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tip.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                tip.icon,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tip.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tip.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    Key? key,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        key: key,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCategoryIcon(ExpenseCategory category) {
    final iconData = {
      'local_gas_station': Icons.local_gas_station,
      'build': Icons.build,
      'local_car_wash': Icons.local_car_wash,
      'car_repair': Icons.car_repair,
      'security': Icons.security,
      'shopping_bag': Icons.shopping_bag,
      'search': Icons.search,
      'tire_repair': Icons.tire_repair,
      'more_horiz': Icons.more_horiz,
    }[category.iconName];
    
    return Icon(
      iconData ?? Icons.receipt,
      color: Color(category.colorValue),
      size: 20,
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Янв', 'Фев', 'Мар', 'Апр', 'Мая', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}

class SmartTip {
  final String icon;
  final String title;
  final String value;
  final Color color;

  SmartTip({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}