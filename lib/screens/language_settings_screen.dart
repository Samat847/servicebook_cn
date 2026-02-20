import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  static const List<Map<String, String>> _languages = [
    {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'kk', 'name': 'Қазақша', 'flag': '🇰🇿'},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final selectedCode = localeProvider.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          l10n?.selectLanguageTitle ?? 'Язык',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n?.selectLanguage ?? 'Выберите язык интерфейса',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                final isSelected = selectedCode == language['code'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF1E88E5)
                          : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1E88E5).withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          language['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    title: Text(
                      language['name']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF1E88E5)
                            : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF1E88E5),
                          )
                        : Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.grey.shade400,
                          ),
                    onTap: () {
                      context
                          .read<LocaleProvider>()
                          .setLocale(Locale(language['code']!));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
