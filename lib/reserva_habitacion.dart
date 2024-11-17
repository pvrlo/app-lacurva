import 'package:flutter/material.dart';

class ReservaHabitacionScreen extends StatefulWidget {
  final String habitacionNumero;
  final double precioPorNoche;

  ReservaHabitacionScreen({
    required this.habitacionNumero,
    required this.precioPorNoche,
  });

  @override
  _ReservaHabitacionScreenState createState() => _ReservaHabitacionScreenState();
}

class _ReservaHabitacionScreenState extends State<ReservaHabitacionScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String dni = '';
  String correo = '';
  String telefono = '';
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int adultos = 1;
  int ninos = 0;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = DateTime.now().add(Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Habitación ${widget.habitacionNumero}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre completo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                  onSaved: (value) => nombre = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'DNI o Pasaporte'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu DNI o pasaporte';
                    }
                    return null;
                  },
                  onSaved: (value) => dni = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Por favor ingresa un correo válido';
                    }
                    return null;
                  },
                  onSaved: (value) => correo = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Número de teléfono'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu número de teléfono';
                    }
                    return null;
                  },
                  onSaved: (value) => telefono = value!,
                ),
                SizedBox(height: 16),
                Text(
                  'Precio Total: \$${widget.precioPorNoche}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                isProcessing
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              isProcessing = true;
                            });

                            // Aquí puedes realizar la lógica para guardar la reserva
                            // o realizar cualquier otra acción relacionada

                            // Simulando un proceso de confirmación de reserva
                            await Future.delayed(Duration(seconds: 2));

                            // Mostrar un mensaje de éxito
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Reserva Confirmada')),
                            );

                            // Puedes navegar a otra pantalla si es necesario
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Confirmar Reserva'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
