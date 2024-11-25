import 'package:flutter/material.dart';
import 'codigo_reseña.dart';  // Importamos la pantalla de Hacer Reseña
import 'seleccionar_fechas.dart'; // Importamos la pantalla de seleccionar fechas
import 'login.dart'; // Importamos la pantalla de inicio de sesión
import 'pago_completado.dart'; // Importamos la pantalla de pago completado

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
      home: BienvenidaScreen(), // Página de bienvenida
      routes: {
        '/pago_completado': (context) => PagoCompletadoScreen(), // Ruta para pago completado
        '/hacer_resena': (context) => HacerResenaScreen(), // Ruta para hacer una reseña
      },
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
                // Navegar a la pantalla de inicio de sesión
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Image.asset(
                'images/person.png', // Ruta de la imagen de perfil
                height: 30,
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
            SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla para hacer una reseña
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HacerResenaScreen()),
                );
              },
              child: Text("Hacer Reseña"),
            ),
          ],
        ),
      ),
    );
  }
}
