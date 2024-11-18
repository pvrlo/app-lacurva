// seleccionar_fechas_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ver_habitaciones_screen.dart';

class SeleccionarFechasScreen extends StatefulWidget {
  @override
  _SeleccionarFechasScreenState createState() =>
      _SeleccionarFechasScreenState();
}

class _SeleccionarFechasScreenState extends State<SeleccionarFechasScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  String _formatDate(DateTime? date) {
    if (date == null) return 'No seleccionada';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime selectedDate = await showDatePicker(
          context: context,
          initialDate: _checkInDate ?? now,
          firstDate: now,
          lastDate: DateTime(now.year + 1),
        ) ??
        now;

    if (_checkOutDate != null && selectedDate.isAfter(_checkOutDate!)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'La fecha de check-in no puede ser posterior a la de check-out.'),
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

  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (_checkInDate == null) {
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
        ) ??
        _checkInDate!;

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
                'Check-In: ${_formatDate(_checkInDate)}',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectCheckOutDate(context),
              child: Text(
                'Check-Out: ${_formatDate(_checkOutDate)}',
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: (_checkInDate != null && _checkOutDate != null)
                  ? () {
                      // Navega a VerHabitacionesScreen y pasa las fechas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerHabitacionesScreen(
                            checkInDate: _checkInDate!, // Pasa la fecha como no nula
                            checkOutDate: _checkOutDate!, // Pasa la fecha como no nula
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text('Ver habitaciones disponibles'),
            ),
          ],
        ),
      ),
    );
  }
}