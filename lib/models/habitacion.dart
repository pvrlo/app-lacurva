// lib/models/habitacion.dart
class Habitacion {
  final int id;
  final String numero;
  final String tipo;
  final int capacidad;  // Asegúrate de que la capacidad sea int
  final double precioNoche;
  final double prepagoNoche;
  final String descripcion;
  final String imagen;
  final bool disponible;

  Habitacion({
    required this.id,
    required this.numero,
    required this.tipo,
    required this.capacidad,
    required this.precioNoche,
    required this.prepagoNoche,
    required this.descripcion,
    required this.imagen,
    required this.disponible,
  });

  factory Habitacion.fromJson(Map<String, dynamic> json) {
    return Habitacion(
      id: int.tryParse(json['id'].toString()) ?? 0,  // Asegura que el id sea un int
      numero: json['numero'].toString(),            // Convierte a String si es necesario
      tipo: json['tipo'].toString(),                // Convierte a String si es necesario
      capacidad: int.tryParse(json['capacidad'].toString()) ?? 0,  // Convierte a int
      precioNoche: double.tryParse(json['precio_noche'].toString()) ?? 0.0,  // Convierte a double
      prepagoNoche: double.tryParse(json['prepago_noche'].toString()) ?? 0.0,  // Convierte a double
      descripcion: json['descripcion'].toString(),  // Convierte a String si es necesario
      imagen: json['imagen'].toString(),            // Convierte a String si es necesario
      disponible: json['disponible'] == 1,          // Se mantiene la comparación con 1
    );
  }
}
