import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

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
  File? imagenSeleccionada;
  Uint8List? imagenBytes;

  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      final bytes = await imagen.readAsBytes();

      setState(() {
        imagenSeleccionada = File(imagen.path);
        imagenBytes = bytes;
      });
    }
  }

  Future<void> agregarHabitacion(BuildContext context) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/agregar_habitacion.php'),
      );

      request.fields['numero'] = numeroController.text;
      request.fields['tipo'] = tipoSeleccionado.toLowerCase();
      request.fields['capacidad'] = capacidadSeleccionada.toString();
      request.fields['precio_noche'] = precioNocheController.text;
      request.fields['prepago_noche'] = prepagoNocheController.text;
      request.fields['descripcion'] = descripcionController.text;
      request.fields['disponible'] = disponibilidadSeleccionada == 'Sí' ? '1' : '0';

      // Si hay una imagen seleccionada, agregarla al request
      if (imagenSeleccionada != null && imagenBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'imagen', // Nombre del campo de la imagen que el backend espera
            imagenBytes!,
            filename: imagenSeleccionada!.path.split('/').last, // Nombre de la imagen
            contentType: MediaType('image', 'jpeg'), // Tipo de contenido
          ),
        );
      }

      // Enviar la solicitud
      final response = await request.send();

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
            TextField(
              controller: numeroController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de habitación',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
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
            TextField(
              controller: precioNocheController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Precio por noche',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: prepagoNocheController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Prepago por noche',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
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
            // Mostrar la imagen seleccionada (si existe)
            if (imagenBytes != null)
              Image.memory(
                imagenBytes!, // Usamos Image.memory para Flutter Web
                height: 150,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _seleccionarImagen,
              child: Text('Subir imagen'),
            ),
            SizedBox(height: 16),
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
