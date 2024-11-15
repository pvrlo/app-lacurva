import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl
import 'ver_habitaciones_screen.dart'; // Importa la pantalla donde quieres redirigir

class SeleccionarFechasScreen extends StatefulWidget {
  @override
  _SeleccionarFechasScreenState createState() =>
      _SeleccionarFechasScreenState();
}

class _SeleccionarFechasScreenState extends State<SeleccionarFechasScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  // Función para formatear la fecha a un formato legible
  String _formatDate(DateTime? date) {
    if (date == null) return 'No seleccionada'; // Si no hay fecha seleccionada, mostrar "No seleccionada"
    return DateFormat('dd/MM/yyyy').format(date); // Formato dd/MM/yyyy
  }

  // Función para seleccionar la fecha de check-in
  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? now, // Si no hay fecha seleccionada, tomar la fecha actual
      firstDate: now, // No permitir fechas anteriores al día actual
      lastDate: DateTime(now.year + 1), // Permitir solo un año hacia el futuro
    ) ?? now;

    if (_checkOutDate != null && selectedDate.isAfter(_checkOutDate!)) {
      // Si la fecha de check-in es posterior a la de check-out, mostrar un mensaje
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('La fecha de check-in no puede ser posterior a la de check-out.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _checkInDate = selectedDate;
      });
    }
  }

  // Función para seleccionar la fecha de check-out
  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (_checkInDate == null) {
      // Si no se ha seleccionado fecha de check-in, mostrar un mensaje
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Primero selecciona la fecha de check-in.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? _checkInDate!,
      firstDate: _checkInDate!,
      lastDate: DateTime(_checkInDate!.year + 1),
    ) ?? _checkInDate!;

    setState(() {
      _checkOutDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Fechas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecciona las fechas de tu reserva',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectCheckInDate(context),
              child: Text(
                'Check-In: ${_formatDate(_checkInDate)}', // Muestra la fecha de check-in formateada
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectCheckOutDate(context),
              child: Text(
                'Check-Out: ${_formatDate(_checkOutDate)}', // Muestra la fecha de check-out formateada
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: (_checkInDate != null && _checkOutDate != null) ? () {
                // Si ambas fechas están seleccionadas, navega a la pantalla de habitaciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerHabitacionesScreen()), // Navegar a la pantalla VerHabitacionesScreen
                );
              } : null, // El botón estará deshabilitado si no se seleccionaron ambas fechas
              child: Text('Ver habitaciones disponibles'),
            ),
          ],
        ),
      ),
    );
  }
}
