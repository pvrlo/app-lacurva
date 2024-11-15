import 'package:flutter/material.dart';
import 'gestionar_habitacion.dart';
import 'seleccionar_fechas.dart'; // Importamos la nueva pantalla

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostal La Curva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BienvenidaScreen(),
    );
  }
}

class BienvenidaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('La Curva Apartamentos'),
            GestureDetector(
              onTap: () {
                // Navegar a la pantalla de gestionar habitaciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionarHabitacionesScreen()),
                );
              },
              child: Image.asset(
                'images/person.png', // Reemplaza 'ruta_a_tu_imagen' con la ruta de tu imagen
                height: 30, // Tamaño pequeño para la imagen
                width: 30,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a La Curva Apartamentos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de seleccionar fechas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeleccionarFechasScreen()),
                );
              },
              child: Text("Seleccionar Fechas"),
            ),
          ],
        ),
      ),
    );
  }
}
