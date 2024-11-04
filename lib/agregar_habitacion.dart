import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarHabitacionScreen extends StatefulWidget {
  @override
  _AgregarHabitacionScreenState createState() => _AgregarHabitacionScreenState();
}

class _AgregarHabitacionScreenState extends State<AgregarHabitacionScreen> {
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController precioNocheController = TextEditingController();
  final TextEditingController prepagoNocheController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  String tipoSeleccionado = 'Privada';
  int capacidadSeleccionada = 1;
  String disponibilidadSeleccionada = 'Sí';

  Future<void> agregarHabitacion(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/agregar_habitacion.php'), // Reemplaza con la IP de tu máquina.
        body: {
          'numero': numeroController.text,
          'tipo': tipoSeleccionado.toLowerCase(),
          'capacidad': capacidadSeleccionada.toString(),
          'precio_noche': precioNocheController.text,
          'prepago_noche': prepagoNocheController.text,
          'descripcion': descripcionController.text,
          'imagen': '', // Placeholder, añade lógica de subida si es necesario
          'disponible': disponibilidadSeleccionada == 'Sí' ? '1' : '0',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habitación agregada exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar la habitación')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar la habitación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Habitación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campo que solo admite números (número de habitación, por ejemplo)
            TextField(
              controller: numeroController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de habitación',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Campo desplegable para tipo de habitación (privada/compartida)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Tipo de habitación',
                border: OutlineInputBorder(),
              ),
              value: tipoSeleccionado,
              items: ['Privada', 'Compartida'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  tipoSeleccionado = newValue!;
                });
              },
            ),
            SizedBox(height: 16),

            // Campo desplegable de capacidad (1 a 4)
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Capacidad',
                border: OutlineInputBorder(),
              ),
              value: capacidadSeleccionada,
              items: [1, 2, 3, 4].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  capacidadSeleccionada = newValue!;
                });
              },
            ),
            SizedBox(height: 16),

            // Campo que solo admite números para el precio por noche
            TextField(
              controller: precioNocheController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Precio por noche',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Campo que solo admite números para el prepago por noche
            TextField(
              controller: prepagoNocheController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Prepago por noche',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Campo de texto para la descripción
            TextField(
              controller: descripcionController,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Campo para subir la imagen (solo un botón por ahora)
            ElevatedButton(
              onPressed: () {
                // Lógica para subir la imagen (placeholder)
              },
              child: Text('Subir imagen'),
            ),
            SizedBox(height: 16),

            // Campo desplegable para disponibilidad (sí/no)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Disponible',
                border: OutlineInputBorder(),
              ),
              value: disponibilidadSeleccionada,
              items: ['Sí', 'No'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  disponibilidadSeleccionada = newValue!;
                });
              },
            ),
            SizedBox(height: 24),

            // Botón para agregar la habitación
            ElevatedButton(
              onPressed: () {
                agregarHabitacion(context);
              },
              child: Text('Agregar Habitación'),
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
