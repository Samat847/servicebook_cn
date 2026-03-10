import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/background_scaffold.dart';

class ExpertScreen extends StatelessWidget {
  const ExpertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BackgroundScaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              l10n?.expertTitle ?? 'Эксперт',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              l10n?.expertSubtitle ?? 'Чат по китайским автомобилям • AI-режим',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _buildExpertMessage(
                  context,
                  text: l10n?.expertWelcomeMessage ??
                      'Привет! Я AI-эксперт по китайским автомобилям.\n\nЯ могу помочь вам с:\n• Подбором масла и расходников\n• Расшифровкой ошибок OBD\n• Советами по ТО и ремонту\n• Анализом типичных проблем',
                  showAvatar: true,
                ),
                const SizedBox(height: 16),
                _buildUserMessage(
                  context,
                  text: l10n?.expertUserQuestion ??
                      'Какое масло лучше заливать в Chery Tiggo 7 Pro?',
                ),
                const SizedBox(height: 16),
                _buildExpertMessage(
                  context,
                  text: l10n?.expertAnswer ??
                      'Для Chery Tiggo 7 Pro рекомендую:\n\n• Моторное масло: 5W-30 (полусинтетика или синтетика)\n• Объём: ~4.5 литра (с фильтром)\n• Стандарт: API SN/SP, ACEA C3\n• Примеры: Shell Helix HX7, Mobil Super 3000, Gazpromneft Premium N',
                  showAvatar: true,
                  chips: [
                    l10n?.expertChipOil ?? 'Масло для Chery',
                    l10n?.expertChipService ?? 'Когда следующее ТО?',
                  ],
                ),
                const SizedBox(height: 16),
                _buildQuickSuggestion(
                  context,
                  icon: Icons.error_outline,
                  text: l10n?.expertQuickDecode ??
                      'Расшифровать код ошибки P0171',
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: l10n?.expertInputHint ??
                                    'Опишите вопрос или вставьте текст ошибки с панели',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.send,
                            color: Colors.grey.shade400,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Text(
                      l10n?.expertFooterNote ??
                          'Эксперт учитывает историю расходов и ТО из раздела "Мой гараж"',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertMessage(
    BuildContext context, {
    required String text,
    required bool showAvatar,
    List<String>? chips,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAvatar)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text(
                'Э',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 36),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              if (chips != null && chips.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips
                      .map((chip) => _buildChip(context, chip))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildUserMessage(BuildContext context, {required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 48),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.person,
            color: Colors.grey.shade600,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        // Placeholder - no functionality yet
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF1E88E5)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1E88E5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSuggestion(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return InkWell(
      onTap: () {
        // Placeholder - no functionality yet
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF1E88E5),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
