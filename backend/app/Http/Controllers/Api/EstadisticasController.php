<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Postulante;
use App\Models\PagoListaPostulante;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class EstadisticasController extends Controller
{
    /**
     * Devuelve las estadísticas principales del dashboard.
     * (Este método está bien, no cambia)
     */
    public function dashboard(Request $request)
    {
        try {
            $totalPreinscritos = Postulante::count();

            $pagaronProspecto = PagoListaPostulante::where('servicio', '475')
                                                   ->where('pago', true)
                                                   ->count();

            $pagaronExamen = PagoListaPostulante::where('servicio', '!=', '475')
                                                ->where('pago', true)
                                                ->count();

            $pagantesAmbos = DB::table('pagos_lista_postulante as p1')
                ->join('pagos_lista_postulante as p2', 'p1.idpostulante', '=', 'p2.idpostulante')
                ->where('p1.servicio', '475')
                ->where('p1.pago', true)
                ->where('p2.servicio', '!=', '475')
                ->where('p2.pago', true)
                ->distinct('p1.idpostulante')
                ->count('p1.idpostulante');
            
            $totalInscritos = Postulante::whereNotNull('ficha_fecha')->count();

            return response()->json([
                'total_preinscritos' => $totalPreinscritos,
                'total_inscritos' => $totalInscritos,
                'pagantes_ambos' => $pagantesAmbos,
                'desglose_pagos' => [
                    'prospecto' => $pagaronProspecto,
                    'examen' => $pagaronExamen,
                ]
            ]);

        } catch (\Exception $e) {
            return $this->handleError($e);
        }
    }

    /**
     * ¡REESCRITO! Retorna el desglose completo por modalidad.
     */
    public function getStatsPorModalidad()
    {
        try {
            $expression = "COALESCE(m.codigo, 'No Especificada')";

            $stats = DB::table('postulante as p')
                // Une con modalidad
                ->leftJoin('modalidad as m', 'p.idmodalidad', '=', 'm.id')
                
                // Joins para pagos
                ->leftJoin('pagos_lista_postulante as plp_prospecto', function ($join) {
                    $join->on('p.id', '=', 'plp_prospecto.idpostulante')
                         ->where('plp_prospecto.servicio', '=', '475')
                         ->where('plp_prospecto.pago', '=', true);
                })
                ->leftJoin('pagos_lista_postulante as plp_examen', function ($join) {
                    $join->on('p.id', '=', 'plp_examen.idpostulante')
                         ->where('plp_examen.servicio', '!=', '475')
                         ->where('plp_examen.pago', '=', true);
                })
                
                ->select(
                    DB::raw("$expression as nombre"), // Usamos 'codigo' de modalidad como 'nombre'
                    DB::raw('COUNT(DISTINCT p.id) as inscritos'),
                    DB::raw('COUNT(DISTINCT plp_prospecto.idpostulante) as pagaron_prospecto'),
                    DB::raw('COUNT(DISTINCT plp_examen.idpostulante) as pagaron_examen'),
                    DB::raw('COUNT(DISTINCT CASE WHEN plp_prospecto.pago = true AND plp_examen.pago = true THEN p.id ELSE NULL END) as pagaron_ambos')
                )
                ->whereNotNull('p.ficha_fecha') // Solo inscritos
                ->groupBy(DB::raw($expression)) // Agrupamos por la expresión
                ->orderBy('inscritos', 'desc')
                ->get();
                
            return response()->json($stats);
        } catch (\Exception $e) {
            return $this->handleError($e);
        }
    }

    /**
     * Retorna el conteo de inscritos y pagos, agrupados por sede.
     * (Este método está bien, no cambia)
     */
    public function getStatsPagosPorSede()
    {
        try {
            $expression = "COALESCE(s.nombre, 'No Especificada')";

            $stats = DB::table('postulante as p')
                ->leftJoin('catalogo as s', function ($join) {
                    $join->on('p.idsede', '=', 's.id')
                         ->where('s.idtable', '=', 13);
                })
                ->leftJoin('pagos_lista_postulante as plp_prospecto', function ($join) {
                    $join->on('p.id', '=', 'plp_prospecto.idpostulante')
                         ->where('plp_prospecto.servicio', '=', '475')
                         ->where('plp_prospecto.pago', '=', true);
                })
                ->leftJoin('pagos_lista_postulante as plp_examen', function ($join) {
                    $join->on('p.id', '=', 'plp_examen.idpostulante')
                         ->where('plp_examen.servicio', '!=', '475')
                         ->where('plp_examen.pago', '=', true);
                })
                ->select(
                    DB::raw("$expression as sede"), 
                    DB::raw('COUNT(DISTINCT p.id) as inscritos'),
                    DB::raw('COUNT(DISTINCT plp_prospecto.idpostulante) as pagaron_prospecto'),
                    DB::raw('COUNT(DISTINCT plp_examen.idpostulante) as pagaron_examen'),
                    DB::raw('COUNT(DISTINCT CASE WHEN plp_prospecto.pago = true AND plp_examen.pago = true THEN p.id ELSE NULL END) as pagaron_ambos')
                )
                ->whereNotNull('p.ficha_fecha')
                ->groupBy(DB::raw($expression)) 
                ->orderBy('inscritos', 'desc')
                ->get();
                
            return response()->json($stats);
        } catch (\Exception $e) {
            return $this->handleError($e);
        }
    }

    /**
     * ¡NUEVO! Retorna el desglose completo por especialidad.
     */
    public function getStatsPorEspecialidad()
    {
        try {
            // Asumimos que la tabla se llama 'especialidad' y tiene 'nombre'
            $expression = "COALESCE(e.nombre, 'No Especificada')";

            $stats = DB::table('postulante as p')
                // Une con especialidad
                ->leftJoin('especialidad as e', 'p.idespecialidad', '=', 'e.id')
                
                // Joins para pagos
                ->leftJoin('pagos_lista_postulante as plp_prospecto', function ($join) {
                    $join->on('p.id', '=', 'plp_prospecto.idpostulante')
                         ->where('plp_prospecto.servicio', '=', '475')
                         ->where('plp_prospecto.pago', '=', true);
                })
                ->leftJoin('pagos_lista_postulante as plp_examen', function ($join) {
                    $join->on('p.id', '=', 'plp_examen.idpostulante')
                         ->where('plp_examen.servicio', '!=', '475')
                         ->where('plp_examen.pago', '=', true);
                })
                
                ->select(
                    DB::raw("$expression as nombre"), // Usamos 'nombre' de especialidad
                    DB::raw('COUNT(DISTINCT p.id) as inscritos'),
                    DB::raw('COUNT(DISTINCT plp_prospecto.idpostulante) as pagaron_prospecto'),
                    DB::raw('COUNT(DISTINCT plp_examen.idpostulante) as pagaron_examen'),
                    DB::raw('COUNT(DISTINCT CASE WHEN plp_prospecto.pago = true AND plp_examen.pago = true THEN p.id ELSE NULL END) as pagaron_ambos')
                )
                ->whereNotNull('p.ficha_fecha') // Solo inscritos
                ->groupBy(DB::raw($expression)) // Agrupamos por la expresión
                ->orderBy('inscritos', 'desc')
                ->get();
                
            return response()->json($stats);
        } catch (\Exception $e) {
            return $this->handleError($e);
        }
    }

    /**
     * Retorna el conteo de descuentos (becas) por tipo.
     * (Este método está bien, no cambia)
     */
    public function getStatsPorDescuento()
    {
        try {
            $stats = DB::table('descuento')
                ->where('activo', true)
                ->select('tipo', DB::raw('count(*) as total'))
                ->groupBy('tipo')
                ->get();
            return response()->json($stats);
        } catch (\Exception $e) {
            return $this->handleError($e);
        }
    }

    public function getStatsDeclaracionJurada(Request $request)
    {
        try {
            
            // 1. IDs de los que pagaron AMBOS (lógica de 'recaudacion')
            $pagaronProspectoIds = DB::table('recaudacion')
                ->where('servicio', '475')
                ->distinct()
                ->pluck('idpostulante');
            
            $pagaronExamenIds = DB::table('recaudacion')
                ->where('servicio', '!=', '475')
                ->distinct()
                ->pluck('idpostulante');

            $pagaronTodoIds = array_intersect($pagaronProspectoIds->all(), $pagaronExamenIds->all());

            // 2. Conteo de Declaraciones Aprobadas con Pagos Pendientes
            // (Declaración APROBADO Y no está en la lista de $pagaronTodoIds)
            $aprobadas_pago_pendiente = DB::table('declaracion_evaluacion')
                ->where('estado', 'APROBADO')
                ->whereNotIn('idpostulante', $pagaronTodoIds)
                ->count();
            
            // 3. Conteo de Rechazadas
            $rechazadas = DB::table('declaracion_evaluacion')
                ->where('estado', 'DENEGADO')
                ->count();
            
            // 4. Conteo de Pendientes
            $pendientes = DB::table('declaracion_evaluacion')
                ->where('estado', 'PENDIENTE')
                ->count();
            
            // 5. Conteo de Evaluadas (Total - Pendientes)
            $evaluadas = DB::table('declaracion_evaluacion')
                ->where('estado', '!=', 'PENDIENTE')
                ->count();
            
            return response()->json([
                'evaluadas' => $evaluadas,
                'rechazadas' => $rechazadas,
                'pendientes' => $pendientes,
                'aprobadas_pago_pendiente' => $aprobadas_pago_pendiente,
            ]);

        } catch (\Exception $e) {
            return $this->handleError($e);
        }
    }

    // Helper de errores (sin cambios)
    private function handleError(\Exception $e)
    {
        return response()->json([
            'error' => 'Error al procesar la solicitud.',
            'message' => $e->getMessage()
        ], 500);
    }
}