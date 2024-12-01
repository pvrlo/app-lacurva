import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart'; // Importamos FlutterToast para los mensajes emergentes
import 'package:shared_preferences/shared_preferences.dart';  // Importar SharedPreferences
import 'panel_admin.dart'; // Importar la pantalla de panel administrativo
import 'main.dart'; // Importar la pantalla principal para clientes
import 'registro.dart'; // Importar la pantalla de registro

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Verificar si el usuario ya está autenticado
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;  // Default: false
    String role = prefs.getString('role') ?? '';

    if (isLoggedIn) {
      if (role == 'administrador') {
        // Redirigir al panel administrativo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PanelAdminScreen()),
        );
      } else if (role == 'cliente') {
        // Redirigir a la pantalla principal de clientes
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BienvenidaScreen()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  // Comprobar el estado de la sesión cuando la pantalla se inicia
  }

  // Función para iniciar sesión
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingrese su correo y contraseña.';
      });
      return;
    }

    try {
      var url = Uri.parse('http://localhost/la_curva/authenticate.php');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          String role = jsonResponse['role'];
          
          // Guardamos el estado de sesión en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          prefs.setString('role', role);
          prefs.setString('email', email);  // Guardamos también el email, si lo deseas

          if (role == 'administrador') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PanelAdminScreen()),
            );
          } else if (role == 'cliente') {
            Fluttertoast.showToast(
              msg: "Inicio de sesión exitoso",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BienvenidaScreen()),
            );
          }
        } else {
          setState(() {
            _errorMessage = 'Credenciales incorrectas.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error al iniciar sesión. Inténtelo de nuevo.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de red: $e';
      });
    }
  }

  // Función para navegar al registro
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()), // Navegar a RegisterScreen
    );
  }

  // Función para cerrar sesión
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    prefs.remove('role');
    prefs.remove('email');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),  // Redirige a la pantalla de login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícono de retroceso
          onPressed: () {
            // Redirigir al 'main.dart' (pantalla principal) al presionar el botón de retroceso
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BienvenidaScreen()),  // Redirige a la pantalla principal
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _navigateToRegister,
              child: Text(
                '¿No tienes cuenta? Regístrate aquí',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
