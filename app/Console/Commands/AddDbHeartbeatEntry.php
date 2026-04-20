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

        // Delete entries older than 1 week
        $deleted = DbHeartbeatEntry::where('recorded_at', '<', now()->subWeek())->delete();
        if ($deleted > 0) {
            $this->info("Deleted {$deleted} entries older than 1 week.");
        }

        return Command::SUCCESS;
    }
}
