import Echo from 'laravel-echo';

import Pusher from 'pusher-js';
window.Pusher = Pusher;

window.Echo = new Echo({
    broadcaster: 'reverb',
    key: import.meta.env.VITE_REVERB_APP_KEY,
    wsHost: window.location.hostname,
    wssHost: window.location.hostname,
    wsPort: import.meta.env.VITE_REVERB_PORT ?? 6001,
    wssPort: import.meta.env.VITE_REVERB_PORT ?? 6001,
    // forceTLS: (import.meta.env.VITE_REVERB_SCHEME ?? 'https') === 'https',
    forceTLS: false,
    enabledTransports: ['ws', 'wss'],
});

/**
 * Testing Channels & Events & Connections
 */
window.Echo.channel('chattest')
    .listenToAll((event, data) => {
        console.log('[Echo] chattest event:', event, data);
    });

window.addEventListener("load", function() {
    window.Echo.channel("delivery").listen("PackageSent", (event) => {
        console.log('[Echo] delivery PackageSent:', event);
    });
});

