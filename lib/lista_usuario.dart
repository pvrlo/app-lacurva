import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaUsuariosScreen extends StatefulWidget {
  @override
  _ListaUsuariosScreenState createState() => _ListaUsuariosScreenState();
}

class _ListaUsuariosScreenState extends State<ListaUsuariosScreen> {
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    _obtenerUsuarios();
  }

  Future<void> _obtenerUsuarios() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/la_curva/obtener_usuarios.php'));
      if (response.statusCode == 200) {
        setState(() {
          usuarios = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener usuarios')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión al servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: usuarios.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('${usuario['nombre']} ${usuario['apellido']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${usuario['id']}'),
                        Text('Correo: ${usuario['email']}'),
                        Text('Rol: ${usuario['rol']}'),
                        Text('Creado el: ${usuario['created_at']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
