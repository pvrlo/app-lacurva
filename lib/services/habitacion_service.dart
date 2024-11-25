// lib/services/habitacion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habitacion.dart';

class HabitacionService {
  final String apiUrl = 'http://localhost/la_curva/lista_habitacion.php'; // Asegúrate de que esta URL sea correcta

  Future<List<Habitacion>> fetchHabitaciones() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Habitacion.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar habitaciones');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
}
