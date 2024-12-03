import 'package:flutter/material.dart';
import 'agregar_usuario.dart';
import 'modificar_usuario.dart';
import 'eliminar_usuario.dart';
import 'lista_usuario.dart'; // Importamos la pantalla de lista de usuarios

class GestionarUsuariosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Usuarios'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Opciones para gestionar usuarios',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgregarUsuarioScreen(),
                  ),
                );
              },
              child: Text('Agregar Usuario'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModificarUsuarioScreen(),
                  ),
                );
              },
              child: Text('Modificar Usuario'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EliminarUsuarioScreen(),
                  ),
                );
              },
              child: Text('Eliminar Usuario'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaUsuariosScreen(),
                  ),
                );
              },
              child: Text('Ver Lista de Usuarios'),
            ),
          ],
        ),
      ),
    );
  }
}
