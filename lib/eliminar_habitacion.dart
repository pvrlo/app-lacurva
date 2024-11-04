import 'package:flutter/material.dart';

class EliminarHabitacionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Habitación'),
      ),
      body: Center(
        child: Text(
          'Formulario para eliminar una habitación existente.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
