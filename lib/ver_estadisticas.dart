import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class VerEstadisticasScreen extends StatefulWidget {
  @override
  _VerEstadisticasScreenState createState() => _VerEstadisticasScreenState();
}

class _VerEstadisticasScreenState extends State<VerEstadisticasScreen> {
  List<Map<String, dynamic>> _chartData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/estadisticas.php')); // Reemplaza con la URL de tu servidor
    if (response.statusCode == 200) {
        setState(() {
        _chartData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        _isLoading = false;
      });

      _chartData = _chartData.map((data) {
      data['reservas'] = int.parse(data['reservas']); // O double.parse() si se esperan decimales
      return data;
    }).toList();
    } else {
      // Manejar el error de la solicitud
      print('Error al obtener datos: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Estadísticas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _chartData.isEmpty
              ? Center(child: Text('No hay datos disponibles'))
              : SfCircularChart(
                  title: ChartTitle(text: 'Habitaciones Más Reservadas'),
                  series: <PieSeries<Map<String, dynamic>, String>>[
                    PieSeries<Map<String, dynamic>, String>(
                      dataSource: _chartData,
                      xValueMapper: (Map<String, dynamic> data, _) => data['numero'],
                      yValueMapper: (Map<String, dynamic> data, _) => data['reservas'],
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
    );
  }
}