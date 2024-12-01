import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences
import 'codigo_reseña.dart'; // Importamos la pantalla de Hacer Reseña
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
  // Verifica si el usuario está autenticado como cliente
  Future<bool> _isAuthenticatedAsClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String role = prefs.getString('role') ?? '';
    return isLoggedIn && role == 'cliente';
  }

  // Lógica de navegación basada en la autenticación
  Future<void> _navigateBasedOnAuth(BuildContext context, Widget screen) async {
    bool isClient = await _isAuthenticatedAsClient();
    if (isClient) {
      // Si está autenticado y es cliente, navega a la pantalla solicitada
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      // Si no está autenticado, navega al formulario de inicio de sesión
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  // Función para cerrar sesión
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Elimina todos los datos de la sesión

    // Redirigir a la pantalla de inicio de sesión
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Elimina todas las rutas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('La Curva Apartamentos'),
            Row(
              children: [
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
                SizedBox(width: 10), // Espacio entre la imagen y el botón
                TextButton(
                  onPressed: () => _logout(context), // Llama a la función para cerrar sesión
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Eliminar relleno
                    minimumSize: Size(50, 30), // Tamaño mínimo
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Ajustar área táctil
                  ),
                  child: Text(
                    "Cerrar sesión",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ],
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
                _navigateBasedOnAuth(context, SeleccionarFechasScreen());
              },
              child: Text("Seleccionar Fechas"),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              onPressed: () {
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
