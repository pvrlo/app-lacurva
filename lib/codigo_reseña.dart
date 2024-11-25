import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Importamos para manejar JSON
import 'hacer_reseña.dart'; // Asegúrate de tener este archivo importado

class HacerResenaScreen extends StatefulWidget {
  @override
  _HacerResenaScreenState createState() => _HacerResenaScreenState();
}

class _HacerResenaScreenState extends State<HacerResenaScreen> {
  final TextEditingController _codigoController = TextEditingController();
  String? _codigoError;

  Future<void> _verificarCodigo() async {
    String codigo = _codigoController.text;

    // Verificamos si el código no está vacío
    if (codigo.isEmpty) {
      setState(() {
        _codigoError = 'Por favor, ingrese el código de reserva.';
      });
      return;
    }

    // Llamada al backend para verificar si el código es válido
    try {
      final response = await http.post(
        Uri.parse('http://localhost/la_curva/validar_codigo.php'), // Reemplaza con tu URL de backend
        body: json.encode({'codigo': codigo}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['existe']) {
          // Código correcto, redirigir a la página de reseña
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HacerResenaPage(codigo: codigo)),
          );
        } else {
          setState(() {
            _codigoError = 'Código de reserva inválido.';
          });
        }
      } else {
        setState(() {
          _codigoError = 'Error en la verificación del código.';
        });
      }
    } catch (error) {
      setState(() {
        _codigoError = 'No se pudo conectar con el servidor. Intente nuevamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hacer una Reseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingrese el código de su reserva:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codigoController,
              decoration: InputDecoration(
                labelText: 'Código de Reserva',
                errorText: _codigoError,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verificarCodigo,
              child: Text('Verificar Código'),
            ),
          ],
        ),
      ),
    );
  }
}
