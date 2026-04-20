<?php

namespace App\Console\Commands;

use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class AddFileHeartbeatEntry extends Command
{
    protected $signature = 'heartbeat:add-file';

    protected $description = 'Create a new heartbeat file in storage/app/files/ with timestamp and random text';

    private const DIR = 'files';

    public function handle(): int
    {
        $now = now();
        $filename = self::DIR.'/'.$now->format('Y-m-d_H-i-s').'_'.Str::random(8).'.txt';
        $content = '['.$now->toDateTimeString().'] Heartbeat — '.Str::random(24).PHP_EOL;

        Storage::put($filename, $content);

        $this->info('File heartbeat created: '.$filename);

        // Delete files older than 1 week
        $oneWeekAgo = now()->subWeek();
        $deleted = 0;
        foreach (Storage::files(self::DIR) as $file) {
            $lastModified = Carbon::createFromTimestamp(Storage::lastModified($file));
            if ($lastModified->lt($oneWeekAgo)) {
                Storage::delete($file);
                $deleted++;
            }
        }
        if ($deleted > 0) {
            $this->info("Deleted {$deleted} files older than 1 week.");
        }

        return Command::SUCCESS;
    }
}
