import 'package:flutter/material.dart';
import 'ver_reservas.dart'; // Asegúrate de importar la pantalla de ver reservas

class GestionarReservasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Reservas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aquí podrás gestionar las reservas.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40), // Espacio entre el texto y el botón
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de ver reservas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerReservasScreen()),
                );
              },
              child: Text('Ver Reservas'),
            ),
          ],
        ),
      ),
    );
  }
}
