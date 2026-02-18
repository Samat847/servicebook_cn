import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/models.dart';

class PartnersScreen extends StatefulWidget {
  final Car? car;

  const PartnersScreen({super.key, this.car});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  GoogleMapController? _mapController;
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(55.751244, 37.618423),
    zoom: 12,
  );

  String _selectedType = 'all';
  bool _onlyPartners = true;

  final List<Map<String, dynamic>> _partners = [
    {
      'id': 'Geely Service Center',
      'type': 'service',
      'isOfficial': true,
      'name': 'Geely Service Center',
      'address': 'ул. Автомобильная, 15',
      'distance': '1,2 км',
      'rating': 4.8,
      'reviews': 320,
      'hours': '09:00–21:00',
      'slot': '14:30',
      'tags': ['ТО и диагностика', 'Гарантия работ'],
      'lat': 55.751244,
      'lng': 37.618423,
    },
    {
      'id': 'Autoparts 24',
      'type': 'shop',
      'isOfficial': false,
      'name': 'Autoparts 24',
      'address': 'ул. Запчастей, 8',
      'distance': '0,8 км',
      'rating': 4.6,
      'reviews': 190,
      'hours': '10:00–20:00',
      'slot': null,
      'tags': ['Оригинал и аналоги', 'Доставка в СТО'],
      'lat': 55.734876,
      'lng': 37.588346,
    },
    {
      'id': 'Garage & Parts',
      'type': 'service',
      'isOfficial': false,
      'name': 'Garage & Parts',
      'address': 'ш. Восточное, 87',
      'distance': '2,5 км',
      'rating': 4.4,
      'reviews': 85,
      'hours': '09:00–20:00',
      'slot': null,
      'tags': ['Шиномонтаж', 'Тормоза, подвеска'],
      'lat': 55.760123,
      'lng': 37.641234,
    },
  ];

  Set<Marker> _buildMarkers() {
    return _partners.map((p) {
      return Marker(
        markerId: MarkerId(p['id']),
        position: LatLng(p['lat'], p['lng']),
        infoWindow: InfoWindow(
          title: p['name'],
          snippet: '${p['distance']} • ${p['rating']} ★',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          p['type'] == 'service'
              ? BitmapDescriptor.hueBlue
              : BitmapDescriptor.hueOrange,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Партнеры рядом',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.car != null
                  ? 'СТО и магазины запчастей для ${widget.car!['brand']} ${widget.car!['model']}'
                  : 'СТО и магазины запчастей',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Фильтры
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Все', 'all', Icons.apps),
                      const SizedBox(width: 8),
                      _buildFilterChip('СТО', 'service', Icons.build),
                      const SizedBox(width: 8),
                      _buildFilterChip('Магазины запчастей', 'shop', Icons.shopping_cart),
                      const SizedBox(width: 8),
                      _buildFilterChip('Официальные', 'official', Icons.verified),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '3 СТО и 2 магазина могут принять в ближайший час',
                            style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _onlyPartners,
                          onChanged: (value) => setState(() => _onlyPartners = value!),
                          activeColor: Colors.blue,
                          visualDensity: VisualDensity.compact,
                        ),
                        const Text('Только партнёры', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Карта
          Container(
            height: 200,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _mapController = controller,
              markers: _buildMarkers(),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
            ),
          ),

          // Заголовок списка
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Доступны сейчас',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Подобрано по вашему авто и локации',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Список партнеров
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _partners.length,
              itemBuilder: (context, index) {
                final p = _partners[index];
                return _buildPartnerCard(p);
              },
            ),
          ),

          // Нижняя плашка
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Подбор запчастей в разработке')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Подобрать СТО и запчасти под текущее ТО',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedType == value;
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey.shade600),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedType = value),
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.blue,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildPartnerCard(Map<String, dynamic> p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (p['type'] == 'service' ? Colors.blue : Colors.orange).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    p['type'] == 'service' ? Icons.build : Icons.shopping_cart,
                    color: p['type'] == 'service' ? Colors.blue : Colors.orange,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            p['name'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            p['distance'],
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      if (p['isOfficial'] == true) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Официальный партнёр',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: p['tags'].map<Widget>((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '${p['rating']} • ${p['reviews']} отзывов',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            'Сегодня: ${p['hours']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (p['slot'] != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'есть окно ${p['slot']}',
                    style: TextStyle(fontSize: 14, color: Colors.green.shade700),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showBookingDialog(p);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Записаться ${p['slot']}'),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Каталог запчастей в разработке')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Подобрать детали'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(Map<String, dynamic> partner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Запись на сервис'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              partner['name'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              partner['address'],
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Text(
              'Выбранное время: ${partner['slot']}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Вы записаны на ${partner['slot']}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }
}