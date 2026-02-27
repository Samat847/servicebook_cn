import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import '../widgets/background_scaffold.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  bool _autoBackupEnabled = true;
  String _selectedBackupProvider = 'local';
  bool _isBackingUp = false;
  bool _isRestoring = false;
  List<Map<String, dynamic>> _backupHistory = [];

  static const String _backupHistoryKey = 'backup_history';

  @override
  void initState() {
    super.initState();
    _loadBackupHistory();
  }

  Future<void> _loadBackupHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = prefs.getStringList(_backupHistoryKey) ?? [];
    final history = <Map<String, dynamic>>[];
    for (final s in historyStrings) {
      try {
        history.add(jsonDecode(s) as Map<String, dynamic>);
      } catch (e) {
        // Skip invalid entries
      }
    }
    setState(() {
      _backupHistory = history;
    });
  }

  Future<void> _saveBackupHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = _backupHistory.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_backupHistoryKey, historyStrings);
  }

  Future<void> _createBackup() async {
    setState(() => _isBackingUp = true);

    try {
      final cars = await CarStorage.loadCarsList();
      final expenses = await CarStorage.loadExpensesList();
      final documents = await CarStorage.loadDocumentsList();
      final profile = await CarStorage.loadUserProfile();

      final data = {
        'exportedAt': DateTime.now().toIso8601String(),
        'version': '1.0',
        'profile': profile.toJson(),
        'cars': cars.map((c) => c.toJson()).toList(),
        'expenses': expenses.map((e) => e.toJson()).toList(),
        'documents': documents.map((d) => d.toJson()).toList(),
      };

      final jsonString = jsonEncode(data);

      // Сохраняем в Documents через path_provider
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'avtoman_backup_$timestamp.json';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(jsonString);

      // Обновляем список backup history
      final entry = jsonEncode({
        'path': file.path,
        'date': DateTime.now().toIso8601String(),
        'size': '${(jsonString.length / 1024).toStringAsFixed(1)} KB',
        'status': 'success',
        'provider': 'local',
      });
      _backupHistory.insert(0, jsonDecode(entry));
      await _saveBackupHistory();

      // Поделиться файлом
      await Share.shareXFiles([XFile(file.path)], text: 'AvtoMAN backup');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка создания бэкапа: $e')),
        );
      }
    }

    setState(() => _isBackingUp = false);
  }

  Future<void> _restoreBackup() async {
    setState(() => _isRestoring = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        // Очистка текущих данных
        await CarStorage.clearAll();

        // Импорт cars
        final carsJson = data['cars'] as List<dynamic>? ?? [];
        for (final c in carsJson) {
          await CarStorage.saveCar(Car.fromJson(c as Map<String, dynamic>));
        }

        // Импорт expenses
        final expensesJson = data['expenses'] as List<dynamic>? ?? [];
        for (final e in expensesJson) {
          await CarStorage.saveExpense(
              Expense.fromJson(e as Map<String, dynamic>));
        }

        // Импорт documents
        final documentsJson = data['documents'] as List<dynamic>? ?? [];
        for (final d in documentsJson) {
          await CarStorage.saveDocument(
              Document.fromJson(d as Map<String, dynamic>));
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Данные восстановлены')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка восстановления: $e')),
        );
      }
    }

    setState(() => _isRestoring = false);
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
    return BackgroundScaffold(
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
    final dateStr = backup['date'] as String? ?? '';
    final date = dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null;
    final isSuccess = backup['status'] == 'success';
    final provider = (backup['provider'] as String? ?? 'local') == 'local' ? 'Локально' : 'Google Drive';

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
          date != null
              ? '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}'
              : 'Неизвестно',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '$provider • ${backup['size']}',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        trailing: TextButton(
          onPressed: _restoreBackup,
          child: const Text('Восстановить'),
        ),
      ),
    );
  }
}
