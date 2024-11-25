import 'package:flutter/material.dart';
import '../services/habitacion_service.dart'; // Importa el servicio
import '../models/habitacion.dart'; // Importa el modelo Habitacion
import 'detalle_habitacion.dart'; // Importa la pantalla de detalles

class VerHabitacionesScreen extends StatelessWidget {
  final HabitacionService habitacionService = HabitacionService(); // Instancia del servicio
  final DateTime checkInDate;
  final DateTime checkOutDate;

  VerHabitacionesScreen({
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habitaciones disponibles'),
      ),
      body: FutureBuilder<List<Habitacion>>(
        future: habitacionService.fetchHabitaciones(), // Llama al servicio para obtener las habitaciones
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay habitaciones disponibles'));
          } else {
            final habitaciones = snapshot.data!;

            // Filtrar solo las habitaciones disponibles (disponible == true)
            final habitacionesDisponibles = habitaciones.where((habitacion) => habitacion.disponible).toList();

            // Si no hay habitaciones disponibles después de filtrar
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
                        ? Image.network(habitacion.imagen) // Si tiene imagen, la carga
                        : Container(color: Colors.grey[200], child: Icon(Icons.image, size: 40)), // Si no, un ícono
                    title: Text('Habitación ${habitacion.numero}'),
                    subtitle: Text(
                        'Tipo: ${habitacion.tipo}\nCapacidad: ${habitacion.capacidad}\nPrecio por noche: \$${habitacion.precioNoche}'),
                    trailing: ElevatedButton(
                      child: Text('Ver detalles'),
                      onPressed: () {
                        // Navega a DetalleHabitacionScreen y pasa las fechas
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
