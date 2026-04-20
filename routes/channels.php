<?php

use App\Models\User;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\Log;

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
|
| Here you may register all of the event broadcasting channels that your
| application supports. The given channel authorization callbacks are
| used to check if an authenticated user can listen to the channel.
|
*/

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

/*
|--------------------------------------------------------------------------
| Chat Presence Channel
|--------------------------------------------------------------------------
|
| This presence channel allows authenticated users to chat with each other.
| Returns user info that will be available to all channel subscribers.
|
*/
Broadcast::channel('chat', function (User $user) {
    Log::info('Chat channel authorization', [
        'user_id' => $user->id,
        'user_name' => $user->name,
    ]);

    return [
        'id' => $user->id,
        'name' => $user->name,
    ];
});
