import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/habitacion.dart';
import 'reserva_habitacion.dart';

class DetalleHabitacionScreen extends StatelessWidget {
  final Habitacion habitacion;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  DetalleHabitacionScreen({
    required this.habitacion,
    required this.checkInDate,
    required this.checkOutDate,
  });

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

  // Función para decodificar y mostrar la imagen
  Widget _buildImage(String imageData) {
    // Comprobar si la imagen es una URL
    if (imageData.startsWith('http') || imageData.startsWith('https')) {
      return Image.network(
        imageData,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            width: 150,
            color: Colors.grey[300],
            child: Center(child: Text('Error al cargar imagen')),
          );
        },
      );
    }

    // Manejar Base64
    try {
      String imageString = imageData.contains(',') ? imageData.split(',')[1] : imageData;

      // Agregar relleno SOLO si la longitud no es múltiplo de 4
      if (imageString.length % 4 != 0) {
        final padding = '=' * (4 - (imageString.length % 4));
        imageString += padding;
      }

      return Image.memory(
        base64Decode(imageString),
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } catch (e) {
      // Si ocurre un error, mostrar contenedor de error
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey[300],
        child: Center(child: Text('Imagen inválida')),
      );
    }
  }
}
