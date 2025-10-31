<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PagoListaPostulante extends Model
{
    use HasFactory;

    /**
     * El nombre de la tabla asociada con el modelo.
     */
    protected $table = 'pagos_lista_postulante';

    /**
     * La clave primaria no es 'id' y no es incremental (si es el caso)
     */
    public $incrementing = false;
    public $timestamps = false; // No parece tener timestamps created_at/updated_at
}