import 'package:flutter/material.dart';
import 'support_screen.dart';

class HelpAndFaqScreen extends StatefulWidget {
  const HelpAndFaqScreen({super.key});

  @override
  State<HelpAndFaqScreen> createState() => _HelpAndFaqScreenState();
}

class _HelpAndFaqScreenState extends State<HelpAndFaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': 'Начало работы',
      'icon': Icons.rocket_launch,
      'color': Colors.blue,
      'items': [
        {
          'question': 'Как добавить автомобиль?',
          'answer': 'Перейдите в раздел "Профиль" и нажмите на кнопку "Добавить автомобиль" в разделе "Мой гараж". Заполните все обязательные поля: марку, модель, год, госномер и пробег.',
        },
        {
          'question': 'Как редактировать данные автомобиля?',
          'answer': 'Откройте раздел "Мой гараж", найдите нужный автомобиль и нажмите на него. В открывшемся экране нажмите на иконку редактирования в правом верхнем углу.',
        },
      ],
    },
    {
      'title': 'Записи об обслуживании',
      'icon': Icons.build,
      'color': Colors.orange,
      'items': [
        {
          'question': 'Как добавить запись о ТО?',
          'answer': 'На главном экране нажмите на кнопку "Добавить запись". Выберите тип работ, введите дату, пробег и стоимость. Вы также можете добавить фото чеков.',
        },
        {
          'question': 'Как редактировать запись?',
          'answer': 'Откройте экран "Все записи" или "История обслуживания", найдите нужную запись и нажмите на неё. В открывшемся окне нажмите кнопку "Редактировать".',
        },
        {
          'question': 'Как удалить запись?',
          'answer': 'Откройте детали записи, нажмите кнопку "Удалить" и подтвердите действие. Удаленную запись нельзя восстановить.',
        },
      ],
    },
    {
      'title': 'Документы',
      'icon': Icons.description,
      'color': Colors.green,
      'items': [
        {
          'question': 'Как добавить документ?',
          'answer': 'В разделе "Профиль" перейдите в раздел "Документы" и нажмите "Все". Затем нажмите кнопку "Добавить" и выберите тип документа.',
        },
        {
          'question': 'Какие документы можно добавить?',
          'answer': 'Вы можете добавить: водительское удостоверение, СТС, ПТС, ОСАГО, КАСКО, диагностическую карту и другие документы.',
        },
      ],
    },
    {
      'title': 'Данные и резервные копии',
      'icon': Icons.cloud,
      'color': Colors.purple,
      'items': [
        {
          'question': 'Как экспортировать данные?',
          'answer': 'Перейдите в настройки и выберите пункт "Управление данными". Там вы можете экспортировать все данные в формат CSV, PDF или JSON.',
        },
        {
          'question': 'Как настроить автоматическое резервное копирование?',
          'answer': 'В настройках выберите "Резервные копии" и включите "Автоматическое резервное копирование". Выберите облачное хранилище (Google Drive).',
        },
      ],
    },
    {
      'title': 'Аналитика',
      'icon': Icons.insights,
      'color': Colors.teal,
      'items': [
        {
          'question': 'Как посмотреть расходы?',
          'answer': 'На главном экране нажмите на кнопку "Аналитика". Вы увидите статистику расходов по периодам и категориям.',
        },
        {
          'question': 'Какие периоды доступны для аналитики?',
          'answer': 'Доступны периоды: месяц, 3 месяца, год и всё время. Вы можете переключаться между ними для сравнения расходов.',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredFaq {
    if (_searchQuery.isEmpty) return _faqCategories;

    final query = _searchQuery.toLowerCase();
    return _faqCategories.map((category) {
      final filteredItems = (category['items'] as List<Map<String, dynamic>>)
          .where((item) {
        return item['question'].toString().toLowerCase().contains(query) ||
            item['answer'].toString().toLowerCase().contains(query);
      }).toList();

      return {
        ...category,
        'items': filteredItems,
      };
    }).where((category) => (category['items'] as List).isNotEmpty).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Помощь и FAQ',
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
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по вопросам',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Contact support button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupportScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('Связаться с поддержкой'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // FAQ list
          Expanded(
            child: _filteredFaq.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ничего не найдено',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Попробуйте изменить запрос',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredFaq.length,
                    itemBuilder: (context, index) {
                      final category = _filteredFaq[index];
                      return _buildCategorySection(category);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> category) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (category['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            category['icon'] as IconData,
            color: category['color'] as Color,
          ),
        ),
        title: Text(
          category['title'] as String,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${(category['items'] as List).length} вопросов',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        children: (category['items'] as List<Map<String, dynamic>>)
            .map((item) => _buildFaqItem(item))
            .toList(),
      ),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(
          item['question'] as String,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Text(
            item['answer'] as String,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
