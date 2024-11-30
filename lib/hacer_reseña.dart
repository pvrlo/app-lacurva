import 'dart:convert'; // Para JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Paquete HTTP

class HacerResenaPage extends StatefulWidget {
  final String codigo;
  final String idUsuario;

  HacerResenaPage({required this.codigo, required this.idUsuario});

  @override
  _HacerResenaPageState createState() => _HacerResenaPageState();
}

class _HacerResenaPageState extends State<HacerResenaPage> {
  final TextEditingController _comentarioController = TextEditingController();

  int _calificacionGeneral = 0;
  int _limpieza = 0;
  int _confort = 0;
  int _ubicacion = 0;
  int _instalaciones = 0;
  int _personal = 0;
  int _relacionCalidadPrecio = 0;
  int _wifi = 0;

  String? _errorMessage;

  Future<void> _guardarResena() async {
    if (_calificacionGeneral == 0) {
      setState(() {
        _errorMessage = "La calificación general es obligatoria.";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    // URL del archivo PHP en tu servidor
    final url = Uri.parse('http://localhost/la_curva/guardar_reseña.php');

    // Datos que enviarás al servidor
    final requestData = {
      'usuario': widget.idUsuario, // Aquí va el ID de usuario, por ejemplo, de tu sistema de autenticación
      'reserva': widget.codigo, // Código de reserva que pasaste
      'calificacion_general': _calificacionGeneral,
      'comentario': _comentarioController.text,
      'limpieza': _limpieza,
      'confort': _confort,
      'ubicacion': _ubicacion,
      'instalaciones': _instalaciones,
      'personal': _personal,
      'relacion_calidad_precio': _relacionCalidadPrecio,
      'wifi': _wifi,
    };

    try {
      // Enviar solicitud POST al servidor
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // Encabezados
        body: json.encode(requestData), // Datos en formato JSON
      );

      // Verificar respuesta del servidor
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success']) {
          _mostrarDialogoExito();
        } else {
          setState(() {
            _errorMessage = responseBody['message'] ?? "Error desconocido.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Error en el servidor (${response.statusCode}).";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión: $e";
      });
    }
  }

  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reseña Guardada'),
          content: Text('Gracias por enviar tu reseña.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Regresar a la pantalla anterior
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRatingSlider(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 5,
          divisions: 5,
          label: value.toString(),
          onChanged: (newValue) {
            onChanged(newValue.toInt());
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dejar una Reseña'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Código de Reserva: ${widget.codigo}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildRatingSlider(
              'Calificación General',
              _calificacionGeneral,
              (value) => setState(() => _calificacionGeneral = value),
            ),
            _buildRatingSlider(
              'Limpieza',
              _limpieza,
              (value) => setState(() => _limpieza = value),
            ),
            _buildRatingSlider(
              'Confort',
              _confort,
              (value) => setState(() => _confort = value),
            ),
            _buildRatingSlider(
              'Ubicación',
              _ubicacion,
              (value) => setState(() => _ubicacion = value),
            ),
            _buildRatingSlider(
              'Instalaciones',
              _instalaciones,
              (value) => setState(() => _instalaciones = value),
            ),
            _buildRatingSlider(
              'Personal',
              _personal,
              (value) => setState(() => _personal = value),
            ),
            _buildRatingSlider(
              'Relación Calidad/Precio',
              _relacionCalidadPrecio,
              (value) => setState(() => _relacionCalidadPrecio = value),
            ),
            _buildRatingSlider(
              'WiFi',
              _wifi,
              (value) => setState(() => _wifi = value),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _comentarioController,
              decoration: InputDecoration(
                labelText: 'Comentario (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarResena,
              child: Text('Guardar Reseña'),
            ),
          ],
        ),
      ),
    );
  }
}
