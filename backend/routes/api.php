<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\DatosController;
use App\Http\Controllers\Api\EstadisticasController; 
use App\Http\Controllers\Api\ListasController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// --- RUTAS SIMPLIFICADAS ---

// 1. Ruta de Estadísticas Generales (Dashboard)
Route::get('/estadisticas', [EstadisticasController::class, 'dashboard']);

// 2. Ruta para estadísticas de Inscritos por Modalidad
Route::get('/estadisticas/por-modalidad', [EstadisticasController::class, 'getStatsPorModalidad']);

// 3. Ruta para estadísticas de Pagos por Sede
Route::get('/estadisticas/pagos-por-sede', [EstadisticasController::class, 'getStatsPagosPorSede']);

// 4. Ruta para estadísticas de Descuentos
Route::get('/estadisticas/por-descuento', [EstadisticasController::class, 'getStatsPorDescuento']);

// 5. Ruta para estadísticas de Inscritos por Especialidad
Route::get('/estadisticas/por-especialidad', [EstadisticasController::class, 'getStatsPorEspecialidad']);

// 6. (RE-INTRODUCIDA) Ruta para el detalle del postulante
Route::get('/postulante/detalle/{dni}', [DatosController::class, 'getDetallePorDni']);

// 7. (NUEVA) Ruta para la lista de Sedes (para el ComboBox)
Route::get('/listas/sedes', [ListasController::class, 'getSedes']);

// 8. (NUEVA) Ruta para el nuevo reporte de Declaraciones
Route::get('/estadisticas/declaraciones-pendientes', [EstadisticasController::class, 'getDeclaracionesPendientes']);

//9. Estadísticas de Declaración Jurada
Route::get('/estadisticas/declaracion-jurada', [EstadisticasController::class, 'getStatsDeclaracionJurada']);