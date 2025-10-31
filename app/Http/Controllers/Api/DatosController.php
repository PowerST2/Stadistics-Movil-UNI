<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

// Añadimos los modelos que vamos a usar
use App\Models\Postulante;
use App\Models\PagoListaPostulante; // Aún lo usamos para saber QUÉ cobrar
use App\Models\Recaudacion; // Asumiendo que tienes un modelo Recaudacion

class DatosController extends Controller
{
    /**
     * ¡LÓGICA CORREGIDA!
     * Retorna el detalle completo de un postulante
     * validando los pagos contra 'recaudacion'.
     */
    public function getDetallePorDni($dni)
    {
        try {
            $postulante = Postulante::where('numero_identificacion', $dni)->firstOrFail();

            // --- Lógica de Pagos basada en 'recaudacion' ---

            // 1. Verificamos si pagó Prospecto (servicio '475')
            $pago_prospecto = DB::table('recaudacion')
                                ->where('idpostulante', $postulante->id)
                                ->where('servicio', '475')
                                ->exists();
            
            // 2. Verificamos si pagó Examen
            // Primero, vemos qué servicio de examen le toca
            $servicio_examen = PagoListaPostulante::where('idpostulante', $postulante->id)
                                                  ->where('servicio', '!=', '475')
                                                  ->value('servicio'); // ej. '526', '528', etc.
            
            $pago_examen = false;
            if ($servicio_examen) {
                // Si tiene un servicio de examen asignado, vemos si está en recaudación
                $pago_examen = DB::table('recaudacion')
                                 ->where('idpostulante', $postulante->id)
                                 ->where('servicio', $servicio_examen)
                                 ->exists();
            }

            // 3. Añadimos la información de pago REAL al objeto postulante
            $postulante->detalle_pagos = [
                'prospecto' => $pago_prospecto,
                'examen' => $pago_examen
            ];

            return response()->json($postulante);

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['error' => 'Postulante no encontrado.'], 404);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al obtener el detalle.',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}