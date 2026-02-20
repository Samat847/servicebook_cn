import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';
import 'auth_screen.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;
  bool _isLoading = false;
  bool _hasPasswordAuth = false;
  String? _lastPasswordChange;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPasswordAuth();
  }

  Future<void> _checkPasswordAuth() async {
    final hasPassword = await AuthService.isPasswordAuth();
    setState(() {
      _hasPasswordAuth = hasPassword;
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final l10n = AppLocalizations.of(context);
    
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n?.error ?? 'Заполните все поля')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n?.passwordsDoNotMatch ?? 'Пароли не совпадают')),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n?.passwordTooShort ?? 'Пароль должен содержать минимум 6 символов')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthService.changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.passwordChanged ?? 'Пароль успешно изменён'),
            backgroundColor: Colors.green,
          ),
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.oldPasswordIncorrect ?? 'Неверный текущий пароль'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.changePassword ?? 'Изменить пароль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.currentPassword ?? 'Текущий пароль',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.newPassword ?? 'Новый пароль',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.confirmPassword ?? 'Подтвердите пароль',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _changePassword();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)?.save ?? 'Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          l10n?.security ?? 'Безопасность',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 16),

                _buildSectionHeader(l10n?.personalData ?? 'Пароль'),
                _buildSettingsTile(
                  icon: Icons.lock_outline,
                  title: l10n?.changePassword ?? 'Изменить пароль',
                  subtitle: _lastPasswordChange ?? (l10n?.securitySubtitle ?? 'Последнее изменение: никогда'),
                  enabled: _hasPasswordAuth,
                  onTap: _hasPasswordAuth ? _showChangePasswordDialog : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Смена пароля доступна только для пользователей, вошедших по логину и паролю'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                _buildSectionHeader(l10n?.notifications ?? 'Биометрия'),
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Биометрический вход',
                  subtitle: 'Использовать отпечаток или Face ID',
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value ? 'Биометрия включена' : 'Биометрия отключена'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                _buildSectionHeader('Двухфакторная аутентификация'),
                _buildSwitchTile(
                  icon: Icons.security,
                  title: 'Включить 2FA',
                  subtitle: 'Дополнительный уровень защиты',
                  value: _twoFactorEnabled,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorEnabled = value;
                    });
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('2FA будет настроена позже'),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 8),

                _buildSectionHeader('Активные сессии'),
                _buildSettingsTile(
                  icon: Icons.devices,
                  title: 'Управление сессиями',
                  subtitle: '1 активная сессия',
                  onTap: () {
                    _showSessionsDialog();
                  },
                ),

                const SizedBox(height: 8),

                _buildSectionHeader('Опасная зона'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 0,
                  color: Colors.red.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red.shade700),
                    title: Text(
                      'Завершить все сессии',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Выйти со всех устройств',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade600,
                      ),
                    ),
                    onTap: _showLogoutAllDialog,
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
    bool enabled = true,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: enabled ? Colors.blue.shade700 : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w500,
            color: enabled ? Colors.black : Colors.grey,
          ),
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
        onTap: enabled ? onTap : null,
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

  void _showSessionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Активные сессии'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.green),
              title: const Text('Текущее устройство'),
              subtitle: const Text('Android • Сейчас'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showLogoutAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершить все сессии?'),
        content: const Text(
          'Вы будете выведены из аккаунта на всех устройствах. Продолжить?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.logout();
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
            child: const Text('Завершить'),
          ),
        ],
      ),
    );
  }
}
