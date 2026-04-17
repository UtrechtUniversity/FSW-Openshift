<?php

namespace App\Console\Commands;

use App\Models\DbHeartbeatEntry;
use Illuminate\Console\Command;
use Illuminate\Support\Str;

class AddDbHeartbeatEntry extends Command
{
    protected $signature = 'heartbeat:add';

    protected $description = 'Insert a heartbeat record with the current timestamp and random text';

    public function handle(): int
    {
        DbHeartbeatEntry::create([
            'recorded_at' => now(),
            'message' => 'Heartbeat '.now()->toDateTimeString().' — '.Str::random(24),
        ]);

        $this->info('Heartbeat entry added.');

        return Command::SUCCESS;
    }
}
