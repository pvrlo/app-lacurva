import 'package:flutter/material.dart';
import 'codigo_reseña.dart'; // Importamos la pantalla de Hacer Reseña
import 'seleccionar_fechas.dart'; // Importamos la pantalla de seleccionar fechas
import 'login.dart'; // Importamos la pantalla de inicio de sesión
import 'pago_completado.dart'; // Importamos la pantalla de pago completado

void main() {
  runApp(MyApp());
}

// Simulamos un estado de sesión
bool isUserLoggedIn = false; // Cambia esta variable según el estado real

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
  void _navigateBasedOnAuth(BuildContext context, Widget screen) {
    if (isUserLoggedIn) {
      // Usuario autenticado: Navegamos a la pantalla deseada
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      // Usuario no autenticado: Redirigir a la pantalla de inicio de sesión
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

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
                // Verificamos autenticación antes de navegar
                _navigateBasedOnAuth(context, SeleccionarFechasScreen());
              },
              child: Text("Seleccionar Fechas"),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              onPressed: () {
                // Verificamos autenticación antes de navegar
                _navigateBasedOnAuth(context, HacerResenaScreen());
              },
              child: Text("Hacer Reseña"),
            ),
          ],
        ),
      ),
    );
  }
}
