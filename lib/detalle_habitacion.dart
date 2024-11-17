// lib/screens/detalle_habitacion_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/habitacion.dart';
import 'reserva_habitacion.dart';

class DetalleHabitacionScreen extends StatelessWidget {
  final Habitacion habitacion;

  DetalleHabitacionScreen({required this.habitacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la habitación ${habitacion.numero}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contenedor para mostrar la imagen y los detalles al lado
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen de la habitación
                habitacion.imagen.isNotEmpty
                    ? _buildImage(habitacion.imagen)
                    : Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey[300],
                        child: Center(child: Text('Sin imagen disponible')),
                      ),
                SizedBox(width: 16),
                // Detalles de la habitación al lado derecho
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información de la habitación
                      Text(
                        'Habitación ${habitacion.numero}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Tipo: ${habitacion.tipo}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Capacidad: ${habitacion.capacidad} personas', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Precio por noche: \$${habitacion.precioNoche}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Prepago por noche: \$${habitacion.prepagoNoche}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Descripción: ${habitacion.descripcion}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                        'Disponible: ${habitacion.disponible == 1 ? 'Sí' : 'No'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Botón para reservar la habitación
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de reserva con el número de habitación y el precio
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReservaHabitacionScreen(
                    habitacionNumero: habitacion.numero.toString(),
                    precioPorNoche: habitacion.precioNoche,
                  ),
                ));
              },
              child: Text('Reservar habitación'),
            ),
          ],
        ),
      ),
    );
  }

  // Función para decodificar y mostrar la imagen base64 (si es necesario)
  Widget _buildImage(String imageData) {
    var imageString = imageData.contains(',') ? imageData.split(',')[1] : imageData;

    // Agregar relleno SOLO si la longitud no es múltiplo de 4
    if (imageString.length % 4 != 0) {
      final padding = '=' * (4 - (imageString.length % 4));
      imageString += padding;
    }

    return Image.memory(
      base64Decode(imageString),
      height: 150, // Tamaño adecuado para la imagen
      width: 150, // Tamaño adecuado para la imagen
      fit: BoxFit.cover,
    );
  }
}
