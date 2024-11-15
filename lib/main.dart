import 'package:flutter/material.dart';
import 'gestionar_habitacion.dart';
<<<<<<< HEAD
import 'seleccionar_fechas.dart'; // Importamos la nueva pantalla
=======
>>>>>>> 639c5f13a27fd1e5c13a3de9f5da9a7cdcf3b36d

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostal La Curva',
<<<<<<< HEAD
       debugShowCheckedModeBanner: false,
=======
>>>>>>> 639c5f13a27fd1e5c13a3de9f5da9a7cdcf3b36d
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
<<<<<<< HEAD
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
=======
        title: Text('Hostal La Curva'),
>>>>>>> 639c5f13a27fd1e5c13a3de9f5da9a7cdcf3b36d
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
<<<<<<< HEAD
              'Bienvenido a La Curva Apartamentos',
=======
              '¡Bienvenido a mi app!',
>>>>>>> 639c5f13a27fd1e5c13a3de9f5da9a7cdcf3b36d
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
<<<<<<< HEAD
                // Navegar a la pantalla de seleccionar fechas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeleccionarFechasScreen()),
                );
              },
              child: Text('Reservar ahora'),
=======
                // Navegar a la pantalla de gestionar habitaciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionarHabitacionesScreen()),
                );
              },
              child: Text('Gestionar habitaciones'),
>>>>>>> 639c5f13a27fd1e5c13a3de9f5da9a7cdcf3b36d
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 639c5f13a27fd1e5c13a3de9f5da9a7cdcf3b36d
