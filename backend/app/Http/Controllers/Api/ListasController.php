<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ListasController extends Controller
{
    /**
     * Retorna la lista de Sedes desde la tabla catalogo.
     */
    public function getSedes()
    {
        try {
            $sedes = DB::table('catalogo')
                ->where('idtable', 13)
                // ->where('activo', true) // He comentado esto por si acaso, puedes descomentarlo si es necesario
                ->select('id', 'nombre')
                ->orderBy('nombre')
                ->get();
            
            return response()->json($sedes);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al obtener la lista de sedes.',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}