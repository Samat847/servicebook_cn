import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Политика конфиденциальности',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Version info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Версия 1.0',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          'Последнее обновление: 1 октября 2024',
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
            ),

            const SizedBox(height: 16),

            // Policy content
            _buildPolicySection(
              '1. Общие положения',
              'Настоящая Политика конфиденциальности описывает, как приложение AvtoMAN ("мы", "нас" или "наше") собирает, использует и защищает информацию пользователей при использовании нашего мобильного приложения для учета обслуживания автомобилей.',
            ),

            _buildPolicySection(
              '2. Сбор информации',
              'Мы собираем следующую информацию:\n\n'
                  '• Информация об автомобилях: марка, модель, год выпуска, VIN, государственный номер, пробег.\n'
                  '• История обслуживания: записи о ТО, ремонтах, запчастях и расходах.\n'
                  '• Документы: фотографии водительских удостоверений, СТС, страховых полисов.\n'
                  '• Личная информация: имя пользователя, город, контактные данные (при регистрации).',
            ),

            _buildPolicySection(
              '3. Использование информации',
              'Собранная информация используется для:\n\n'
                  '• Ведения истории обслуживания автомобилей.\n'
                  '• Напоминаний о предстоящем ТО.\n'
                  '• Аналитики расходов на автомобиль.\n'
                  '• Создания отчетов для продажи автомобиля.\n'
                  '• Улучшения работы приложения.',
            ),

            _buildPolicySection(
              '4. Хранение данных',
              'Все данные хранятся локально на устройстве пользователя, если не включено облачное резервное копирование. При использовании функции резервного копирования данные шифруются и передаются в защищенном виде в выбранное облачное хранилище (Google Drive, iCloud).',
            ),

            _buildPolicySection(
              '5. Защита данных',
              'Мы принимаем следующие меры для защиты ваших данных:\n\n'
                  '• Шифрование данных при передаче и хранении.\n'
                  '• Возможность использования биометрической аутентификации.\n'
                  '• Регулярное обновление приложения для исправления уязвимостей.\n'
                  '• Анонимизация данных при аналитике использования.',
            ),

            _buildPolicySection(
              '6. Передача данных третьим лицам',
              'Мы не продаем и не передаем ваши личные данные третьим лицам, за исключением:\n\n'
                  '• Партнерских СТО (только при вашем явном согласии).\n'
                  '• Облачных провайдеров (для резервного копирования).\n'
                  '• Случаев, предусмотренных законодательством.',
            ),

            _buildPolicySection(
              '7. Права пользователя',
              'Вы имеете право:\n\n'
                  '• Получить доступ к своим данным.\n'
                  '• Исправить неточные данные.\n'
                  '• Удалить все свои данные.\n'
                  '• Экспортировать данные в стандартных форматах.\n'
                  '• Отказаться от сбора определенных данных.',
            ),

            _buildPolicySection(
              '8. Файлы cookie и аналитика',
              'Приложение использует анонимную аналитику для улучшения пользовательского опыта. Эти данные не содержат личной информации и используются только в обобщенном виде.',
            ),

            _buildPolicySection(
              '9. Изменения в политике',
              'Мы можем обновлять эту Политику конфиденциальности время от времени. При значительных изменениях мы уведомим вас через приложение или электронную почту.',
            ),

            _buildPolicySection(
              '10. Контакты',
              'Если у вас есть вопросы по поводу данной Политики конфиденциальности, свяжитесь с нами:\n\n'
                  'Email: privacy@avtoman.ru\n'
                  'Телефон: 8-800-123-45-67\n'
                  'Адрес: г. Москва, ул. Автомобильная, 1',
            ),

            const SizedBox(height: 20),

            // Agreement button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Я понимаю и принимаю',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  Widget _buildPolicySection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
