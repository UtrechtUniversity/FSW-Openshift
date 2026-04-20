<?php

use App\Models\Role;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Check if the role already exists
        if (! DB::table('roles')->where('id', 3)->exists()) {
            DB::table('roles')->insert([
                'id' => 3,
                'name' => 'not_validated',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Only delete if no users have this role
        $usersWithRole = DB::table('users')->where('role_id', 3)->count();
        if ($usersWithRole === 0) {
            DB::table('roles')->where('id', 3)->delete();
        }
    }
};
