import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import '../l10n/app_localizations.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'add_car_screen.dart';
import 'driver_license_screen.dart';
import 'insurance_screen.dart';
import 'documents_screen.dart';
import 'sts_detail_screen.dart';
import 'all_documents_screen.dart';
import 'profile_edit_screen.dart';
import 'security_settings_screen.dart';
import 'language_settings_screen.dart';
import 'data_management_screen.dart';
import 'backup_settings_screen.dart';
import 'help_and_faq_screen.dart';
import 'support_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'about_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfile _profile = UserProfile(name: '', city: '');
  List<Car> _cars = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await CarStorage.loadUserProfile();
      final cars = await CarStorage.loadCarsList();
      setState(() {
        _profile = profile;
        _cars = cars;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка загрузки данных: $e';
      });
    }
  }

  Future<void> _logout() async {
    await CarStorage.saveAuthStatus(false);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _navigateToAddCar() async {
    final newCar = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCarScreen()),
    );
    if (newCar != null && newCar is Car) {
      setState(() => _cars.add(newCar));
      await CarStorage.saveCar(newCar);
    }
  }

  String _formatMileage(int? mileage) {
    if (mileage == null) return '— км';
    return '${mileage.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} км';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_errorMessage!, style: TextStyle(color: Colors.red[700])),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: Text(l10n?.retry ?? 'Повторить'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: CustomScrollView(
                    slivers: [
                      // AppBar с именем и бонусами
                      SliverAppBar(
                        expandedHeight: 160,
                        pinned: true,
                        floating: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _profile.displayName,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade700,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        l10n?.premium ?? 'Premium',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.stars,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n?.bonusPoints ?? 'Бонусные баллы',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '1,250',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.blue.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        l10n?.refill ?? 'Пополнить',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Раздел "Мой гараж"
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n?.myGarageTitle ?? 'Мой гараж',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton.icon(
                                key: const Key('add_car_button'),
                                onPressed: _navigateToAddCar,
                                icon: const Icon(Icons.add_circle_outline, size: 20),
                                label: Text(l10n?.addButton ?? 'Добавить'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Карточка автомобиля (первый в списке или пустое состояние)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _cars.isEmpty
                              ? _buildEmptyCarCard()
                              : _buildCarCard(_cars.first),
                        ),
                      ),

                      // Раздел "Документы"
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n?.allDocuments ?? 'Документы',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                key: const Key('view_all_documents_button'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AllDocumentsScreen(),
                                    ),
                                  );
                                },
                                child: Text(l10n?.all ?? 'Все'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Список документов
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _buildDocumentTile(
                              key: const Key('driver_license_tile'),
                              icon: Icons.assignment_ind,
                              title: l10n?.driverLicense ?? 'Водительское удостоверение',
                              subtitle: l10n?.validUntil2028 ?? 'Действительно до 2028',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DriverLicenseScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDocumentTile(
                              key: const Key('insurance_tile'),
                              icon: Icons.car_crash,
                              title: l10n?.osago ?? 'ОСАГО',
                              subtitle: l10n?.valid ?? 'Действует',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InsuranceScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDocumentTile(
                              key: const Key('sts_tile'),
                              icon: Icons.description,
                              title: l10n?.sts ?? 'СТС',
                              subtitle: l10n?.unlimited ?? 'Бессрочно',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const STSDetailScreen(),
                                  ),
                                );
                              },
                            ),
                          ]),
                        ),
                      ),

                      // Раздел "Настройки"
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n?.settingsTitle ?? 'Настройки',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Список настроек
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _buildSettingsTile(
                              key: const Key('personal_data_tile'),
                              icon: Icons.person_outline,
                              title: l10n?.personalData ?? 'Личные данные',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileEditScreen(),
                                  ),
                                ).then((_) => _loadData());
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('security_tile'),
                              icon: Icons.lock_outline,
                              title: l10n?.security ?? 'Безопасность',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SecuritySettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('language_tile'),
                              icon: Icons.language,
                              title: l10n?.language ?? 'Язык',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LanguageSettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('data_management_tile'),
                              icon: Icons.storage,
                              title: l10n?.manageData ?? 'Управление данными',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DataManagementScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('backup_tile'),
                              icon: Icons.cloud_upload,
                              title: l10n?.backups ?? 'Резервные копии',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BackupSettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('help_tile'),
                              icon: Icons.help_outline,
                              title: l10n?.helpFaq ?? 'Помощь и FAQ',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpAndFaqScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('contact_support_tile'),
                              icon: Icons.support_agent,
                              title: l10n?.contactSupport ?? 'Связаться с поддержкой',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SupportScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('rate_app_tile'),
                              icon: Icons.star_outline,
                              title: l10n?.rateApp ?? 'Оценить приложение',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n?.openAppStore ?? 'Открываем магазин приложений...')),
                                );
                              },
                            ),
                            const Divider(height: 30),
                            _buildSettingsTile(
                              key: const Key('privacy_policy_tile'),
                              icon: Icons.privacy_tip,
                              title: l10n?.privacyPolicy ?? 'Политика конфиденциальности',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('terms_tile'),
                              icon: Icons.description_outlined,
                              title: l10n?.termsOfUse ?? 'Условия использования',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsOfServiceScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              key: const Key('about_tile'),
                              icon: Icons.info_outline,
                              title: l10n?.aboutApp ?? 'О приложении',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AboutScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 30),
                            _buildSettingsTile(
                              key: const Key('logout_tile'),
                              icon: Icons.logout,
                              title: l10n?.logout ?? 'Выйти',
                              onTap: _logout,
                              color: Colors.red,
                            ),
                          ]),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.blue,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${car.plate ?? (l10n?.withoutPlate ?? 'Без номера')} • ${car.shortInfo}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.speed, size: 18, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      _formatMileage(car.mileage),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.orange.shade600),
                    const SizedBox(width: 6),
                    Text(
                      l10n?.inDays(4500) ?? 'Через 4,500 км',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCarCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              l10n?.noCarsInGarage ?? 'В гараже пока нет автомобилей',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToAddCar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n?.addCar ?? 'Добавить автомобиль'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTile({
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSettingsTile({
    Key? key,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      key: key,
      leading: Icon(icon, color: color == Colors.black ? Colors.blue : color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: color == Colors.black ? Colors.black : color,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }
}
