import 'package:flutter/material.dart';
import 'service_history_screen.dart';
import 'expense_analytics_screen.dart';
import 'sell_report_screen.dart';
import 'insurance_screen.dart';
import 'documents_screen.dart';

class CarDetailScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const CarDetailScreen({super.key, required this.car});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Мой Автомобиль',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified,
                  size: 16,
                  color: Colors.green.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  'На гарантии',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка автомобиля
            Container(
              margin: const EdgeInsets.all(16),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E88E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          color: Color(0xFF1E88E5),
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.car['brand'] ?? 'Geely',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.car['model'] ?? 'Monjaro',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.car['plate'] ?? 'A 777 AA',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '799',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  // Пробег и расходы
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoColumn(
                          icon: Icons.speed,
                          label: 'Пробег',
                          value: '${widget.car['mileage'] ?? '15 420'} км',
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          icon: Icons.attach_money,
                          label: 'Расходы (Окт)',
                          value: '12 500 ₽',
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Следующее ТО',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'через 4 580 км',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Прогноз: 15 Дек',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // История обслуживания
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                key: const Key('service_history_button'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceHistoryScreen(car: widget.car),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'История обслуживания',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          '3 записи',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildServiceRecord(
                    title: 'Плановое ТО-1',
                    date: '24 Окт 2024',
                    mileage: '15 200 км',
                    price: '18 400 ₽',
                    color: Colors.blue,
                  ),
                  _buildServiceRecord(
                    title: 'Замена тормозной жидкости',
                    date: '15 Сен 2024',
                    mileage: '12 800 км',
                    price: '3 200 ₽',
                    color: Colors.orange,
                  ),
                  _buildServiceRecord(
                    title: 'Покупка зимней резины',
                    date: '02 Сен 2024',
                    mileage: '12 700 км',
                    price: '42 000 ₽',
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                key: const Key('all_records_button'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceHistoryScreen(car: widget.car),
                    ),
                  );
                },
                child: const Text('Все записи'),
              ),
            ),

            // Документы и СТС
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Документы и СТС',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      'Истекает 2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'СТС',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Серия 99 АА №123456',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DocumentsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Аналитика расходов
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Аналитика расходов',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    key: const Key('analytics_details_button'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpenseAnalyticsScreen(car: widget.car),
                        ),
                      );
                    },
                    icon: const Icon(Icons.insights, size: 18),
                    label: const Text('Детали'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Всего за год',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '124 600 ₽',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  size: 14,
                                  color: Colors.red.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '+12% к прошлому году',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade600,
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
                  Expanded(
                    child: Card(
                      elevation: 1,
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
                                const Text(
                                  'Страхование',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'ОСАГО',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '8 500 ₽',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const InsuranceScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(double.infinity, 36),
                                ),
                                child: const Text('Оформить'),
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

            // Подготовка к продаже — с переходом на отчёт
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.sell,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Подготовить к продаже',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Сформировать отчет и оценить стоимость',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('sell_report_button'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellReportScreen(car: widget.car),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: const Text(
                            'Сформировать отчет и оценить стоимость',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRecord({
    required String title,
    required String date,
    required String mileage,
    required String price,
    required Color color,
  }) {
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.build,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                        date,
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
                        mileage,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}