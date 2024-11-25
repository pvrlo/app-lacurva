import 'package:flutter/material.dart';
import 'gestionar_habitacion.dart'; // Importar la pantalla de gestionar habitaciones
import 'gestionar_reservas.dart'; // Importar la pantalla para gestionar reservas
import 'ver_estadisticas.dart'; // Importar la pantalla para ver estadísticas

class PanelAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administración'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido al panel de administración',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de gestionar habitaciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionarHabitacionesScreen()),
                );
              },
              child: Text('Gestionar Habitaciones'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de gestionar reservas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionarReservasScreen()),
                );
              },
              child: Text('Gestionar Reservas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de ver estadísticas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerEstadisticasScreen()),
                );
              },
              child: Text('Ver Estadísticas'),
            ),
          ],
        ),
      ),
    );
  }
}
