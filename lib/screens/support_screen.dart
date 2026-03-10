import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../widgets/background_scaffold.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  
  final String _supportEmail = 'support@avtoman.app';

  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'Как добавить автомобиль?',
      'answer': 'Перейдите в раздел "Профиль" и нажмите на кнопку "Добавить автомобиль" в разделе "Мой гараж". Заполните все обязательные поля: марку, модель, год, госномер и пробег.',
    },
    {
      'question': 'Как редактировать запись об обслуживании?',
      'answer': 'Откройте экран "Все записи" или "История обслуживания", найдите нужную запись и нажмите на неё. В открывшемся окне нажмите кнопку "Редактировать".',
    },
    {
      'question': 'Как экспортировать данные?',
      'answer': 'Перейдите в настройки и выберите пункт "Управление данными". Там вы можете экспортировать все данные в формат CSV или PDF.',
    },
    {
      'question': 'Как удалить автомобиль?',
      'answer': 'В разделе "Профиль" найдите нужный автомобиль в разделе "Мой гараж". Нажмите на иконку меню (три точки) в правом верхнем углу карточки автомобиля и выберите "Удалить".',
    },
    {
      'question': 'Как настроить уведомления?',
      'answer': 'Откройте настройки приложения и найдите раздел "Уведомления". Там вы можете включить или отключить push-уведомления о предстоящих ТО и других событиях.',
    },
    {
      'question': 'Как изменить язык приложения?',
      'answer': 'В настройках приложения выберите пункт "Язык" и выберите нужный язык из списка. Доступны русский, английский и казахский языки.',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=AvtoMAN Support',
    );
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось открыть почтовое приложение. Напишите на $_supportEmail'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BackgroundScaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          l10n?.support ?? 'Связаться с поддержкой',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Contact by email
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.email, color: Colors.blue.shade700),
              ),
              title: const Text(
                'Написать на email',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(_supportEmail),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
              onTap: _openEmail,
            ),
          ),

          // FAQ section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              l10n?.helpAndFaq ?? 'Помощь и FAQ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          ExpansionPanelList.radio(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            children: _faqItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return ExpansionPanelRadio(
                value: index,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      item['question'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    item['answer'] as String,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
