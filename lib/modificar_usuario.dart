import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModificarUsuarioScreen extends StatefulWidget {
  @override
  _ModificarUsuarioScreenState createState() => _ModificarUsuarioScreenState();
}

class _ModificarUsuarioScreenState extends State<ModificarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  String? id, nombre, apellido, email, password, rol;

  Future<void> _modificarUsuario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('http://localhost/la_curva/modificar_usuario.php'),
        body: {
          'id': id,
          'nombre': nombre,
          'apellido': apellido,
          'email': email,
          'password': password ?? '',
          'rol': rol,
        },
      );
      String mensaje = response.statusCode == 200
          ? 'Usuario modificado exitosamente.'
          : 'Error al modificar usuario.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modificar Usuario')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID del Usuario'),
                keyboardType: TextInputType.number,
                onSaved: (value) => id = value,
                validator: (value) => value!.isEmpty ? 'El ID es obligatorio' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => nombre = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                onSaved: (value) => apellido = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña (opcional)'),
                obscureText: true,
                onSaved: (value) => password = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Rol'),
                items: [
                  DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                  DropdownMenuItem(value: 'administrador', child: Text('Administrador')),
                ],
                onChanged: (value) => rol = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _modificarUsuario,
                child: Text('Modificar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
