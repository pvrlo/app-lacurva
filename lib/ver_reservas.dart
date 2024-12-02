import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerReservasScreen extends StatefulWidget {
  @override
  _VerReservasScreenState createState() => _VerReservasScreenState();
}

class _VerReservasScreenState extends State<VerReservasScreen> {
  List<dynamic> reservas = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReservas();
  }

  Future<void> fetchReservas() async {
    final url = 'http://localhost/la_curva/obtener_reservas.php';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> reservasData = json.decode(response.body);
        setState(() {
          reservas = reservasData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Error al cargar las reservas. Código de estado: ${response.statusCode}';
          isLoading = false;
        });
        print('Error al cargar las reservas. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de conexión: $e';
        isLoading = false;
      });
      print('Error de conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Reservas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = reservas[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Habitación: ${reserva['habitacion']} - ${reserva['nombre_habitacion']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tipo: ${reserva['tipo']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Capacidad: ${reserva['capacidad']} personas',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Precio por noche: \$${reserva['precio_noche']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entrada: ${reserva['fecha_entrada']}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Salida: ${reserva['fecha_salida']}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Reservado por: ${reserva['nombre_cliente']}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Correo: ${reserva['correo_cliente']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        leading: reserva['imagen'] != null
                            ? Image.network(
                                reserva['imagen'],
                                width: 80,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.bed),
                      ),
                    );
                  },
                ),
    );
  }
}
