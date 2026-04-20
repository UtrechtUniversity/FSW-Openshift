<?php

namespace App\Http\Controllers;

use App\Models\DbHeartbeatEntry;
use Illuminate\Support\Str;
use Inertia\Inertia;

class DbHeartbeatController extends Controller
{
    public function index()
    {
        $entries = DbHeartbeatEntry::orderByDesc('recorded_at')->paginate(50);

        return Inertia::render('DbHeartbeat/Index', [
            'entries' => $entries,
        ]);
    }

    public function store()
    {
        DbHeartbeatEntry::create([
            'recorded_at' => now(),
            'message' => 'Manual '.now()->toDateTimeString().' — '.Str::random(24),
        ]);

        return redirect()->route('db-heartbeat')->with('success', 'Record added manually.');
    }
}
