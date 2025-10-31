// Modelo para la SECCIÓN 1 (Resumen General)
class EstadisticasDashboard {
  final int totalPreinscritos;
  final int totalInscritos;
  final int pagantesAmbos;
  final int pagaronProspecto;
  final int pagaronExamen;

  EstadisticasDashboard({
    required this.totalPreinscritos,
    required this.totalInscritos,
    required this.pagantesAmbos,
    required this.pagaronProspecto,
    required this.pagaronExamen,
  });

  // Constructor que lee el JSON de tu API de Laravel
  factory EstadisticasDashboard.fromApiJson(Map<String, dynamic> json) {
    return EstadisticasDashboard(
      totalPreinscritos: (json['total_preinscritos'] as num?)?.toInt() ?? 0,
      totalInscritos: (json['total_inscritos'] as num?)?.toInt() ?? 0,
      pagantesAmbos: (json['pagantes_ambos'] as num?)?.toInt() ?? 0,
      pagaronProspecto: (json['desglose_pagos']?['prospecto'] as num?)?.toInt() ?? 0,
      pagaronExamen: (json['desglose_pagos']?['examen'] as num?)?.toInt() ?? 0,
    );
  }
}

// ¡NUEVO MODELO!
// Modelo para la SECCIÓN 3 (Declaraciones Juradas)
class DeclaracionStats {
  final int evaluadas;
  final int rechazadas;
  final int pendientes;
  final int aprobadasPagoPendiente;

  DeclaracionStats({
    required this.evaluadas,
    required this.rechazadas,
    required this.pendientes,
    required this.aprobadasPagoPendiente,
  });

  factory DeclaracionStats.fromApiJson(Map<String, dynamic> json) {
    return DeclaracionStats(
      evaluadas: (json['evaluadas'] as num?)?.toInt() ?? 0,
      rechazadas: (json['rechazadas'] as num?)?.toInt() ?? 0,
      pendientes: (json['pendientes'] as num?)?.toInt() ?? 0,
      aprobadasPagoPendiente: (json['aprobadas_pago_pendiente'] as num?)?.toInt() ?? 0,
    );
  }
}