import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/car_storage.dart';
import '../widgets/background_scaffold.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();

  // Списки марок и моделей
  final Map<String, List<String>> _brandModels = {
    'Chery': [
      'Tiggo 2',
      'Tiggo 4 / 4 Pro',
      'Tiggo 7 / 7 Pro / 7 Pro Max',
      'Tiggo 8 / 8 Pro / 8 Pro Max',
      'Arrizo 5',
      'Arrizo 8',
    ],
    'Geely': [
      'Coolray',
      'Atlas',
      'Atlas Pro',
      'Monjaro',
      'Tugella',
      'Emgrand',
      'Okavango',
    ],
    'Haval': [
      'Jolion',
      'F7',
      'F7x',
      'Dargo',
      'H6',
      'M6',
    ],
    'Changan': [
      'CS35 Plus',
      'CS55 Plus',
      'CS75 Plus',
      'UNI-K',
      'UNI-T',
      'UNI-V',
      'Alsvin',
      'Eado Plus',
    ],
    'Exeed': [
      'LX',
      'TXL',
      'VX',
      'RX',
    ],
    'Omoda': [
      'C5',
      'S5',
    ],
    'Jaecoo': [
      'J7',
      'J8',
    ],
    'Tank': [
      '300',
      '400',
      '500',
    ],
    'Jetour': [
      'X70',
      'X70 Plus',
      'X90 Plus',
      'Dashing',
    ],
    'GAC': [
      'GS3',
      'GS8',
      'GN8',
    ],
    'BYD': [
      'Song Plus',
      'Han',
      'Tang',
      'Dolphin',
      'Seal',
    ],
    'Zeekr': [
      '001',
      'X',
      '009',
    ],
    'FAW': [
      'Bestune T77',
      'Bestune B70',
      'Hongqi',
    ],
    'GWM': [
      'Poer',
      'P-Series',
    ],
    'Li Auto': [
      'L7',
      'L8',
      'L9',
    ],
  };

  // Поля формы
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedYear;
  String _vin = '';
  String _plate = '';
  String _mileage = '';

  // Годы выпуска (от 2000 до текущий год + 1)
  List<String> get _years {
    final currentYear = DateTime.now().year;
    final years = <String>[];
    for (int year = 2000; year <= currentYear + 1; year++) {
      years.add(year.toString());
    }
    return years.reversed.toList(); // Новые годы первыми
  }

  @override
  void initState() {
    super.initState();
    _selectedBrand = _brandModels.keys.first;
    _selectedModel = _brandModels[_selectedBrand]!.first;
    _selectedYear = _years.first;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      appBar: AppBar(
        title: const Text('Добавить автомобиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Заголовок
              const Text(
                'Добавьте авто',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Укажите основные данные вашего автомобиля для начала работы.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // Марка автомобиля
              const Text(
                'Марка',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedBrand,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBrand = newValue;
                        _selectedModel = _brandModels[newValue]!.first;
                      });
                    },
                    items: _brandModels.keys.map<DropdownMenuItem<String>>((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Модель автомобиля
              const Text(
                'Модель',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedModel,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedModel = newValue;
                      });
                    },
                    items: (_selectedBrand != null
                            ? _brandModels[_selectedBrand]
                            : <String>[])
                        ?.map<DropdownMenuItem<String>>((String model) {
                      return DropdownMenuItem<String>(
                        value: model,
                        child: Text(model),
                      );
                    }).toList() ?? [],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Год выпуска
              const Text(
                'Год выпуска',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedYear,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedYear = newValue;
                      });
                    },
                    items: _years.map<DropdownMenuItem<String>>((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // VIN номер
              const Text(
                'VIN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Опционально',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  hintText: 'Введите VIN номер',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: const Tooltip(
                    message: 'Максимальная точность',
                    child: Icon(Icons.info_outline, size: 20),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _vin = value.toUpperCase();
                  });
                },
                textCapitalization: TextCapitalization.characters,
              ),

              const SizedBox(height: 20),

              // Госномер
              const Text(
                'Госномер',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  hintText: 'A 000 AA 000',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: const Tooltip(
                    message: 'Ускоряет подбор запчастей',
                    child: Icon(Icons.info_outline, size: 20),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _plate = value.toUpperCase();
                  });
                },
                textCapitalization: TextCapitalization.characters,
              ),

              const SizedBox(height: 20),

              // Пробег
              const Text(
                'Пробег',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Опционально',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  hintText: 'Например: 15000',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixText: 'км',
                  suffixStyle: TextStyle(color: Colors.grey.shade600),
                ),
                onChanged: (value) {
                  setState(() {
                    _mileage = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // UX-подсказка
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'VIN, госномер и пробег помогут точнее подобрать детали, но их можно добавить позже.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Добавить автомобиль',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCar() async {
    if (_selectedBrand == null || _selectedModel == null || _selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все обязательные поля'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Создаем объект автомобиля
    final newCar = Car(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      brand: _selectedBrand!,
      model: _selectedModel!,
      year: _selectedYear!,
      vin: _vin.isNotEmpty ? _vin : null,
      plate: _plate.isNotEmpty ? _plate : null,
      addedDate: DateTime.now(),
      mileage: _mileage.isNotEmpty ? int.tryParse(_mileage.replaceAll(RegExp(r'\D'), '')) : null,
    );

    // Прямое сохранение в SharedPreferences — страховка
    await CarStorage.saveCar(newCar);

    if (mounted) {
      Navigator.pop(context, newCar);

      // Показываем сообщение об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Автомобиль $_selectedBrand $_selectedModel добавлен!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
