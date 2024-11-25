import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerReservasScreen extends StatefulWidget {
  @override
  _VerReservasScreenState createState() => _VerReservasScreenState();
}

class _VerReservasScreenState extends State<VerReservasScreen> {
  // Variable para almacenar las reservas
  List<dynamic> reservas = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReservas();
  }

  // Función para hacer la solicitud HTTP
  Future<void> fetchReservas() async {
    final url = 'http://localhost/la_curva/obtener_reservas.php'; // Reemplaza con la URL de tu API

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
          errorMessage = 'Error al cargar las reservas. Código de estado: ${response.statusCode}';
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
                        title: Row(
                          children: [
                            // Número de habitación en grande
                            Text(
                              '${reserva['habitacion']}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 16),
                            // Fecha de entrada y salida al lado del número de habitación
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Entrada: ${reserva['fecha_entrada']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Salida: ${reserva['fecha_salida']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Nombre de quien hizo la reserva y código de la reserva
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nombre: ${reserva['nombre']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Código: ${reserva['codigo']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              // Estado de la reserva
                              Text(
                                'Estado: ${reserva['estado']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
