// ver_habitaciones_screen.dart

import 'package:flutter/material.dart';
import '../services/habitacion_service.dart'; 
import '../models/habitacion.dart'; 
import 'detalle_habitacion.dart'; 

class VerHabitacionesScreen extends StatelessWidget {
  final HabitacionService habitacionService = HabitacionService();
  final DateTime checkInDate;
  final DateTime checkOutDate;

  VerHabitacionesScreen({
    required this.checkInDate,
    required this.checkOutDate,
  }) {
    print('VerHabitacionesScreen - checkInDate: $checkInDate');
    print('VerHabitacionesScreen - checkOutDate: $checkOutDate');
  }

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

            final habitacionesDisponibles = habitaciones
                .where((habitacion) => habitacion.disponible)
                .toList();

            if (habitacionesDisponibles.isEmpty) {
              return Center(child: Text('No hay habitaciones disponibles'));
            }

            return ListView.builder(
              itemCount: habitacionesDisponibles.length,
              itemBuilder: (context, index) {
                final habitacion = habitacionesDisponibles[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: habitacion.imagen.isNotEmpty
                        ? Image.network(
                            habitacion.imagen,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error),
                                ),
                          )
                        : const Icon(Icons.hotel, size: 40), 
                    title: Text('Habitación ${habitacion.numero}'),
                    subtitle: Text(
                        'Tipo: ${habitacion.tipo}\nCapacidad: ${habitacion.capacidad}\nPrecio por noche: \$${habitacion.precioNoche}'),
                    trailing: ElevatedButton(
                      child: Text('Ver detalles'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetalleHabitacionScreen(
                              habitacion: habitacion,
                              checkInDate: checkInDate,
                              checkOutDate: checkOutDate,
                            ),
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