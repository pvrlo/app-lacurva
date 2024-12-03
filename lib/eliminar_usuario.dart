import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EliminarUsuarioScreen extends StatefulWidget {
  @override
  _EliminarUsuarioScreenState createState() => _EliminarUsuarioScreenState();
}

class _EliminarUsuarioScreenState extends State<EliminarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  String? id;

  Future<void> _eliminarUsuario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('http://localhost/la_curva/eliminar_usuario.php'),
        body: {'id': id},
      );
      String mensaje = response.statusCode == 200
          ? 'Usuario eliminado exitosamente.'
          : 'Error al eliminar usuario.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eliminar Usuario')),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _eliminarUsuario,
                child: Text('Eliminar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
