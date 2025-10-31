import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

// Helper class para los argumentos
class StatsDetalleArgs {
  final String titulo;
  final String apiUrl;
  final String labelColumn; // El nombre de la columna (ej. "sede" o "nombre")

  StatsDetalleArgs({
    required this.titulo,
    required this.apiUrl,
    required this.labelColumn,
  });
}

class StatsDetallePage extends StatefulWidget {
  const StatsDetallePage({Key? key}) : super(key: key);

  @override
  _StatsDetallePageState createState() => _StatsDetallePageState();
}

class _StatsDetallePageState extends State<StatsDetallePage> {
  late Future<List<dynamic>> _futureStats;
  late StatsDetalleArgs _args;
  final numberFormat = NumberFormat.decimalPattern('es_PE');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 1. Recibe los argumentos
    _args = ModalRoute.of(context)!.settings.arguments as StatsDetalleArgs;
    _futureStats = _fetchStats(_args.apiUrl);
  }

  // Llama a la API específica
  Future<List<dynamic>> _fetchStats(String apiUrl) async {
    final timeout = const Duration(seconds: 30);
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
        title: Text(_args.titulo),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildReport(snapshot.data!); // Mostramos la tabla
          }
          return Center(child: Text('No hay datos para este reporte.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futureStats = _fetchStats(_args.apiUrl);
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

  // Construye el reporte (SOLO LA TABLA)
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          columns: [
            DataColumn(label: Text(_args.labelColumn.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Inscritos'), numeric: true),
            DataColumn(label: Text('Prospecto'), numeric: true),
            DataColumn(label: Text('Examen'), numeric: true),
            DataColumn(label: Text('Ambos'), numeric: true),
          ],
          rows: data.map((item) {
            // Protección contra nulos
            return DataRow(cells: [
              DataCell(Text(item[_args.labelColumn]?.toString() ?? 'N/A')),
              DataCell(Text(numberFormat.format(item['inscritos'] ?? 0))),
              DataCell(Text(numberFormat.format(item['pagaron_prospecto'] ?? 0))),
              DataCell(Text(numberFormat.format(item['pagaron_examen'] ?? 0))),
              DataCell(Text(numberFormat.format(item['pagaron_ambos'] ?? 0))),
            ]);
          }).toList(),
        ),
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