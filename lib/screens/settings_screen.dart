import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'profile_edit_screen.dart';
import 'security_settings_screen.dart';
import 'data_management_screen.dart';
import 'backup_settings_screen.dart';
import 'help_and_faq_screen.dart';
import 'support_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'about_screen.dart';
import 'language_settings_screen.dart';
import '../services/car_storage.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoBackupEnabled = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'kk':
        return 'Қазақша';
      default:
        return 'Русский';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    
    return BackgroundScaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          l10n?.settings ?? 'Настройки',
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
          const SizedBox(height: 8),

          _buildSectionHeader(l10n?.personalData ?? 'Личные данные'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: l10n?.edit ?? 'Редактировать профиль',
            subtitle: l10n?.personalDataSubtitle ?? 'Имя, город, телефон',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileEditScreen())).then((_) => setState(() {})),
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: l10n?.security ?? 'Безопасность',
            subtitle: l10n?.securitySubtitle ?? 'Пароль, двухфакторная аутентификация',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecuritySettingsScreen())),
          ),
          const SizedBox(height: 8),

          _buildSectionHeader(l10n?.settings ?? 'Приложение'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: l10n?.notifications ?? 'Уведомления',
            subtitle: 'Push-уведомления о сервисах',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: l10n?.darkMode ?? 'Темная тема',
            subtitle: 'Включить темный режим',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: l10n?.language ?? 'Язык',
            subtitle: _getLanguageName(localeProvider.locale.languageCode),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSettingsScreen())),
          ),
          _buildSwitchTile(
            icon: Icons.cloud_upload_outlined,
            title: l10n?.backup ?? 'Автоматическое резервное копирование',
            subtitle: 'Сохранять данные в облако',
            value: _autoBackupEnabled,
            onChanged: (value) {
              setState(() {
                _autoBackupEnabled = value;
              });
            },
          ),
          const SizedBox(height: 8),

          _buildSectionHeader(l10n?.dataManagement ?? 'Данные'),
          _buildSettingsTile(
            icon: Icons.storage_outlined,
            title: l10n?.dataManagement ?? 'Управление данными',
            subtitle: l10n?.dataManagementSubtitle ?? 'Экспорт, импорт, очистка',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DataManagementScreen())),
          ),
          _buildSettingsTile(
            icon: Icons.backup_outlined,
            title: l10n?.backup ?? 'Резервные копии',
            subtitle: l10n?.backupSubtitle ?? 'История бэкапов',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n?.backupComingSoon ?? 'Функция резервного копирования появится позже'),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          _buildSectionHeader(l10n?.support ?? 'Поддержка'),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: l10n?.helpAndFaq ?? 'Помощь и FAQ',
            subtitle: l10n?.helpAndFaqSubtitle ?? 'Часто задаваемые вопросы',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpAndFaqScreen())),
          ),
          _buildSettingsTile(
            icon: Icons.contact_support_outlined,
            title: l10n?.support ?? 'Связаться с поддержкой',
            subtitle: l10n?.supportSubtitle ?? 'Написать нам',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen())),
          ),
          _buildSettingsTile(
            icon: Icons.star_outline,
            title: l10n?.about ?? 'Оценить приложение',
            subtitle: l10n?.rateAppSubtitle ?? 'Оставить отзыв в магазине',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Спасибо за ваш отзыв!')),
              );
            },
          ),
          const SizedBox(height: 8),

          _buildSectionHeader(l10n?.about ?? 'О приложении'),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: l10n?.privacyPolicy ?? 'Политика конфиденциальности',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
          ),
          _buildSettingsTile(
            icon: Icons.gavel_outlined,
            title: l10n?.termsOfService ?? 'Условия использования',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsOfServiceScreen())),
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: l10n?.about ?? 'О приложении',
            subtitle: '${l10n?.version ?? 'Версия'} $_appVersion',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 0,
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade700),
                title: Text(
                  l10n?.logoutButton ?? 'Выйти из аккаунта',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: _showLogoutDialog,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.blue.shade700),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              )
            : null,
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF1E88E5),
      ),
    );
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.logoutConfirm ?? 'Выйти из аккаунта?'),
        content: Text(l10n?.logoutConfirmText ?? 'Все данные будут сохранены на устройстве.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await CarStorage.saveAuthStatus(false);
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n?.logout ?? 'Выйти'),
          ),
        ],
      ),
    );
  }
}
