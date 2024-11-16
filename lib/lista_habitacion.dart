import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaHabitacionesScreen extends StatefulWidget {
  @override
  _ListaHabitacionesScreenState createState() => _ListaHabitacionesScreenState();
}

class _ListaHabitacionesScreenState extends State<ListaHabitacionesScreen> {
  List<Map<String, dynamic>> habitaciones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    obtenerHabitaciones();
  }

  Future<void> obtenerHabitaciones() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/lista_habitacion.php')); 

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          habitaciones = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar las habitaciones');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las habitaciones: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Habitaciones'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : habitaciones.isEmpty
              ? Center(child: Text('No hay habitaciones disponibles'))
              : ListView.builder(
                  itemCount: habitaciones.length,
                  itemBuilder: (context, index) {
                    final habitacion = habitaciones[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          habitacion['imagen'] != null && habitacion['imagen'].isNotEmpty
                              ? _buildImage(habitacion['imagen'])
                              : Container(
                                  height: 200,
                                  color: Colors.grey[300], 
                                  child: Center(child: Text('Sin imagen')),
                                ),
                          ListTile(
                            title: Text('Habitación ${habitacion['numero']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tipo: ${habitacion['tipo']}'),
                                Text('Capacidad: ${habitacion['capacidad']} personas'),
                                Text('Precio por noche: \$${habitacion['precio_noche']}'),
                                Text('Prepago por noche: \$${habitacion['prepago_noche']}'),
                                Text('Descripción: ${habitacion['descripcion']}'),
                                Text('Disponible: ${habitacion['disponible'] == '1' ? 'Sí' : 'No'}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  // Función para decodificar y mostrar la imagen base64 (CORREGIDA)
  Widget _buildImage(String imageData) {
    var imageString = imageData.contains(',') ? imageData.split(',')[1] : imageData;

    // Agregar relleno SOLO si la longitud no es múltiplo de 4
    if (imageString.length % 4 != 0) {
      final padding = '=' * (4 - (imageString.length % 4));
      imageString += padding; 
    }

    return Image.memory(
      base64Decode(imageString),
      height: 200, 
      width: double.infinity,
      fit: BoxFit.cover, 
    );
  }
}