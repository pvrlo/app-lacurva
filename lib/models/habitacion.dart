// lib/models/habitacion.dart
class Habitacion {
  final int id;
  final String numero;
  final String tipo;
  final int capacidad;
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
  final baseUrl = 'http://localhost/la_curva/uploads/'; // Cambia esto a tu URL base

  return Habitacion(
    id: int.tryParse(json['id'].toString()) ?? 0,
    numero: json['numero'].toString(),
    tipo: json['tipo'].toString(),
    capacidad: int.tryParse(json['capacidad'].toString()) ?? 0,
    precioNoche: double.tryParse(json['precio_noche'].toString()) ?? 0.0,
    prepagoNoche: double.tryParse(json['prepago_noche'].toString()) ?? 0.0,
    descripcion: json['descripcion'].toString(),
    // En el modelo Habitacion.fromJson
imagen: json['imagen'] != null && json['imagen'].isNotEmpty
        ? baseUrl + Uri.encodeComponent(json['imagen']) // Codifica la URL
        : '',
    // Aquí es donde aseguramos que se maneje el valor disponible como booleano
    disponible: json['disponible'] == '1', // Convierte 1 a true y 0 a false
  );
}

}