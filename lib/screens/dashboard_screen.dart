import 'package:flutter/material.dart';
import 'add_service_screen.dart';
import 'sell_report_screen.dart';
import 'partners_screen.dart';
import 'expense_analytics_screen.dart';
import 'AllRecordsScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Заглушка данных автомобиля
  Map<String, dynamic> _selectedCar = {
    'brand': 'Geely',
    'model': 'Monjaro',
    'year': '2022',
    'plate': 'A 777 AA',
    'mileage': 15420,
    'vin': 'LVSHCAMB1CE012345',
  };

  // Заглушка истории работ
  final List<Map<String, dynamic>> _serviceHistory = [
    {
      'title': 'Плановое ТО-1',
      'date': '24 Окт',
      'place': 'Jetour Service',
      'price': '18 400 ₽',
      'icon': Icons.build,
      'color': Colors.blue,
    },
    {
      'title': 'Замена тормозной жидкости',
      'date': '15 Сен',
      'place': 'Гараж #1',
      'price': '3 200 ₽',
      'icon': Icons.water_drop,
      'color': Colors.orange,
    },
    {
      'title': 'Покупка зимней резины',
      'date': '02 Сен',
      'place': 'Магазин',
      'price': '42 000 ₽',
      'icon': Icons.snowing,
      'color': Colors.green,
    },
  ];

  // Заглушка партнерских СТО
  final List<Map<String, dynamic>> _partnerStations = [
    {
      'name': 'Jetour Service',
      'address': 'ул. Автомобильная, 15',
      'rating': 4.8,
      'discount': '10%',
      'distance': '2.1 км',
    },
    {
      'name': 'Chery Official',
      'address': 'пр. Технический, 42',
      'rating': 4.9,
      'discount': '15%',
      'distance': '3.5 км',
    },
    {
      'name': 'Geely Center',
      'address': 'ш. Восточное, 87',
      'rating': 4.7,
      'discount': '12%',
      'distance': '5.2 км',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar с заголовком
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            title: const Text(
              'Мой Гараж',
              style: TextStyle(
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
                              _selectedCar['brand'],
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
                                '799',
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
                              '${_selectedCar['mileage']} км',
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
                              _selectedCar['plate'],
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
                    // Расходы в октябре
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
                                'Расходы в октябре',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '12 500 ₽',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    size: 14,
                                    color: Colors.green.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '-8% к прошлому месяцу',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade600,
                                    ),
                                  ),
                                ],
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
                                'Следующее ТО',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'через 4 580 км',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.orange.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Прогноз: Дек 15',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange.shade600,
                                    ),
                                  ),
                                ],
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
                      label: 'Добавить запись',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddServiceScreen(car: _selectedCar),
                          ),
                        );
                      },
                    ),
                    _buildQuickAction(
                      key: const Key('sell_report_button'),
                      icon: Icons.description_outlined,
                      label: 'Отчет для продажи',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellReportScreen(car: _selectedCar),
                          ),
                        );
                      },
                    ),
                    _buildQuickAction(
                      key: const Key('partners_button'),
                      icon: Icons.car_repair_outlined,
                      label: 'Партнеры СТО',
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PartnersScreen(car: _selectedCar),
                          ),
                        );
                      },
                    ),
                    _buildQuickAction(
                      key: const Key('analytics_button'),
                      icon: Icons.insights_outlined,
                      label: 'Аналитика',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseAnalyticsScreen(car: _selectedCar),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // История работ
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'История работ',
                      style: TextStyle(
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
                      child: const Text(
                        'Все',
                        style: TextStyle(
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
                  children: _serviceHistory.map((service) {
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
                                color: service['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                service['icon'],
                                color: service['color'],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${service['date']} • ${service['place']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              service['price'],
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
                  child: const Text('Все записи'),
                ),
              ),

              // Партнерские СТО
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Партнерские СТО',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Запишись онлайн и получи скидку 10%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Список партнерских СТО
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: _partnerStations.map((station) {
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
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                ),
                              ),
                              child: const Icon(
                                Icons.directions_car,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    station['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    station['address'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.orange.shade500,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        station['rating'].toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        station['distance'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.green.shade100,
                                ),
                              ),
                              child: Text(
                                '-${station['discount']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 80),
            ]),
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
}