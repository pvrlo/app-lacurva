import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarUsuarioScreen extends StatefulWidget {
  @override
  _AgregarUsuarioScreenState createState() => _AgregarUsuarioScreenState();
}

class _AgregarUsuarioScreenState extends State<AgregarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  String? nombre, apellido, email, password, rol;

  Future<void> _agregarUsuario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('http://localhost/la_curva/agregar_usuario.php'),
        body: {
          'nombre': nombre,
          'apellido': apellido,
          'email': email,
          'password': password,
          'rol': rol,
        },
      );
      String mensaje = response.statusCode == 200
          ? 'Usuario agregado exitosamente.'
          : 'Error al agregar usuario.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Usuario')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => nombre = value,
                validator: (value) =>
                    value!.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                onSaved: (value) => apellido = value,
                validator: (value) =>
                    value!.isEmpty ? 'El apellido es obligatorio' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'El email es obligatorio' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onSaved: (value) => password = value,
                validator: (value) =>
                    value!.isEmpty ? 'La contraseña es obligatoria' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Rol'),
                items: [
                  DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                  DropdownMenuItem(value: 'administrador', child: Text('Administrador')),
                ],
                onChanged: (value) => rol = value,
                validator: (value) => value == null ? 'El rol es obligatorio' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarUsuario,
                child: Text('Agregar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
