import 'package:flutter/material.dart';

class ListaHabitacionesScreen extends StatelessWidget {
  // Lista de habitaciones de ejemplo
  final List<String> habitaciones = [

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Habitaciones'),
      ),
      body: ListView.builder(
        itemCount: habitaciones.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(habitaciones[index]),
          );
        },
      ),
    );
  }
}