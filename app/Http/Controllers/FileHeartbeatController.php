<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Inertia\Inertia;

class FileHeartbeatController extends Controller
{
    private const DIR = 'files';

    public function index()
    {
        $files = [];

        if (Storage::exists(self::DIR)) {
            $all = Storage::files(self::DIR);

            // Sort newest first by filename (filenames start with timestamp)
            rsort($all);

            foreach ($all as $path) {
                $files[] = [
                    'name' => basename($path),
                    'path' => Storage::path($path),
                    'size' => Storage::size($path),
                    'content' => trim(Storage::get($path)),
                ];
            }
        }

        return Inertia::render('FileHeartbeat/Index', [
            'files' => $files,
        ]);
    }

    public function store()
    {
        $now = now();
        $filename = self::DIR.'/'.$now->format('Y-m-d_H-i-s').'_'.Str::random(8).'.txt';
        $content = '['.$now->toDateTimeString().'] Manual — '.Str::random(24).PHP_EOL;

        Storage::put($filename, $content);

        return redirect()->route('file-heartbeat')->with('success', 'File created: '.basename($filename));
    }
}
