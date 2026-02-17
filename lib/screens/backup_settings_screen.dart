import 'package:flutter/material.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  bool _autoBackupEnabled = true;
  String _selectedBackupProvider = 'google_drive';
  bool _isBackingUp = false;
  bool _isRestoring = false;

  final List<Map<String, dynamic>> _backupHistory = [
    {
      'date': DateTime(2024, 10, 24, 14, 30),
      'size': '2.4 MB',
      'status': 'success',
      'provider': 'google_drive',
    },
    {
      'date': DateTime(2024, 10, 17, 9, 15),
      'size': '2.3 MB',
      'status': 'success',
      'provider': 'google_drive',
    },
    {
      'date': DateTime(2024, 10, 10, 16, 45),
      'size': '2.1 MB',
      'status': 'success',
      'provider': 'local',
    },
  ];

  Future<void> _createBackup() async {
    setState(() => _isBackingUp = true);

    // TODO: Implement actual backup
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isBackingUp = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Резервная копия создана')),
      );
    }
  }

  Future<void> _restoreBackup() async {
    setState(() => _isRestoring = true);

    // TODO: Implement actual restore
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRestoring = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные восстановлены')),
      );
    }
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Восстановить из резервной копии?'),
        content: const Text(
          'Текущие данные будут заменены данными из резервной копии. Продолжить?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _restoreBackup();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Восстановить'),
          ),
        ],
      ),
    );
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
          'Резервные копии',
          style: TextStyle(
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

          // Auto backup toggle
          _buildSectionHeader('Настройки'),
          _buildSwitchTile(
            icon: Icons.cloud_upload,
            title: 'Автоматическое резервное копирование',
            subtitle: 'Создавать копию каждую неделю',
            value: _autoBackupEnabled,
            onChanged: (value) {
              setState(() {
                _autoBackupEnabled = value;
              });
            },
          ),

          const SizedBox(height: 8),

          // Cloud provider selection
          _buildSectionHeader('Облачное хранилище'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.cloud, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Google Drive',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Подключено',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  value: 'google_drive',
                  groupValue: _selectedBackupProvider,
                  onChanged: (value) {
                    setState(() {
                      _selectedBackupProvider = value!;
                    });
                  },
                  activeColor: const Color(0xFF1E88E5),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                RadioListTile<String>(
                  title: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.cloud_off, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Локальное хранилище',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'На устройстве',
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
                  value: 'local',
                  groupValue: _selectedBackupProvider,
                  onChanged: (value) {
                    setState(() {
                      _selectedBackupProvider = value!;
                    });
                  },
                  activeColor: const Color(0xFF1E88E5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Actions
          _buildSectionHeader('Действия'),
          _buildSettingsTile(
            icon: Icons.backup,
            title: 'Создать резервную копию сейчас',
            subtitle: _isBackingUp ? 'Создание...' : 'Последняя: 24 октября',
            onTap: _isBackingUp ? null : _createBackup,
            trailing: _isBackingUp
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          _buildSettingsTile(
            icon: Icons.restore,
            title: 'Восстановить из резервной копии',
            subtitle: _isRestoring ? 'Восстановление...' : 'Выбрать файл',
            onTap: _isRestoring ? null : _showRestoreDialog,
            trailing: _isRestoring
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),

          const SizedBox(height: 8),

          // History
          _buildSectionHeader('История резервных копий'),
          ..._backupHistory.map((backup) => _buildBackupHistoryCard(backup)),

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
    required VoidCallback? onTap,
    Widget? trailing,
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
        trailing: trailing ??
            Icon(
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

  Widget _buildBackupHistoryCard(Map<String, dynamic> backup) {
    final date = backup['date'] as DateTime;
    final isSuccess = backup['status'] == 'success';
    final provider = backup['provider'] == 'google_drive' ? 'Google Drive' : 'Локально';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '$provider • ${backup['size']}',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        trailing: TextButton(
          onPressed: () => _showRestoreDialog(),
          child: const Text('Восстановить'),
        ),
      ),
    );
  }
}
