import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../models/models.dart';

class SellReportScreen extends StatelessWidget {
  final Car car;

  const SellReportScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Отчёт для продажи',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя плашка "Для владельца и покупателя"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                '  Для владельца и покупателя',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),

            // Шапка: авто и номер
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${car.displayName} • ${car.plate ?? 'Без номера'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    car.shortInfo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            ),

            // Карточка "Паспорт автомобиля"
            _buildSectionCard(
              title: 'Паспорт автомобиля',
              subtitle: 'Краткое досье по основным параметрам',
              child: Column(
                children: [
                  _buildInfoRow('Год выпуска', car.year),
                  _buildInfoRow('Текущий пробег', '${car.mileage?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ') ?? '—'} км'),
                  _buildInfoRow('Владелец', '1 владелец'),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Text(
                    'Данные на основе записей в сервисной книжке',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID отчёта: MJR-2024-118',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),

            // Индекс прозрачности
            _buildSectionCard(
              title: 'Индекс прозрачности',
              subtitle: 'Оценка полноты и честности истории обслуживания',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '0',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LinearProgressIndicator(
                            value: 0.82,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Text(
                        '100',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      '82',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Регулярное обслуживание: 14 подтверждённых записей за 2 года, без пропусков регламентных ТО.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Индекс учитывает частоту ТО, наличие чеков и пробег между визитами.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // История обслуживания (подтверждённые визиты)
            _buildSectionCard(
              title: 'История обслуживания',
              subtitle: 'Подтверждённые визиты на сервис',
              child: Column(
                children: [
                  _buildServiceRow(
                    date: '24.10.24',
                    mileage: '14 800 км',
                    works: 'TO-2, масла, фильтры',
                    service: 'Jetour Официальный...',
                  ),
                  const SizedBox(height: 12),
                  _buildServiceRow(
                    date: '15.09.24',
                    mileage: '12 300 км',
                    works: 'Замена торм. жидкости',
                    service: 'Garage #1 Сеть серв...',
                  ),
                  const SizedBox(height: 12),
                  _buildServiceRow(
                    date: '02.09.24',
                    mileage: '12 000 км',
                    works: 'Замена колёс (зима)',
                    service: 'Tire Shop Магазин ...',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Нет записей за более ранний период — добавьте фото чеков, чтобы поднять индекс прозрачности.',
                    style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                  ),
                ],
              ),
            ),

            // Финансовая аналитика
            _buildSectionCard(
              title: 'Финансовая аналитика',
              subtitle: 'Вложения в обслуживание и содержание',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Общая сумма вложений', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            const Text('128 400 ₽', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('за 2 года', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Средний чек', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            const Text('9 170 ₽', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Крупные ремонты', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            const Text('0 ₽', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            Text('Двигатель, коробка, кузов',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Расходники и ТО', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            const Text('100 200 ₽', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            Text('масла, фильтры, резина',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // График пробега
            _buildSectionCard(
              title: 'График пробега',
              subtitle: 'Динамика использования и аномалии',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'История выполнения пробега',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  _buildScaleIndicator(label: '10%', value: 0.1),
                  _buildScaleIndicator(label: '20%', value: 0.2),
                  _buildScaleIndicator(label: '30%', value: 0.3),
                  _buildScaleIndicator(label: '40%', value: 0.4),
                  _buildScaleIndicator(label: '50%', value: 0.5),
                  _buildScaleIndicator(label: '60%', value: 0.6),
                  _buildScaleIndicator(label: '70%', value: 0.7),
                  _buildScaleIndicator(label: '80%', value: 0.8),
                  _buildScaleIndicator(label: '90%', value: 0.9),
                  _buildScaleIndicator(label: '100%', value: 1.0),
                  const SizedBox(height: 8),
                  const Text(
                    'Ровный рост пробега без резких скачков. Аномалии в показаниях не обнаружено.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            // Отчёт для покупателя
            _buildSectionCard(
              title: 'Отчёт для покупателя',
              subtitle: 'Как вы будете делиться историей авто',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'История покупки',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  _buildScaleIndicator(label: '10%', value: 0.1),
                  _buildScaleIndicator(label: '20%', value: 0.2),
                  _buildScaleIndicator(label: '30%', value: 0.3),
                  _buildScaleIndicator(label: '40%', value: 0.4),
                  _buildScaleIndicator(label: '50%', value: 0.5),
                  _buildScaleIndicator(label: '60%', value: 0.6),
                  _buildScaleIndicator(label: '70%', value: 0.7),
                  _buildScaleIndicator(label: '80%', value: 0.8),
                  _buildScaleIndicator(label: '90%', value: 0.9),
                  _buildScaleIndicator(label: '100%', value: 1.0),
                ],
              ),
            ),

            // Почему отчёт важен при продаже
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Почему отчёт важен при продаже',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Покупатель видит прозрачную историю обслуживания, реальные пробеги и подтверждённые чеки. Это сокращает риск и повышает вероятность быстрой продажи.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Кнопка покупки отчёта
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: оплата и генерация PDF
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Разблокировать PDF и ссылку: 249 ₽ единоразово',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildServiceRow({
    required String date,
    required String mileage,
    required String works,
    required String service,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          width: 70,
          child: Text(mileage, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(works, style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(service, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScaleIndicator({required String label, required double value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}