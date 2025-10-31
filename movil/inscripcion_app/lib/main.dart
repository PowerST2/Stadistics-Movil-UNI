import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Importa las páginas
import 'pages/home_page.dart';
import 'pages/estadisticas_page.dart';
import 'pages/stats_detalle_page.dart';
import 'pages/stats_descuento_page.dart';
// ¡NUEVA PÁGINA!
import 'pages/stats_declaracion_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIAD - Estadísticas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF003366), // Azul UNI
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003366),
          elevation: 4,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // --- RUTAS ACTUALIZADAS ---
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/estadisticas': (context) => const EstadisticasPage(),
        '/stats-detalle': (context) => const StatsDetallePage(),
        '/stats-descuento': (context) => const StatsDescuentoPage(),
        // ¡NUEVA RUTA!
        '/stats-declaracion': (context) => const StatsDeclaracionPage(),
      },
    );
  }
}