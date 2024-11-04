import 'package:flutter/material.dart';
import 'agregar_habitacion.dart';   
import 'modificar_habitacion.dart'; 
import 'eliminar_habitacion.dart'; 
import 'lista_habitacion.dart';    

class GestionarHabitacionesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Habitaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aquí puedes gestionar las habitaciones.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de agregar habitación
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgregarHabitacionScreen()),
                );
              },
              child: Text('Agregar Habitación'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de modificar habitación
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModificarHabitacionScreen()),
                );
              },
              child: Text('Modificar Habitación'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de eliminar habitación
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EliminarHabitacionScreen()),
                );
              },
              child: Text('Eliminar Habitación'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de lista de habitaciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaHabitacionesScreen()),
                );
              },
              child: Text('Ver Lista de Habitaciones'),
            ),
          ],
        ),
      ),
    );
  }
}
