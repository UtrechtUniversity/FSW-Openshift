<?php

namespace App\Http\Controllers;

use App\Events\MessageSent;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Inertia\Inertia;

class ChatController extends Controller
{
    /**
     * Display the chat page.
     */
    public function index()
    {
        Log::info('Chat page accessed', [
            'user_id' => Auth::id(),
            'user_name' => Auth::user()?->name,
        ]);

        return Inertia::render('Chat/Index');
    }

    /**
     * Send a chat message.
     */
    public function sendMessage(Request $request)
    {
        Log::info('Chat message received', [
            'user_id' => Auth::id(),
            'message_length' => strlen($request->input('message', '')),
        ]);

        $request->validate([
            'message' => 'required|string|max:1000',
        ]);

        /** @var User $user */
        $user = Auth::user();
        $message = $request->input('message');

        Log::info('Broadcasting chat message', [
            'user_id' => $user->id,
            'user_name' => $user->name,
            'message' => $message,
        ]);

        // Broadcast the message to all connected users
        try {
            broadcast(new MessageSent($user, $message))->toOthers();
            Log::info('Chat message broadcast successful');
        } catch (\Exception $e) {
            Log::error('Chat message broadcast failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'error' => 'Failed to broadcast message: '.$e->getMessage(),
            ], 500);
        }

        return response()->json([
            'success' => true,
            'message' => [
                'message' => $message,
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                ],
                'timestamp' => now()->toIso8601String(),
            ],
        ]);
    }
}
