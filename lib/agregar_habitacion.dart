import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // Para detectar el tipo MIME
import 'dart:convert';
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
        Uri.parse('http://localhost/la_curva/agregar_habitacion.php'), // Cambia a 10.0.2.2 si usas un emulador de Android
      );

      // Imprimir los datos para verificar que se están enviando correctamente
      print('Datos enviados:');
      print('Número: ${numeroController.text}');
      print('Tipo: $tipoSeleccionado');
      print('Capacidad: $capacidadSeleccionada');
      print('Precio por noche: ${precioNocheController.text}');
      print('Prepago por noche: ${prepagoNocheController.text}');
      print('Descripción: ${descripcionController.text}');
      print('Disponible: $disponibilidadSeleccionada');

      request.fields['numero'] = numeroController.text;
      request.fields['tipo'] = tipoSeleccionado.toLowerCase();
      request.fields['capacidad'] = capacidadSeleccionada.toString();
      request.fields['precio_noche'] = precioNocheController.text;
      request.fields['prepago_noche'] = prepagoNocheController.text;
      request.fields['descripcion'] = descripcionController.text;
      request.fields['disponible'] = disponibilidadSeleccionada == 'Sí' ? '1' : '0';

      // Si hay una imagen seleccionada, agregarla al request
      if (imagenSeleccionada != null && imagenBytes != null) {
       // Detectar el tipo MIME correcto según el archivo


request.files.add(
  http.MultipartFile.fromBytes(
    'imagen', 
    imagenBytes!,
    filename: 'imagen_${DateTime.now().millisecondsSinceEpoch}.jpeg', // Forzar extensión válida
    contentType: MediaType('image', 'jpeg'),
  ),
);

print('Ruta de imagen seleccionada: ${imagenSeleccionada!.path}');
print('Tipo MIME detectado: ${lookupMimeType(imagenSeleccionada!.path, headerBytes: imagenBytes)}');

      }

      // Enviar la solicitud
      final response = await request.send();

      // Leer la respuesta
      final responseBody = await response.stream.bytesToString();
      print('Respuesta del servidor: $responseBody');

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(responseBody); // Aquí se utiliza jsonDecode
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseJson['message'])),
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
