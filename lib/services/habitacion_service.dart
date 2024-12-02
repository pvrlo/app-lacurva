import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/habitacion.dart';

class HabitacionService {
  Future<List<Habitacion>> fetchHabitaciones() async {
    final response = await http.get(Uri.parse('http://localhost/la_curva/lista_habitacion.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((habitacionJson) => Habitacion.fromJson(habitacionJson))
          .where((habitacion) => habitacion.disponible) // Filtrar por disponibilidad
          .toList();
    } else {
      throw Exception('Error al cargar las habitaciones');
    }
  }
}

