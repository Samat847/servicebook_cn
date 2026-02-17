import 'package:flutter/material.dart';
import 'partners_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Перенаправляем на экран партнёров
    return const PartnersScreen();
  }
}