import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

enum TipoHabitacion {
  privada,
  compartida,
}

class ModificarHabitacionScreen extends StatefulWidget {
  @override
  _ModificarHabitacionScreenState createState() => _ModificarHabitacionScreenState();
}

class _ModificarHabitacionScreenState extends State<ModificarHabitacionScreen> {
  List<Map<String, dynamic>> habitaciones = [];
  bool isLoading = true;

  final TextEditingController numeroController = TextEditingController();
  TipoHabitacion nuevoTipo = TipoHabitacion.privada; 
  int nuevaCapacidad = 1; 
  final TextEditingController nuevoPrecioController = TextEditingController();
  final TextEditingController nuevoPrepagoController = TextEditingController();
  final TextEditingController nuevaDescripcionController = TextEditingController();
  String nuevaDisponibilidad = 'Sí';
  String? imagenUrl;
  File? nuevaImagen;

  @override
  void initState() {
    super.initState();
    obtenerListaHabitaciones();
  }

  Future<void> obtenerListaHabitaciones() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/lista_habitacion.php'));

      if (response.statusCode == 200) {
        setState(() {
          habitaciones = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar la lista de habitaciones');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    }
  }

  void abrirFormularioModificar(Map<String, dynamic> habitacion) {
    setState(() {
      numeroController.text = habitacion['numero'].toString();
      nuevoTipo = habitacion['tipo'] == 'privada' ? TipoHabitacion.privada : TipoHabitacion.compartida;
      nuevaCapacidad = int.tryParse(habitacion['capacidad'].toString()) ?? 1;
      nuevoPrecioController.text = habitacion['precio_noche'].toString();
      nuevoPrepagoController.text = habitacion['prepago_noche'].toString();
      nuevaDescripcionController.text = habitacion['descripcion'] ?? '';
      nuevaDisponibilidad = habitacion['disponible'] == '1' ? 'Sí' : 'No';
      imagenUrl = habitacion['imagen']; 
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Modificar Habitación'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: numeroController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Número de habitación',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<TipoHabitacion>(
                  decoration: InputDecoration(
                    labelText: 'Tipo de habitación',
                    border: OutlineInputBorder(),
                  ),
                  value: nuevoTipo,
                  items: TipoHabitacion.values.map((TipoHabitacion tipo) {
                    return DropdownMenuItem<TipoHabitacion>(
                      value: tipo,
                      child: Text(tipo.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      nuevoTipo = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Capacidad (número de personas)',
                    border: OutlineInputBorder(),
                  ),
                  value: nuevaCapacidad,
                  items: [1, 2, 3, 4].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      nuevaCapacidad = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nuevoPrecioController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Precio por noche',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nuevoPrepagoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Prepago por noche',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nuevaDescripcionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Disponibilidad',
                    border: OutlineInputBorder(),
                  ),
                  value: nuevaDisponibilidad,
                  items: ['Sí', 'No'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      nuevaDisponibilidad = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16),

                // Mostrar la imagen actual si existe
                if (imagenUrl != null && imagenUrl!.isNotEmpty) ...[
                  Image.network(
                    imagenUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: eliminarImagen,
                    child: Text('Eliminar Imagen'),
                  ),
                  SizedBox(height: 16),
                ],

                ElevatedButton(
                  onPressed: seleccionarImagen,
                  child: Text('Seleccionar Nueva Imagen'),
                ),
                if (nuevaImagen != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.file(
                      nuevaImagen!,
                      height: 200,
                    ),
                  ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: modificarHabitacion,
                  child: Text('Modificar Habitación'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        nuevaImagen = File(pickedFile.path);
      });
    }
  }

Future<void> eliminarImagen() async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost/eliminar_imagen.php'), 
      body: {
        'imagen_url': imagenUrl ?? '', // Enviar la URL de la imagen actual
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        imagenUrl = null; // Eliminar la imagen de la vista local
      });

      // Llamar nuevamente a la función para recargar la lista de habitaciones
      await obtenerListaHabitaciones(); 

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen eliminada exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la imagen')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ocurrió un error al eliminar la imagen: $e')),
    );
  }
}
  Future<void> modificarHabitacion() async {
    if (numeroController.text.isEmpty ||
        nuevoPrecioController.text.isEmpty ||
        nuevoPrepagoController.text.isEmpty ||
        nuevaDescripcionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    double precioNoche = double.tryParse(nuevoPrecioController.text) ?? 0.0;
    double prepagoNoche = double.tryParse(nuevoPrepagoController.text) ?? 0.0;

    if (precioNoche < 0 || prepagoNoche < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese valores válidos')),
      );
      return;
    }

    String tipoString = nuevoTipo == TipoHabitacion.privada ? 'privada' : 'compartida';

    try {
      // Lógica para manejar la nueva imagen
      String? nuevaImagenUrl;
      if (nuevaImagen != null) {
        nuevaImagenUrl = await subirImagen(nuevaImagen!);
      }

      final response = await http.post(
        Uri.parse('http://localhost/modificar_habitacion.php'),
        body: {
          'numero': numeroController.text,
          'tipo': tipoString,
          'capacidad': nuevaCapacidad.toString(),
          'precio_noche': precioNoche.toString(),
          'prepago_noche': prepagoNoche.toString(),
          'descripcion': nuevaDescripcionController.text,
          'disponible': nuevaDisponibilidad == 'Sí' ? '1' : '0',
          'imagen': nuevaImagenUrl ?? imagenUrl ?? '', // Enviar nueva imagen o URL previa
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habitación modificada exitosamente')),
        );
        Navigator.pop(context); // Volver a la lista de habitaciones
      } else {
        print('Error al modificar la habitación: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al modificar la habitación')),
        );
      }
    } catch (e) {
      print('Ocurrió un error al modificar la habitación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    }
  }

  // Función para subir la imagen al servidor
  Future<String?> subirImagen(File imagen) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://localhost/subir_imagen.php'));
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        var responseData = jsonDecode(responseString);
        return responseData['imageUrl']; // La URL de la imagen subida
      } else {
        print('Error al subir la imagen: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al subir la imagen: $e');
      return null;
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
          : ListView.builder(
              itemCount: habitaciones.length,
              itemBuilder: (context, index) {
                final habitacion = habitaciones[index];
                return ListTile(
                  title: Text('Habitación ${habitacion['numero']}'),
                  subtitle: Text('Tipo: ${habitacion['tipo']}'),
                  trailing: Icon(Icons.edit),
                  onTap: () => abrirFormularioModificar(habitacion),
                );
              },
            ),
    );
  }
}
