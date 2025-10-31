import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

const String API_URL = 'http://172.20.68.99:8001/api/estadisticas/por-descuento';

class StatsDescuentoPage extends StatefulWidget {
  const StatsDescuentoPage({Key? key}) : super(key: key);

  @override
  _StatsDescuentoPageState createState() => _StatsDescuentoPageState();
}

class _StatsDescuentoPageState extends State<StatsDescuentoPage> {
  late Future<List<dynamic>> _futureStats;
  final numberFormat = NumberFormat.decimalPattern('es_PE');

  @override
  void initState() {
    super.initState();
    _futureStats = _fetchStats(API_URL);
  }

  // Llama a la API
  Future<List<dynamic>> _fetchStats(String apiUrl) async {
    final timeout = const Duration(seconds: 15);
    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('La conexión tardó demasiado (Timeout).');
    } on SocketException {
      throw Exception('Error de red. Verifica la conexión con el servidor.');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte de Descuentos'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildReport(snapshot.data!);
          }
          return Center(child: Text('No hay datos de descuentos.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futureStats = _fetchStats(API_URL);
          });
        },
        child: Icon(Icons.refresh),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text(error, textAlign: TextAlign.center)));
  }

  // Construye el reporte (SOLO TABLA)
  Widget _buildReport(List<dynamic> data) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildSectionTitle('Tabla de Datos'),
        _buildDataTable(data),
      ],
    );
  }

  // Construye la Tabla de Datos
  Widget _buildDataTable(List<dynamic> data) {
    return Card(
      child: DataTable(
        columns: [
          DataColumn(label: Text('Tipo Descuento', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Total Aprobados'), numeric: true),
        ],
        rows: data.map((item) {
          return DataRow(cells: [
            DataCell(Text(item['tipo']?.toString() ?? 'N/A')),
            DataCell(Text(numberFormat.format(item['total'] ?? 0))),
          ]);
        }).toList(),
      ),
    );
  }

  // Helper para títulos
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}