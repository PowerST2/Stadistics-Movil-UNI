import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatCard extends StatelessWidget {
  final String titulo;
  final int conteo;
  final IconData icono;
  final Color color;

  const StatCard({
    Key? key,
    required this.titulo,
    required this.conteo,
    required this.icono,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern('es_PE');

    return Card(
      elevation: 2,
      color: color.withOpacity(0.9),
      child: Padding(
        // --- ¡CORRECCIÓN FINAL DE OVERFLOW! ---
        // 1. Reducimos el padding vertical de 12 a 10 (ganamos 4px)
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mantenemos este
          children: [
            // 2. Mantenemos el ícono en 26, es un buen tamaño
            Icon(icono, size: 26, color: Colors.white),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  numberFormat.format(conteo),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // 3. Reducimos la fuente del título de 13 a 12 (ganamos 1-2px)
                Text(
                  titulo,
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}