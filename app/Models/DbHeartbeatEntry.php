<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DbHeartbeatEntry extends Model
{
    public $timestamps = false;

    public $table = 'heartbeat_entries';

    protected $fillable = ['recorded_at', 'message'];

    protected $casts = [
        'recorded_at' => 'datetime',
    ];
}
