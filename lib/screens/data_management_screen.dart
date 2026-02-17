import 'package:flutter/material.dart';

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  bool _isClearing = false;

  // Mock storage usage
  final double _totalStorage = 1024.0; // MB
  final double _usedStorage = 156.5; // MB

  Future<void> _exportData(String format) async {
    setState(() => _isExporting = true);

    // TODO: Implement actual export
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isExporting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Данные экспортированы в формат $format')),
      );
    }
  }

  Future<void> _importData() async {
    setState(() => _isImporting = true);

    // TODO: Implement actual import
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isImporting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные успешно импортированы')),
      );
    }
  }

  Future<void> _clearAllData() async {
    setState(() => _isClearing = true);

    // TODO: Implement actual clear
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isClearing = false);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Все данные удалены')),
      );
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Экспорт данных'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('CSV (Excel)'),
              subtitle: const Text('Таблица с данными'),
              onTap: () {
                Navigator.pop(context);
                _exportData('CSV');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.red),
              title: const Text('PDF'),
              subtitle: const Text('Отчет в PDF формате'),
              onTap: () {
                Navigator.pop(context);
                _exportData('PDF');
              },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.orange),
              title: const Text('JSON'),
              subtitle: const Text('Данные в JSON формате'),
              onTap: () {
                Navigator.pop(context);
                _exportData('JSON');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить все данные?'),
        content: const Text(
          'Все данные будут безвозвратно удалены. Это действие нельзя отменить. Продолжить?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storagePercent = (_usedStorage / _totalStorage * 100).clamp(0, 100);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          'Управление данными',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isClearing
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 16),

                // Storage usage
                _buildSectionHeader('Использование хранилища'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_usedStorage.toStringAsFixed(1)} MB',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'из ${_totalStorage.toStringAsFixed(0)} MB',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: storagePercent / 100,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            storagePercent > 80
                                ? Colors.red
                                : storagePercent > 50
                                    ? Colors.orange
                                    : const Color(0xFF1E88E5),
                          ),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Использовано ${storagePercent.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Export section
                _buildSectionHeader('Экспорт данных'),
                _buildSettingsTile(
                  icon: Icons.file_upload,
                  title: 'Экспортировать данные',
                  subtitle: _isExporting ? 'Экспорт...' : 'CSV, PDF, JSON',
                  onTap: _isExporting ? null : _showExportDialog,
                  trailing: _isExporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),

                const SizedBox(height: 8),

                // Import section
                _buildSectionHeader('Импорт данных'),
                _buildSettingsTile(
                  icon: Icons.file_download,
                  title: 'Импортировать данные',
                  subtitle: _isImporting ? 'Импорт...' : 'Из файла CSV или JSON',
                  onTap: _isImporting ? null : _importData,
                  trailing: _isImporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),

                const SizedBox(height: 8),

                // Cache section
                _buildSectionHeader('Кэш'),
                _buildSettingsTile(
                  icon: Icons.delete_sweep,
                  title: 'Очистить кэш',
                  subtitle: 'Освободит 12.5 MB',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Кэш очищен')),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // Danger zone
                _buildSectionHeader('Опасная зона'),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 0,
                  color: Colors.red.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
                    title: Text(
                      'Удалить все данные',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Удалит все автомобили и записи',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade600,
                      ),
                    ),
                    onTap: _showClearDataDialog,
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
}
