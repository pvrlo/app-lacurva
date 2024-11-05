import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum TipoHabitacion {
  privada,
  compartida,
}

class ModificarHabitacionScreen extends StatefulWidget {
  @override
  _ModificarHabitacionScreenState createState() => _ModificarHabitacionScreenState();
}

class _ModificarHabitacionScreenState extends State<ModificarHabitacionScreen> {
  final TextEditingController numeroController = TextEditingController();
  TipoHabitacion nuevoTipo = TipoHabitacion.privada; // Valor por defecto
  final TextEditingController nuevaCapacidadController = TextEditingController();
  final TextEditingController nuevoPrecioController = TextEditingController();
  final TextEditingController nuevoPrepagoController = TextEditingController();
  final TextEditingController nuevaDescripcionController = TextEditingController();
  
  String nuevaDisponibilidad = 'Sí';
  bool isLoading = false;

  Future<void> obtenerDetallesHabitacion() async {
    if (numeroController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese el número de la habitación')),
      );
      return;
    }

    setState(() {
      isLoading = true; // Cambiamos el estado a cargando
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost/lista_habitacion.php?numero=${numeroController.text}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data.isNotEmpty) {
          setState(() {
            // Asignamos los valores asegurándonos de que se están manejando como Strings
            nuevoTipo = data['tipo'] == 'privada' ? TipoHabitacion.privada : TipoHabitacion.compartida; // Usamos el enum
            nuevaCapacidadController.text = data['capacidad'].toString();
            nuevoPrecioController.text = data['precio_noche'].toString();
            nuevoPrepagoController.text = data['prepago_noche'].toString();
            nuevaDescripcionController.text = data['descripcion'] ?? '';
            nuevaDisponibilidad = data['disponible'] == '1' ? 'Sí' : 'No'; // Manejo de disponibilidad
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se encontró la habitación')),
          );
        }
      } else {
        print('Error al obtener detalles de la habitación: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener los detalles de la habitación')),
        );
      }
    } catch (e) {
      print('Ocurrió un error al obtener la habitación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Cambiamos el estado a no cargando
      });
    }
  }

  Future<void> modificarHabitacion() async {
    if (numeroController.text.isEmpty ||
        nuevaCapacidadController.text.isEmpty ||
        nuevoPrecioController.text.isEmpty ||
        nuevoPrepagoController.text.isEmpty ||
        nuevaDescripcionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    // Validar y convertir valores a los tipos correctos
    int capacidad = int.tryParse(nuevaCapacidadController.text) ?? 0;
    double precioNoche = double.tryParse(nuevoPrecioController.text) ?? 0.0;
    double prepagoNoche = double.tryParse(nuevoPrepagoController.text) ?? 0.0;

    // Validaciones
    if (capacidad <= 0 || precioNoche < 0 || prepagoNoche < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese valores válidos')),
      );
      return;
    }

    // Convertir el enum a String para enviarlo
    String tipoString = nuevoTipo == TipoHabitacion.privada ? 'privada' : 'compartida';

    try {
      final response = await http.post(
        Uri.parse('http://localhost/modificar_habitacion.php'),
        body: {
          'numero': numeroController.text,
          'tipo': tipoString, // Enviamos el tipo como String
          'capacidad': capacidad.toString(), // Convertimos a String
          'precio_noche': precioNoche.toString(), // Convertimos a String
          'prepago_noche': prepagoNoche.toString(), // Convertimos a String
          'descripcion': nuevaDescripcionController.text,
          'disponible': nuevaDisponibilidad == 'Sí' ? '1' : '0',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habitación modificada exitosamente')),
        );
      } else {
        print('Error al modificar la habitación: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar la habitación')),
        );
      }
    } catch (e) {
      print('Ocurrió un error al modificar la habitación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Habitación'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Número de habitación',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => obtenerDetallesHabitacion(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: obtenerDetallesHabitacion,
                    child: Text('Cargar detalles de la habitación'),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<TipoHabitacion>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de habitación',
                      border: OutlineInputBorder(),
                    ),
                    value: nuevoTipo,
                    items: TipoHabitacion.values.map((TipoHabitacion tipo) {
                      return DropdownMenuItem<TipoHabitacion>(
                        value: tipo,
                        child: Text(tipo.toString().split('.').last), // Muestra el nombre del enum
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        nuevoTipo = newValue!; // Actualizamos el tipo seleccionado
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: nuevaCapacidadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Capacidad (número de personas)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: nuevoPrecioController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Precio por noche',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: nuevoPrepagoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Prepago por noche',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: nuevaDescripcionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Disponibilidad',
                      border: OutlineInputBorder(),
                    ),
                    value: nuevaDisponibilidad,
                    items: ['Sí', 'No'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        nuevaDisponibilidad = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: modificarHabitacion,
                    child: Text('Modificar Habitación'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
