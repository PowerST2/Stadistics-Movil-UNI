import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../estadisticas_model.dart';
import 'stats_detalle_page.dart';
// ¡Importamos el nuevo widget de tarjeta!
import '../widgets/stat_card.dart';

const String API_BASE_URL = 'http://172.20.68.99:8001/api/estadisticas';

// ¡VOLVEMOS AL MODELO SIMPLE!
// Esta página ya no necesita los datos de declaración.
class EstadisticasPage extends StatefulWidget {
  const EstadisticasPage({Key? key}) : super(key: key);

  @override
  _EstadisticasPageState createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  // El Future ahora solo carga las estadísticas generales
  late Future<EstadisticasDashboard> _futureGeneralStats;

  @override
  void initState() {
    super.initState();
    _futureGeneralStats = _fetchGeneralStats();
  }

  // Este Future solo llama al endpoint principal
  Future<EstadisticasDashboard> _fetchGeneralStats() async {
    final timeout = const Duration(seconds: 15);
    try {
      final response = await http.get(Uri.parse(API_BASE_URL)).timeout(timeout);

      if (response.statusCode == 200) {
        return EstadisticasDashboard.fromApiJson(jsonDecode(response.body));
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

  // --- WIDGET PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Estadísticas'),
      ),
      body: FutureBuilder<EstadisticasDashboard>( // <-- Vuelve a ser Future<EstadisticasDashboard>
        future: _futureGeneralStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData) {
            // Pasamos los datos a la vista principal
            return _buildDashboard(snapshot.data!);
          }
          return Center(child: Text('No hay datos.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futureGeneralStats = _fetchGeneralStats(); // Vuelve a cargar todo
          });
        },
        child: Icon(Icons.refresh),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // --- SUB-WIDGETS DE CONSTRUCCIÓN ---

  // Vista de Error
  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.red[700], size: 50),
            SizedBox(height: 16),
            Text('Error al Cargar Estadísticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  // El Dashboard principal, ahora con 2 secciones
  Widget _buildDashboard(EstadisticasDashboard data) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        // --- SECCIÓN 1: Resumen General ---
        _buildSectionTitle('Resumen General'),
        _buildGeneralSection(data),

        // --- SECCIÓN 2: Reportes Detallados ---
        _buildSectionTitle('Reportes Detallados'),
        _buildNavButton(
          context: context,
          title: 'Estadísticas por Sede',
          icon: Icons.public,
          color: Colors.blue[800]!,
          routeName: '/stats-detalle',
          arguments: StatsDetalleArgs(
            titulo: 'Reporte por Sede',
            apiUrl: '$API_BASE_URL/pagos-por-sede',
            labelColumn: 'sede',
          ),
        ),
        _buildNavButton(
          context: context,
          title: 'Estadísticas por Modalidad',
          icon: Icons.school,
          color: Colors.green[800]!,
          routeName: '/stats-detalle',
          arguments: StatsDetalleArgs(
            titulo: 'Reporte por Modalidad',
            apiUrl: '$API_BASE_URL/por-modalidad',
            labelColumn: 'nombre',
          ),
        ),
        _buildNavButton(
          context: context,
          title: 'Estadísticas por Especialidad',
          icon: Icons.engineering,
          color: Colors.deepPurple[700]!,
          routeName: '/stats-detalle',
          arguments: StatsDetalleArgs(
            titulo: 'Reporte por Especialidad',
            apiUrl: '$API_BASE_URL/por-especialidad',
            labelColumn: 'nombre',
          ),
        ),
        _buildNavButton(
          context: context,
          title: 'Reporte de Descuentos',
          icon: Icons.percent,
          color: Colors.orange[800]!,
          routeName: '/stats-descuento',
          arguments: null,
        ),

        // --- ¡NUEVO BOTÓN DE NAVEGACIÓN! ---
        _buildNavButton(
          context: context,
          title: 'Reporte de Declaraciones',
          icon: Icons.checklist_rtl,
          color: Colors.red[700]!,
          routeName: '/stats-declaracion', // <-- Nueva ruta
          arguments: null,
        ),
      ],
    );
  }

  // Helper para títulos de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, letterSpacing: 0.8)),
    );
  }

  // SECCIÓN 1: Resumen General (Sin cambios)
  Widget _buildGeneralSection(EstadisticasDashboard data) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 1.4,
      children: [
        // ¡USA EL WIDGET CORREGIDO!
        StatCard(titulo: 'Pre-Inscritos', conteo: data.totalPreinscritos, icono: Icons.person_add, color: Colors.blue),
        StatCard(titulo: 'Inscritos (Ficha OK)', conteo: data.totalInscritos, icono: Icons.check_circle, color: Colors.green),
        StatCard(titulo: 'Pagaron Prospecto', conteo: data.pagaronProspecto, icono: Icons.article, color: Colors.teal),
        StatCard(titulo: 'Pagaron Examen', conteo: data.pagaronExamen, icono: Icons.school, color: Colors.purple),
      ],
    );
  }

  // (Se eliminó la 'buildDeclaracionSection')

  // Widget para los botones de navegación (Sin cambios)
  Widget _buildNavButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String routeName,
    required Object? arguments,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 36, color: color),
        title: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
        onTap: () {
          Navigator.pushNamed(context, routeName, arguments: arguments);
        },
      ),
    );
  }
}