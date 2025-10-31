class Postulante {
  // --- Campos de la Lista ---
  final String numeroIdentificacion;
  final String nombres;
  final String paterno;
  final String materno;

  // --- Campos del Detalle (pueden ser nulos en la lista) ---
  final String? codigo;
  final String? modalidad;
  final String? especialidad;
  final String? institucion;
  final String? gestion;
  final String? email;
  final String? telefonoCelular;
  final String? telefonoFijo;
  final String? fotoEstado;
  final bool? pagoProspecto;
  final bool? pagoExamen;

  Postulante({
    required this.numeroIdentificacion,
    required this.nombres,
    required this.paterno,
    required this.materno,
    this.codigo,
    this.modalidad,
    this.especialidad,
    this.institucion,
    this.gestion,
    this.email,
    this.telefonoCelular,
    this.telefonoFijo,
    this.fotoEstado,
    this.pagoProspecto,
    this.pagoExamen,
  });

  // Constructor que lee el JSON de la API
  factory Postulante.fromApiJson(Map<String, dynamic> json) {
    // Maneja el JSON anidado de pagos (para la vista de detalle)
    final Map<String, dynamic>? pagos = json['detalle_pagos'] as Map<String, dynamic>?;

    return Postulante(
      // Campos requeridos (vienen en la lista y el detalle)
      numeroIdentificacion: json['numero_identificacion'] ?? '',
      nombres: json['nombres'] ?? '',
      paterno: json['paterno'] ?? '',
      materno: json['materno'] ?? '',

      // Campos solo de detalle
      codigo: json['codigo'],
      modalidad: json['modalidad'], // Asumiendo que tu API los devuelve como String
      especialidad: json['especialidad'],
      institucion: json['institucion'],
      gestion: json['gestion'],
      email: json['email'],
      telefonoCelular: json['telefono_celular'],
      telefonoFijo: json['telefono_fijo'],
      fotoEstado: json['foto_estado'],

      // Lógica de Pagos (para el detalle)
      pagoProspecto: (pagos?['prospecto'] as bool?) ?? false,
      pagoExamen: (pagos?['examen'] as bool?) ?? false,
    );
  }

  // Helper para obtener nombre completo
  String get nombreCompleto => '$paterno $materno, $nombres';
}