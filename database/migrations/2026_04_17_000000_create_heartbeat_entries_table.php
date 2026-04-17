<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('heartbeat_entries', function (Blueprint $table) {
            $table->id();
            $table->timestamp('recorded_at')->useCurrent();
            $table->string('message');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('heartbeat_entries');
    }
};
