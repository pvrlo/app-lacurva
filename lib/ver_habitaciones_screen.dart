// lib/screens/ver_habitaciones_screen.dart
import 'package:flutter/material.dart';
import '../services/habitacion_service.dart';
import '../models/habitacion.dart';

class VerHabitacionesScreen extends StatelessWidget {
  final HabitacionService habitacionService = HabitacionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habitaciones Disponibles'),
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
                    trailing: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        // Lógica para seleccionar la habitación
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Seleccionaste la habitación ${habitacion.numero}'),
                            content: Text('Tipo: ${habitacion.tipo}\nPrecio: \$${habitacion.precioNoche}'),
                            actions: [
                              TextButton(
                                child: Text('Cerrar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
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
