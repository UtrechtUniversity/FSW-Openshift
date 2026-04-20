<?php

namespace App\Http\Controllers;

use App\Models\Migration;
use Inertia\Inertia;

class MigrationController extends Controller
{
    /**
     * Display a listing of migrations.
     */
    public function index()
    {
        return Inertia::render('Migrations/Index', [
            'migrations' => Migration::orderBy('batch')
                ->orderBy('id', 'DESC')
                ->paginate(15)
                ->through(fn ($migration) => [
                    'id' => $migration->id,
                    'migration' => $migration->migration,
                    'batch' => $migration->batch,
                ]),
        ]);
    }
}
