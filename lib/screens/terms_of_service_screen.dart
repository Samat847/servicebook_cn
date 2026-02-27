import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Условия использования',
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
                  Icon(Icons.gavel_outlined, color: Colors.blue.shade700),
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
                          'Действует с 1 октября 2024',
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

            // Terms content
            _buildTermsSection(
              '1. Принятие условий',
              'Загружая, устанавливая или используя приложение AvtoMAN ("Приложение"), вы соглашаетесь соблюдать настоящие Условия использования. Если вы не согласны с этими условиями, пожалуйста, не используйте Приложение.',
            ),

            _buildTermsSection(
              '2. Описание услуг',
              'AvtoMAN предоставляет пользователям инструменты для:\n\n'
                  '• Ведения истории обслуживания автомобилей.\n'
                  '• Отслеживания расходов на автомобиль.\n'
                  '• Хранения документов, связанных с автомобилем.\n'
                  '• Получения напоминаний о предстоящем ТО.\n'
                  '• Поиска партнерских СТО.',
            ),

            _buildTermsSection(
              '3. Регистрация и аккаунт',
              'Для использования Приложения может потребоваться регистрация. Вы обязуетесь:\n\n'
                  '• Предоставить точную и актуальную информацию.\n'
                  '• Сохранять конфиденциальность ваших учетных данных.\n'
                  '• Немедленно уведомить нас о любом несанкционированном использовании.\n'
                  '• Не создавать более одного аккаунта без разрешения.',
            ),

            _buildTermsSection(
              '4. Подписка и платежи',
              'Приложение предлагает как бесплатные, так и платные функции:\n\n'
                  '• Базовая версия доступна бесплатно с ограниченным функционалом.\n'
                  '• Premium подписка открывает доступ ко всем функциям.\n'
                  '• Подписка автоматически продлевается, если не отменена.\n'
                  '• Возврат средств осуществляется согласно политике магазина приложений.',
            ),

            _buildTermsSection(
              '5. Права интеллектуальной собственности',
              'Все права на Приложение, включая дизайн, код, логотипы и контент, принадлежат компании AvtoMAN или ее лицензиарам. Пользователям предоставляется ограниченная, неисключительная, непередаваемая лицензия на использование Приложения.',
            ),

            _buildTermsSection(
              '6. Поведение пользователя',
              'Запрещается:\n\n'
                  '• Использовать Приложение для незаконных целей.\n'
                  '• Пытаться получить несанкционированный доступ к системам.\n'
                  '• Распространять вредоносный код.\n'
                  '• Нарушать права других пользователей.\n'
                  '• Использовать Приложение способом, который может повредить его работу.',
            ),

            _buildTermsSection(
              '7. Отказ от ответственности',
              'Приложение предоставляется "как есть". Мы не гарантируем:\n\n'
                  '• Непрерывную, безопасную, безошибочную работу.\n'
                  '• Точность рекомендаций по обслуживанию.\n'
                  '• Сохранность данных при отсутствии резервного копирования.\n'
                  '• Доступность партнерских СТО.',
            ),

            _buildTermsSection(
              '8. Ограничение ответственности',
              'В максимальной степени, разрешенной законом, компания AvtoMAN не несет ответственности за:\n\n'
                  '• Косвенные, случайные или штрафные убытки.\n'
                  '• Потерю данных или прибыли.\n'
                  '• Ущерб, превышающий сумму, уплаченную за услуги за последние 12 месяцев.',
            ),

            _buildTermsSection(
              '9. Прекращение использования',
              'Мы можем приостановить или прекратить ваш доступ к Приложению в случае:\n\n'
                  '• Нарушения настоящих Условий использования.\n'
                  '• Мошеннической деятельности.\n'
                  '• Долгосрочной неактивности аккаунта.\n'
                  '• По нашему усмотрению с предварительным уведомлением.',
            ),

            _buildTermsSection(
              '10. Изменения условий',
              'Мы оставляем за собой право изменять эти Условия в любое время. Значительные изменения будут анонсированы через Приложение или электронную почту. Продолжение использования после изменений означает принятие новых условий.',
            ),

            _buildTermsSection(
              '11. Применимое право',
              'Настоящие Условия регулируются законодательством Российской Федерации. Все споры подлежат разрешению в судах по месту нахождения компании.',
            ),

            _buildTermsSection(
              '12. Контакты',
              'Если у вас есть вопросы по поводу данных Условий использования, свяжитесь с нами:\n\n'
                  'Email: legal@servicebook.ru\n'
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
                  'Я согласен с условиями',
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

  Widget _buildTermsSection(String title, String content) {
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
