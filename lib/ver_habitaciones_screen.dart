// lib/screens/ver_habitaciones_screen.dart
import 'package:flutter/material.dart';
import '../services/habitacion_service.dart';
import '../models/habitacion.dart';
import 'detalle_habitacion.dart'; // Nueva pantalla para mostrar más detalles

class VerHabitacionesScreen extends StatelessWidget {
  final HabitacionService habitacionService = HabitacionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habitaciones disponibles'),
      ),
      body: FutureBuilder<List<Habitacion>>(
        future: habitacionService.fetchHabitaciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay habitaciones disponibles'));
          } else {
            final habitaciones = snapshot.data!;

            return ListView.builder(
              itemCount: habitaciones.length,
              itemBuilder: (context, index) {
                final habitacion = habitaciones[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(habitacion.imagen),
                    title: Text('Habitación ${habitacion.numero}'),
                    subtitle: Text('Tipo: ${habitacion.tipo}\nCapacidad: ${habitacion.capacidad}\nPrecio por noche: \$${habitacion.precioNoche}'),
                    trailing: ElevatedButton(
                      child: Text('Ver detalles'),
                      onPressed: () {
                        // Navegar a la pantalla de detalles con más información de la habitación
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetalleHabitacionScreen(habitacion: habitacion),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
