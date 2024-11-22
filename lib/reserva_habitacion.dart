import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ReservaHabitacionScreen extends StatefulWidget {
  final String habitacionNumero;
  final double precioPorNoche;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  ReservaHabitacionScreen({
    required this.habitacionNumero,
    required this.precioPorNoche,
    this.checkInDate,
    this.checkOutDate,
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

  String? selectedPaymentMethod;
  final List<String> paymentMethods = ['Tarjeta de Crédito', 'PayPal', 'Transferencia Bancaria'];

  final String clientId = 'AbPN2Ugwee2ogiTmjktpS49PC-fOdfwuZ-zMnEp8wRxVxCU_L7q_gHct-el1XBbR6M224kyh8RmQENz9'; // Reemplaza con tu Client ID de PayPal
  final String secret = 'EOhuOzMc_C2_RxKTofr_6sbHkdEEKRaqSVV03m_vYb0fuNJkWc-JQ-tcBOP_pHvs6HPw4hw2r7qNImlP'; // Reemplaza con tu Secret de PayPal

  @override
  void initState() {
    super.initState();
    checkInDate = widget.checkInDate ?? DateTime.now();
    checkOutDate = widget.checkOutDate ?? DateTime.now().add(Duration(days: 1));
  }

  double getPrecioTotal() {
    final diferencia = checkOutDate!.difference(checkInDate!).inDays;
    return widget.precioPorNoche * diferencia;
  }

  Future<String?> _getAccessToken() async {
    final url = Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$secret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['access_token'];
    } else {
      print('Error al obtener access token: ${response.body}');
      return null;
    }
  }

  Future<void> _createPayPalPayment() async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo obtener el token de acceso')));
      return;
    }

    final url = Uri.parse('https://api.sandbox.paypal.com/v1/payments/payment');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        "intent": "sale",
        "redirect_urls": {
          "return_url": "https://example.com/success", // URL de retorno a tu servidor PHP
          "cancel_url": "https://example.com/cancel" // URL de cancelación
        },
        "payer": {"payment_method": "paypal"},
        "transactions": [
          {
            "amount": {
              "total": getPrecioTotal().toStringAsFixed(2),
              "currency": "USD"
            },
            "description": "Reserva Habitación ${widget.habitacionNumero}"
          }
        ]
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      final approvalUrl = jsonResponse['links'].firstWhere(
            (link) => link['rel'] == 'approval_url',
        orElse: () => null,
      )?['href'];

      if (approvalUrl != null && await canLaunch(approvalUrl)) {
        await launch(approvalUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo abrir PayPal')));
      }
    } else {
      print('Error al crear el pago: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear el pago')));
    }
  }

  Future<void> _createReservation(String paymentId) async {
    final url = Uri.parse('https://localhost/la_curva/crear_reserva.php'); // URL de tu archivo PHP

    final response = await http.post(url, body: {
      'usuario': nombre, // Enviar el nombre como 'usuario'
      'dni': dni,
      'correo': correo,
      'telefono': telefono,
      'habitacion': widget.habitacionNumero,
      'check_in': checkInDate!.toIso8601String(),
      'check_out': checkOutDate!.toIso8601String(),
      'adultos': adultos.toString(),
      'ninos': ninos.toString(),
      'precio_total': getPrecioTotal().toStringAsFixed(2),
      'payment_id': paymentId,
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reserva creada con éxito')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear la reserva')));
    }
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
                // Información de la habitación
                Text(
                  'Habitación ${widget.habitacionNumero}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Precio por noche: \$${widget.precioPorNoche.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Precio total: \$${getPrecioTotal().toStringAsFixed(2)} (Calculado para ${checkOutDate!.difference(checkInDate!).inDays} noches)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Estado de la habitación: Disponible',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Fecha de creación de la reserva: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Fechas de check-in y check-out
                Text(
                  'Fecha de check-in: ${checkInDate?.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Fecha de check-out: ${checkOutDate?.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Formulario de reserva
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

                // Campos para cantidad de adultos y niños
                TextFormField(
                  decoration: InputDecoration(labelText: 'Cantidad de Adultos'),
                  keyboardType: TextInputType.number,
                  initialValue: adultos.toString(),
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Por favor ingresa un número válido de adultos';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => adultos = int.parse(value)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Cantidad de Niños'),
                  keyboardType: TextInputType.number,
                  initialValue: ninos.toString(),
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Por favor ingresa un número válido de niños';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => ninos = int.parse(value)),
                ),
                SizedBox(height: 16),

                // Selección de pago
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Método de Pago'),
                  value: selectedPaymentMethod,
                  items: paymentMethods.map((method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un método de pago';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Muestra el precio total
                Text(
                  'Precio Total: \$${getPrecioTotal().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Botón para realizar el pago
                isProcessing
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (checkOutDate!.isBefore(checkInDate!)) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('La fecha de check-out no puede ser anterior a la de check-in')));
                              return;
                            }
                            if (selectedPaymentMethod == null || selectedPaymentMethod!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor selecciona un método de pago')));
                              return;
                            }
                            _formKey.currentState!.save();
                            _createPayPalPayment();
                          }
                        },
                        child: Text('Realizar pago'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
