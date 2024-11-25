import 'package:flutter/material.dart';

class HacerResenaPage extends StatefulWidget {
  final String codigo;

  HacerResenaPage({required this.codigo});

  @override
  _HacerResenaPageState createState() => _HacerResenaPageState();
}

class _HacerResenaPageState extends State<HacerResenaPage> {
  final TextEditingController _comentarioController = TextEditingController();

  int _calificacionGeneral = 3;
  int _limpieza = 3;
  int _confort = 3;
  int _ubicacion = 3;
  int _instalaciones = 3;
  int _personal = 3;
  int _relacionCalidadPrecio = 3;
  int _wifi = 3;

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

    // Aquí deberías enviar los datos al servidor o procesarlos según tus necesidades.
    // Simulamos una respuesta exitosa del servidor:
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
                Navigator.pop(context); // Volver a la pantalla anterior
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
