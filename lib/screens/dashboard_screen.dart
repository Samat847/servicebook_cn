import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import '../l10n/app_localizations.dart';
import 'add_service_screen.dart';
import 'sell_report_screen.dart';
import 'expense_analytics_screen.dart';
import 'AllRecordsScreen.dart';
import 'partners_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  static const double _avgFuelPricePerLiter = 55.0;
  static const int _plannedServiceMileage = 15000;
  static const double _partnerDiscountRate = 0.05;
  static const String _lastTipIndexKey = 'dashboard_last_tip_index';
  static const String _shownTipIndicesKey = 'dashboard_shown_tip_indices';
  static const int _recentTipMemory = 5;

  bool _isLoading = true;
  String? _errorMessage;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  Car? _selectedCar;
  List<Expense> _recentExpenses = [];
  double _monthlyExpenses = 0;
  int _nextServiceMileage = 0;
  bool _hasServiceData = false;
  bool _isServiceOverdue = false;

  String _fuelStat = '';
  String _washStat = '';
  String _serviceStat = '';
  String _tiresStat = '';
  String _currentTip = '';

  List<InsightCard> _insightCards = [];
  int _currentInsightIndex = 0;
  Timer? _insightTimer;
  final PageController _insightPageController =
      PageController(viewportFraction: 0.88);

  bool _locationPermissionRequested = false;
  bool _isFetchingLocation = false;
  String? _nearbyPartnerText;
  bool _locationDenied = false;

  static const List<Map<String, dynamic>> _partnerLocations = [
    {
      'id': 'Geely Service Center',
      'name': 'Geely Service',
      'lat': 55.751244,
      'lng': 37.618423,
      'discount': '10%',
    },
    {
      'id': 'Autoparts 24',
      'name': 'Autoparts 24',
      'lat': 55.734876,
      'lng': 37.588346,
      'discount': '7%',
    },
    {
      'id': 'Garage & Parts',
      'name': 'Garage & Parts',
      'lat': 55.760123,
      'lng': 37.641234,
      'discount': '5%',
    },
  ];

  static const List<String> _allTips = [
    'Не забывайте менять масло каждые 10 000 км.',
    'Проверяйте уровень антифриза перед зимой.',
    'Оригинальные запчасти Chery дешевле у партнёров.',
    'Держите давление в шинах на уровне, рекомендованном в мануале.',
    'Регулярно мойте днище после зимних дорог.',
    'Проверяйте тормозные колодки каждые 15 000 км.',
    'Своевременно меняйте салонный фильтр.',
    'Сохраняйте чеки на обслуживание для истории.',
    'Следите за уровнем масла перед дальними поездками.',
    'Прогревайте двигатель 1–2 минуты в холодный сезон.',
    'Сравнивайте цены на сервисы у партнёров приложения.',
    'Регулярно проверяйте уровень охлаждающей жидкости.',
    'Заменяйте воздушный фильтр каждые 15 000 км.',
    'Не игнорируйте индикатор Check Engine — своевременно обратитесь в сервис.',
    'Проверяйте давление в шинах раз в месяц.',
    'Используйте оригинальные масла, рекомендованные производителем.',
    'Обновляйте прошивку бортового компьютера у официального дилера.',
    'Проверяйте уровень тормозной жидкости каждые 30 000 км.',
    'Регулярно проверяйте состояние ремня ГРМ — его обрыв дорого обходится.',
    'Мойте двигатель раз в год, это продлит его ресурс.',
    'Проверяйте аккумулятор перед зимним сезоном.',
    'Смазывайте петли и замки дверей раз в год.',
    'Следите за состоянием щёток стеклоочистителя — менять раз в год.',
    'Чистите форсунки каждые 30 000 км для экономии топлива.',
    'Проверяйте зазоры клапанов согласно регламенту производителя.',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNearbyPartner();
    });
  }

  @override
  void dispose() {
    _insightTimer?.cancel();
    _insightPageController.dispose();
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

        final expenses =
            await CarStorage.loadExpensesList(carId: _selectedCar!.id);
        _recentExpenses = expenses.take(3).toList();

        final monthlyStats = await CarStorage.getExpenseStats(
          carId: _selectedCar!.id,
          from: startOfMonth,
          to: endOfMonth,
        );
        _monthlyExpenses = monthlyStats['total'] as double;

        _hasServiceData = false;
        _isServiceOverdue = false;
        _nextServiceMileage = 0;

        if (_selectedCar!.mileage != null) {
          Expense? lastServiceExpense;
          try {
            lastServiceExpense = expenses.firstWhere(
              (e) => e.category == ExpenseCategory.maintenance,
            );
          } catch (e) {
            lastServiceExpense = null;
          }
          if (lastServiceExpense != null) {
            final nextServiceAt =
                lastServiceExpense.mileage + _plannedServiceMileage;
            final remaining = nextServiceAt - _selectedCar!.mileage!;
            if (remaining <= 0) {
              _isServiceOverdue = true;
              _nextServiceMileage = remaining.abs();
            } else {
              _nextServiceMileage = remaining;
            }
            _hasServiceData = true;
          }
        }

        _fuelStat = _buildFuelStat(expenses);
        _washStat = _buildWashStat(expenses);
        _serviceStat = _buildServiceStat();
        _tiresStat = _buildTiresStat(expenses);

        _insightCards = await _generateInsightCards(expenses);
        _currentTip = await _pickNextTip();
      }

      setState(() {
        _isLoading = false;
      });

      _startInsightAutoScroll();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '${l10n.dataLoadingError} $e';
      });
    }
  }

  Future<String> _pickNextTip() async {
    final prefs = await SharedPreferences.getInstance();
    final shownRaw = prefs.getStringList(_shownTipIndicesKey) ?? [];
    final shownIndices = shownRaw.map(int.parse).toList();

    final available = List.generate(_allTips.length, (i) => i)
        .where((i) => !shownIndices.contains(i))
        .toList();

    final pool = available.isNotEmpty ? available : List.generate(_allTips.length, (i) => i);
    final picked = pool[Random().nextInt(pool.length)];

    final updatedShown = [...shownIndices, picked];
    final trimmed = updatedShown.length > _recentTipMemory
        ? updatedShown.sublist(updatedShown.length - _recentTipMemory)
        : updatedShown;
    await prefs.setStringList(
        _shownTipIndicesKey, trimmed.map((i) => i.toString()).toList());
    await prefs.setInt(_lastTipIndexKey, picked);

    return _allTips[picked];
  }

  Future<List<InsightCard>> _generateInsightCards(
      List<Expense> expenses) async {
    final cards = <InsightCard>[];
    final now = DateTime.now();

    final serviceColor =
        _isServiceOverdue ? Colors.red : Colors.orange;
    final serviceValue = _hasServiceData
        ? (_isServiceOverdue
            ? 'Просрочено на ${_formatNumber(_nextServiceMileage)} км'
            : '${_formatNumber(_nextServiceMileage)} км')
        : '➕ Добавить ТО';
    double? serviceProgress;
    if (_hasServiceData && !_isServiceOverdue) {
      serviceProgress =
          (_nextServiceMileage / _plannedServiceMileage).clamp(0.0, 1.0);
    } else if (_isServiceOverdue) {
      serviceProgress = 0.0;
    }
    cards.add(InsightCard(
      icon: '🔧',
      title: 'До следующего ТО',
      value: serviceValue,
      accentColor: serviceColor,
      progress: serviceProgress,
      isPlaceholder: !_hasServiceData,
      isUrgent: _isServiceOverdue,
    ));

    final fuelExpenses =
        expenses.where((e) => e.category == ExpenseCategory.fuel).toList();
    final currentConsumption = _calculateConsumption(
      fuelExpenses,
      from: now.subtract(const Duration(days: 30)),
      to: now,
    );
    final previousConsumption = _calculateConsumption(
      fuelExpenses,
      from: now.subtract(const Duration(days: 60)),
      to: now.subtract(const Duration(days: 30)),
    );

    String? trend;
    Color? trendColor;
    if (currentConsumption != null && previousConsumption != null) {
      final diff = currentConsumption - previousConsumption;
      if (diff.abs() >= 0.1) {
        final diffText = diff.abs().toStringAsFixed(1);
        trend = diff < 0
            ? '📉 -$diffText к прошл. месяцу'
            : '📈 +$diffText к прошл. месяцу';
        trendColor = diff < 0 ? Colors.green : Colors.red;
      }
    }

    final fuelPlaceholder = fuelExpenses.length < 2;
    cards.add(InsightCard(
      icon: '⛽',
      title: 'Средний расход',
      value: currentConsumption != null
          ? '${currentConsumption.toStringAsFixed(1)} л/100 км'
          : (fuelPlaceholder
              ? 'Добавьте больше заправок'
              : '➕ Добавить первую заправку'),
      accentColor: Colors.blue,
      trend: trend,
      trendColor: trendColor,
      isPlaceholder: currentConsumption == null,
    ));

    final documents = await CarStorage.loadDocumentsList();
    Document? expiringDocument;

    final docsWithExpiry = documents
        .where((d) => d.expiryDate != null)
        .toList()
      ..sort(
          (a, b) => (a.expiryDate ?? now).compareTo(b.expiryDate ?? now));

    if (docsWithExpiry.isNotEmpty) {
      expiringDocument = docsWithExpiry.first;
    }

    if (expiringDocument != null && expiringDocument.expiryDate != null) {
      final daysLeft = expiringDocument.expiryDate!.difference(now).inDays;
      final isExpired = daysLeft < 0;
      final docTitle = isExpired
          ? '${expiringDocument.type.displayName} истёк'
          : '${expiringDocument.type.displayName} истекает';
      final docValue = isExpired
          ? 'Просрочено на ${daysLeft.abs()} дн.'
          : '$daysLeft дней';
      cards.add(InsightCard(
        icon: '📄',
        title: docTitle,
        value: docValue,
        accentColor: (daysLeft < 14) ? Colors.red : Colors.orange,
        isUrgent: daysLeft < 14,
      ));
    } else {
      cards.add(const InsightCard(
        icon: '📄',
        title: 'Истекает документ',
        value: 'Документы не добавлены',
        accentColor: Colors.grey,
        isPlaceholder: true,
      ));
    }

    final partnerExpenses =
        expenses.where((e) => e.isPartner).toList();
    if (partnerExpenses.isNotEmpty) {
      final totalPartnerAmount =
          partnerExpenses.fold<double>(0, (sum, e) => sum + e.amount);
      final savedAmount =
          (totalPartnerAmount * _partnerDiscountRate).round();
      cards.add(InsightCard(
        icon: '💰',
        title: 'Сэкономлено',
        value: '${_formatNumber(savedAmount)} ₽',
        subtitle: 'на партнёрских АЗС/СТО',
        accentColor: Colors.green,
      ));
    } else {
      cards.add(const InsightCard(
        icon: '💰',
        title: 'Сэкономлено',
        value: '0 ₽',
        subtitle: 'Совершайте покупки у партнёров',
        accentColor: Colors.grey,
        isPlaceholder: true,
      ));
    }

    return cards;
  }

  void _startInsightAutoScroll() {
    _insightTimer?.cancel();
    if (_insightCards.length > 1) {
      _insightTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _currentInsightIndex =
            (_currentInsightIndex + 1) % _insightCards.length;
        _insightPageController.animateToPage(
          _currentInsightIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _loadNearbyPartner() async {
    if (_locationPermissionRequested) return;

    setState(() {
      _locationPermissionRequested = true;
      _isFetchingLocation = true;
      _locationDenied = false;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _isFetchingLocation = false;
        _locationDenied = true;
      });
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        _isFetchingLocation = false;
        _locationDenied = true;
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      Map<String, dynamic>? nearest;
      double? nearestDistance;
      for (final partner in _partnerLocations) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          partner['lat'] as double,
          partner['lng'] as double,
        );
        if (nearestDistance == null || distance < nearestDistance) {
          nearestDistance = distance;
          nearest = partner;
        }
      }

      if (!mounted) return;
      if (nearest == null || nearestDistance == null) {
        setState(() {
          _isFetchingLocation = false;
          _nearbyPartnerText = null;
        });
        return;
      }

      final distanceKm = (nearestDistance / 1000).toStringAsFixed(1);
      final discount = nearest['discount'] as String? ?? '10%';
      final partnerName = nearest['name'] as String? ?? 'Партнёр';
      setState(() {
        _isFetchingLocation = false;
        _nearbyPartnerText =
            'Рядом с вами: $partnerName ($distanceKm км) – скидка $discount';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isFetchingLocation = false;
        _nearbyPartnerText = null;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  Future<void> refreshFromParent() async {
    await _loadData();
  }

  String _buildFuelStat(List<Expense> expenses) {
    final fuelExpenses =
        expenses.where((e) => e.category == ExpenseCategory.fuel).toList();
    if (fuelExpenses.isEmpty) return '';
    final latest = fuelExpenses.first;
    final liters = latest.amount / _avgFuelPricePerLiter;
    return 'Последняя: ${liters.toStringAsFixed(0)} л';
  }

  String _buildWashStat(List<Expense> expenses) {
    final washExpenses =
        expenses.where((e) => e.category == ExpenseCategory.wash).toList();
    if (washExpenses.isEmpty) return '';
    final latest = washExpenses.first;
    final days = DateTime.now().difference(latest.date).inDays;
    return _formatDaysAgo(days);
  }

  String _buildServiceStat() {
    if (!_hasServiceData) return '';
    if (_isServiceOverdue) return 'Просрочено!';
    return 'Осталось ${_formatNumber(_nextServiceMileage)} км';
  }

  String _buildTiresStat(List<Expense> expenses) {
    final tireExpenses =
        expenses.where((e) => e.category == ExpenseCategory.tires).toList();
    final referenceDate =
        tireExpenses.isNotEmpty ? tireExpenses.first.date : DateTime.now();
    return 'Сезон: ${_getSeason(referenceDate)}';
  }

  double? _calculateConsumption(
    List<Expense> fuelExpenses, {
    required DateTime from,
    required DateTime to,
  }) {
    final filtered = fuelExpenses
        .where((e) => e.date.isAfter(from) && e.date.isBefore(to))
        .toList();
    if (filtered.length < 2) return null;
    filtered.sort((a, b) => a.date.compareTo(b.date));
    final first = filtered.first;
    final last = filtered.last;
    final mileageDiff = last.mileage - first.mileage;
    if (mileageDiff <= 0) return null;
    final totalAmount = filtered.fold<double>(0, (sum, e) => sum + e.amount);
    final liters = totalAmount / _avgFuelPricePerLiter;
    if (liters <= 0) return null;
    return (liters / mileageDiff) * 100;
  }

  String _getSeason(DateTime date) {
    final month = date.month;
    if (month == 12 || month <= 2) return 'зима';
    if (month >= 3 && month <= 5) return 'весна';
    if (month >= 6 && month <= 8) return 'лето';
    return 'осень';
  }

  String _formatDaysAgo(int days) {
    if (days <= 0) return 'Сегодня';
    if (days == 1) return '1 день назад';
    if (days >= 2 && days <= 4) return '$days дня назад';
    return '$days дней назад';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
              Icon(Icons.directions_car_outlined,
                  size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                l10n?.noCars ?? 'Нет автомобилей',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.noCarsDescription ??
                    'Добавьте автомобиль в разделе "Гараж"',
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
            SliverList(
              delegate: SliverChildListDelegate([
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
                              Icon(Icons.speed,
                                  size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedCar!.mileage?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ') ?? '0'} км',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700),
                              ),
                              const SizedBox(width: 20),
                              Icon(Icons.confirmation_number,
                                  size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text(
                                _selectedCar!.plate ??
                                    (l10n?.withoutPlate ?? 'Без номера'),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
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
                                      color: Colors.grey.shade600),
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
                                      color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _hasServiceData
                                      ? (_isServiceOverdue
                                          ? 'Просрочено'
                                          : (l10n?.inKM(_nextServiceMileage) ??
                                              'через $_nextServiceMileage км'))
                                      : 'Нет данных',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _isServiceOverdue
                                        ? Colors.red
                                        : null,
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
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Быстрые действия',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradientAction(
                              key: const Key('add_service_button'),
                              icon: Icons.add,
                              label: l10n?.addRecord ?? 'Добавить запись',
                              stat: '',
                              colors: const [
                                Color(0xFF1565C0),
                                Color(0xFF42A5F5),
                              ],
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddServiceScreen(
                                        car: _selectedCar!),
                                  ),
                                );
                                if (result == true) await _refreshData();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGradientAction(
                              key: const Key('sell_report_button'),
                              icon: Icons.description,
                              label:
                                  l10n?.sellReport ?? 'Отчет для продажи',
                              stat: '',
                              colors: const [
                                Color(0xFF2E7D32),
                                Color(0xFF66BB6A),
                              ],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SellReportScreen(car: _selectedCar!),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGradientAction(
                              key: const Key('analytics_button'),
                              icon: Icons.insights,
                              label: l10n?.analytics ?? 'Аналитика',
                              stat: '',
                              colors: const [
                                Color(0xFF6A1B9A),
                                Color(0xFFBA68C8),
                              ],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExpenseAnalyticsScreen(
                                            car: _selectedCar!),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGradientAction(
                              icon: Icons.people,
                              label: 'Партнёры СТО',
                              stat: '',
                              colors: const [
                                Color(0xFFE65100),
                                Color(0xFFFF8A65),
                              ],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PartnersScreen(car: _selectedCar),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradientAction(
                              icon: Icons.local_gas_station,
                              label: l10n?.refuel ?? 'Заправить',
                              stat: _fuelStat,
                              colors: const [
                                Color(0xFF1E88E5),
                                Color(0xFF64B5F6),
                              ],
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddServiceScreen(
                                      car: _selectedCar!,
                                      initialCategory: ExpenseCategory.fuel,
                                      initialWorkType:
                                          l10n?.fuelWorkType ?? 'Топливо',
                                    ),
                                  ),
                                );
                                if (result == true) await _refreshData();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGradientAction(
                              icon: Icons.local_car_wash,
                              label: l10n?.carWash ?? 'Мойка',
                              stat: _washStat,
                              colors: const [
                                Color(0xFF43A047),
                                Color(0xFF9CCC65),
                              ],
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddServiceScreen(
                                      car: _selectedCar!,
                                      initialCategory: ExpenseCategory.wash,
                                      initialWorkType:
                                          l10n?.washWorkType ?? 'Мойка',
                                    ),
                                  ),
                                );
                                if (result == true) await _refreshData();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGradientAction(
                              icon: Icons.build,
                              label: l10n?.service ?? 'ТО',
                              stat: _serviceStat,
                              colors: const [
                                Color(0xFFFF8F00),
                                Color(0xFFFFD54F),
                              ],
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddServiceScreen(
                                      car: _selectedCar!,
                                      initialCategory:
                                          ExpenseCategory.maintenance,
                                      initialWorkType: 'ТО',
                                    ),
                                  ),
                                );
                                if (result == true) await _refreshData();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGradientAction(
                              icon: Icons.tire_repair,
                              label: l10n?.tires ?? 'Шины',
                              stat: _tiresStat,
                              colors: const [
                                Color(0xFF7E57C2),
                                Color(0xFFF06292),
                              ],
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddServiceScreen(
                                      car: _selectedCar!,
                                      initialCategory: ExpenseCategory.tires,
                                      initialWorkType:
                                          l10n?.tiresWorkType ?? 'Резина',
                                    ),
                                  ),
                                );
                                if (result == true) await _refreshData();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              size: 20, color: Colors.amber),
                          const SizedBox(width: 8),
                          const Text(
                            'Умные подсказки',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 170,
                        child: PageView.builder(
                          controller: _insightPageController,
                          itemCount: _insightCards.length,
                          onPageChanged: (index) {
                            _currentInsightIndex = index;
                          },
                          itemBuilder: (context, index) {
                            return _buildInsightCard(_insightCards[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNearbyWidget(),
                      const SizedBox(height: 12),
                      _buildDailyTipWidget(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                                builder: (context) =>
                                    const AllRecordsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            l10n?.all ?? 'Все',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                    color: Color(expense.category.colorValue)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      _getCategoryIcon(expense.category),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      expense.formattedAmount,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (expense.isPartner)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Партнёр',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
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

  Widget _buildGradientAction({
    Key? key,
    required IconData icon,
    required String label,
    required String stat,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        _PulsatingIconButton(
          icon: icon,
          colors: colors,
          onTap: onTap,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        if (stat.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            stat,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ],
    );
  }

  Widget _buildInsightCard(InsightCard card) {
    final valueColor = card.isPlaceholder ? Colors.grey : card.accentColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      card.accentColor,
                      card.accentColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: card.accentColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    card.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  card.title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (card.isUrgent)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            card.value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          if (card.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              card.subtitle!,
              style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
          if (card.progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: card.progress,
                minHeight: 6,
                backgroundColor: card.accentColor.withOpacity(0.15),
                valueColor:
                    AlwaysStoppedAnimation<Color>(card.accentColor),
              ),
            ),
          ],
          if (card.trend != null) ...[
            const SizedBox(height: 8),
            Text(
              card.trend!,
              style: TextStyle(
                fontSize: 12,
                color: card.trendColor ?? Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNearbyWidget() {
    final text = _isFetchingLocation
        ? 'Определяем ближайший сервис...'
        : _nearbyPartnerText ??
            (_locationDenied
                ? 'Разрешите доступ к геолокации, чтобы видеть ближайшие СТО'
                : 'Подключаем геолокацию, чтобы показать ближайшие СТО');

    return InkWell(
      onTap: _nearbyPartnerText != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PartnersScreen(car: _selectedCar),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style:
                    TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
            if (_nearbyPartnerText != null)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PartnersScreen(car: _selectedCar),
                    ),
                  );
                },
                child: const Text('На карту'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTipWidget() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _currentTip,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
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
    final months = [
      'Янв', 'Фев', 'Мар', 'Апр', 'Мая', 'Июн',
      'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}

class InsightCard {
  final String icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color accentColor;
  final double? progress;
  final String? trend;
  final Color? trendColor;
  final bool isUrgent;
  final bool isPlaceholder;

  const InsightCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.accentColor,
    this.subtitle,
    this.progress,
    this.trend,
    this.trendColor,
    this.isUrgent = false,
    this.isPlaceholder = false,
  });
}

class _PulsatingIconButton extends StatefulWidget {
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const _PulsatingIconButton({
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_PulsatingIconButton> createState() => _PulsatingIconButtonState();
}

class _PulsatingIconButtonState extends State<_PulsatingIconButton> {
  double _scale = 1.0;

  Future<void> _handleTap() async {
    setState(() => _scale = 0.92);
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: widget.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.colors.last.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
