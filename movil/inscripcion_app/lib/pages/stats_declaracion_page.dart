import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../estadisticas_model.dart'; // Importa el modelo
import '../widgets/stat_card.dart'; // ¡Importa el widget de tarjeta corregido!

const String API_URL = 'http://172.20.68.99:8001/api/estadisticas/declaracion-jurada';

class StatsDeclaracionPage extends StatefulWidget {
  const StatsDeclaracionPage({Key? key}) : super(key: key);

  @override
  _StatsDeclaracionPageState createState() => _StatsDeclaracionPageState();
}

class _StatsDeclaracionPageState extends State<StatsDeclaracionPage> {
  late Future<DeclaracionStats> _futureStats;

  @override
  void initState() {
    super.initState();
    _futureStats = _fetchStats();
  }

  // Llama a la API de declaraciones
  Future<DeclaracionStats> _fetchStats() async {
    final timeout = const Duration(seconds: 15);
    try {
      final response = await http.get(Uri.parse(API_URL)).timeout(timeout);
      if (response.statusCode == 200) {
        return DeclaracionStats.fromApiJson(jsonDecode(response.body));
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
        title: Text('Reporte de Declaraciones'),
      ),
      body: FutureBuilder<DeclaracionStats>(
        future: _futureStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildReport(snapshot.data!);
          }
          return Center(child: Text('No hay datos de declaraciones.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futureStats = _fetchStats();
          });
        },
        child: Icon(Icons.refresh),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildErrorView(String error) {
    // (Puedes copiar el widget de error de la página de estadísticas)
    return Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text(error, textAlign: TextAlign.center)));
  }

  // Construye el reporte (SOLO LAS TARJETAS)
  Widget _buildReport(DeclaracionStats data) {
    return GridView.count(
      padding: const EdgeInsets.all(12.0),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.4, // Usamos la misma proporción
      children: [
        StatCard(
          titulo: 'Declaraciones Evaluadas',
          conteo: data.evaluadas,
          icono: Icons.task_alt,
          color: Colors.blueGrey[700]!,
        ),
        StatCard(
          titulo: 'Declaraciones Pendientes',
          conteo: data.pendientes,
          icono: Icons.pending_actions,
          color: Colors.amber[700]!,
        ),
        StatCard(
          titulo: 'Declaraciones Rechazadas',
          conteo: data.rechazadas,
          icono: Icons.gpp_bad,
          color: Colors.red[700]!,
        ),
        StatCard(
          titulo: 'Aprobadas (Pago Pendiente)',
          conteo: data.aprobadasPagoPendiente,
          icono: Icons.credit_score,
          color: Colors.lightGreen[700]!,
        ),
      ],
    );
  }
}