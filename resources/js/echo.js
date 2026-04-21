import Echo from 'laravel-echo';

import Pusher from 'pusher-js';
window.Pusher = Pusher;

// Use runtime config from blade template, fallback to Vite env for local dev
const reverbConfig = window.reverbConfig || {};
const reverbKey = reverbConfig.key || import.meta.env.VITE_REVERB_APP_KEY;
const reverbPort = reverbConfig.port || import.meta.env.VITE_REVERB_PORT || 443;
const reverbScheme = reverbConfig.scheme || import.meta.env.VITE_REVERB_SCHEME || 'https';

window.Echo = new Echo({
    broadcaster: 'reverb',
    key: reverbKey,
    wsHost: window.location.hostname,
    wssHost: window.location.hostname,
    wsPort: reverbPort,
    wssPort: reverbPort,
    forceTLS: reverbScheme === 'https',
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

