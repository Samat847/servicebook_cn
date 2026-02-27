import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import '../l10n/app_localizations.dart';
import 'add_car_screen.dart';
import 'auth_screen.dart';
import 'car_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> _cars = [];
  bool _isLoading = true;
  String? _errorMessage;

  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF666666);

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cars = await CarStorage.loadCarsList();
      setState(() {
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

  Future<void> _navigateToAddCar() async {
    final newCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCarScreen(),
      ),
    );

    if (newCar != null && newCar is Car) {
      setState(() {
        _cars.add(newCar);
      });

      await CarStorage.saveCar(newCar);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newCar.brand} ${newCar.model} добавлен!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _deleteCar(String carId) async {
    try {
      await CarStorage.deleteCar(carId);
      setState(() {
        _cars.removeWhere((c) => c.id == carId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Автомобиль удален'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка удаления: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 60,
                color: Colors.grey[300],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Пока нет автомобилей',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Добавьте свой первый автомобиль\nдля начала ведения истории обслуживания',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToAddCar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Добавить первый автомобиль',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }

  Widget _buildCarImage(Car car) {
    const String defaultCarImagePath = 'assets/images/in-out-chery-tiggo-7-pro-max-plus.6u7h5mnpapdf..jpg';
    
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildImageWidget(car.imagePath ?? defaultCarImagePath),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageFallback();
        },
      );
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageFallback();
          },
        );
      } else {
        return _buildImageFallback();
      }
    }
  }

  Widget _buildImageFallback() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car,
            size: 48,
            color: primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Фото недоступно',
            style: TextStyle(
              fontSize: 12,
              color: secondaryTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCars,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarsList() {
    return RefreshIndicator(
      onRefresh: _loadCars,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cars.isNotEmpty) _buildCarImage(_cars.first),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                'Автомобили (${_cars.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: secondaryTextColor,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.separated(
                itemCount: _cars.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final car = _cars[index];
                  return _buildCarCard(car);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Dismissible(
      key: Key(car.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Удалить автомобиль?'),
            content: Text('Вы уверены, что хотите удалить ${car.displayName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Удалить'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => _deleteCar(car.id),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailScreen(car: car),
            ),
          ).then((_) => _loadCars());
        },
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  size: 36,
                  color: primaryColor,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${car.year} год',
                            style: const TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      if (car.vin != null && car.vin!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_number,
                              size: 14,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                car.vin!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: secondaryTextColor,
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      if (car.plate != null && car.plate!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.numbers,
                              size: 14,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              car.plate!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),

                      if (car.mileage != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.speed,
                              size: 14,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${car.mileage!.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} км',
                              style: TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: secondaryTextColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_isLoading) {
      body = _buildLoadingState();
    } else if (_errorMessage != null) {
      body = _buildErrorState();
    } else if (_cars.isEmpty) {
      body = _buildEmptyState();
    } else {
      body = _buildCarsList();
    }

    return BackgroundScaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        title: const Text(
          'Мой гараж',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: primaryColor),
            onPressed: _navigateToAddCar,
            tooltip: 'Добавить автомобиль',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Выйти из аккаунта'),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
          ),
        ],
      ),
      body: body,
      floatingActionButton: !_isLoading && _errorMessage == null
          ? FloatingActionButton(
              onPressed: _navigateToAddCar,
              backgroundColor: primaryColor,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            )
          : null,
    );
  }
}
