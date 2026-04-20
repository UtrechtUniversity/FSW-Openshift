<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class UserController extends Controller
{
    /**
     * Display a listing of users.
     */
    public function index()
    {
        return Inertia::render('Users/Index', [
            'users' => User::with('role')
                ->orderBy('name')
                ->paginate(15)
                ->through(fn ($user) => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'solis_id' => $user->solis_id,
                    'role_id' => $user->role_id,
                    'role_name' => $user->role->name ?? 'N/A',
                    'created_at' => $user->created_at?->format('Y-m-d H:i'),
                    'is_not_validated' => $user->role_id === Role::NOT_VALIDATED,
                ]),
        ]);
    }

    /**
     * Show the form for creating a new user.
     */
    public function create()
    {
        return Inertia::render('Users/Create', [
            'roles' => Role::select('id', 'name')->get(),
        ]);
    }

    /**
     * Store a newly created user in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'solis_id' => ['required', 'string', 'max:255'],
            'role_id' => ['required', 'exists:roles,id'],
        ]);

        User::create([
            'solis_id' => $validated['solis_id'],
            'role_id' => $validated['role_id'],
        ]);

        return redirect()->route('users.index')->with('success', 'User created successfully.');
    }

    /**
     * Show the form for editing the specified user.
     */
    public function edit(User $user)
    {
        return Inertia::render('Users/Edit', [
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'solis_id' => $user->solis_id,
                'role_id' => $user->role_id,
            ],
            'roles' => Role::select('id', 'name')->get(),
        ]);
    }

    /**
     * Update the specified user in storage.
     */
    public function update(Request $request, User $user)
    {
        $validated = $request->validate([
            'solis_id' => ['required', 'string', 'max:255'],
            'role_id' => ['required', 'exists:roles,id'],
        ]);

        $user->update([
            'solis_id' => $validated['solis_id'],
            'role_id' => $validated['role_id'],
        ]);

        return redirect()->route('users.index')->with('success', 'User updated successfully.');
    }

    /**
     * Remove the specified user from storage.
     */
    public function destroy(User $user)
    {
        $user->delete();

        return redirect()->route('users.index')->with('success', 'User deleted successfully.');
    }

    /**
     * Validate a not_validated user by changing their role to user.
     */
    public function validateUser(User $user)
    {
        if ($user->role_id !== Role::NOT_VALIDATED) {
            return redirect()->route('users.index')->with('error', 'User is already validated.');
        }

        $user->update([
            'role_id' => Role::USER,
        ]);

        return redirect()->route('users.index')->with('success', 'User validated successfully.');
    }
}
