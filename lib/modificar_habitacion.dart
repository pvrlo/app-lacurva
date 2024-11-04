import 'package:flutter/material.dart';

class ModificarHabitacionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Habitación'),
      ),
      body: Center(
        child: Text(
          'Formulario para modificar una habitación existente.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
