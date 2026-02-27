import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  void _openWebsite() {
    // TODO: Implement URL launcher
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Открываем сайт...')),
    );
  }

  void _openSocialMedia(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Открываем $platform...')),
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
          'О приложении',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // App logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // App name
            const Text(
              'AvtoMAN',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),

            const SizedBox(height: 8),

            // Version
            Text(
              'Версия $_appVersion ($_buildNumber)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            Text(
              'Учет обслуживания вашего автомобиля',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 32),

            // Info cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.description,
                    title: 'Описание',
                    content:
                        'AvtoMAN — это удобное приложение для ведения истории обслуживания автомобилей. Сохраняйте записи о ТО, отслеживайте расходы, храните документы и получайте напоминания о предстоящих работах.',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.code,
                    title: 'Разработчик',
                    content: 'AvtoMAN Team\n© 2024 Все права защищены',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.card_membership,
                    title: 'Лицензия',
                    content: 'Проприетарное программное обеспечение.\nИспользование регулируется Условиями использования.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Social links
            const Text(
              'Следите за нами',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  icon: Icons.language,
                  label: 'Сайт',
                  color: Colors.blue,
                  onTap: _openWebsite,
                ),
                const SizedBox(width: 16),
                _buildSocialButton(
                  icon: Icons.telegram,
                  label: 'Telegram',
                  color: const Color(0xFF0088CC),
                  onTap: () => _openSocialMedia('Telegram'),
                ),
                const SizedBox(width: 16),
                _buildSocialButton(
                  icon: Icons.facebook,
                  label: 'VK',
                  color: const Color(0xFF4C75A3),
                  onTap: () => _openSocialMedia('VK'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Support button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to support
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Открываем поддержку...')),
                    );
                  },
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Связаться с поддержкой'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Rate button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Открываем магазин...')),
                    );
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Оценить приложение'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E88E5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF1E88E5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Legal links
            Text(
              'Юридическая информация',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to privacy policy
                  },
                  child: const Text('Политика конфиденциальности'),
                ),
                Text(
                  ' • ',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to terms
                  },
                  child: const Text('Условия использования'),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
