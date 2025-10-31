import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uniColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: uniColor, // Fondo azul UNI
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Logo Placeholder ---
              Icon(
                Icons.school, // Icono de la UNI
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),

              Text(
                'DIRECCIÓN DE ADMISIÓN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                'Universidad Nacional de Ingeniería',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 60),

              // --- Botón de Estadísticas ---
              ElevatedButton.icon(
                icon: Icon(Icons.bar_chart, size: 28),
                label: Text('Ver Panel de Estadísticas'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: uniColor, // Color del texto (azul)
                  backgroundColor: Colors.white, // Color del botón (blanco)
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Botón redondeado
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/estadisticas');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}