import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EliminarHabitacionScreen extends StatefulWidget {
  @override
  _EliminarHabitacionScreenState createState() => _EliminarHabitacionScreenState();
}

class _EliminarHabitacionScreenState extends State<EliminarHabitacionScreen> {
  final TextEditingController numeroController = TextEditingController();

  Future<void> eliminarHabitacion(BuildContext context) async {
    if (numeroController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese el número de la habitación')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost/eliminar_habitacion.php'), // Reemplaza con la URL de tu servidor
      body: {
        'numero': numeroController.text,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Habitación eliminada exitosamente')),
      );
      numeroController.clear(); // Limpia el campo después de eliminar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la habitación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Habitación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            ElevatedButton(
              onPressed: () {
                eliminarHabitacion(context);
              },
              child: Text('Eliminar Habitación'),
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
