// all_records_screen.dart

import 'package:flutter/material.dart';

class AllRecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список записей'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 10, // Example data
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Запись $index'),
            );
          },
        ),
      ),
    );
  }
}