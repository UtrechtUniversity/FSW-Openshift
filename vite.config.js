import { defineConfig } from 'vite';
import fs from 'fs';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        https: {
            key: fs.readFileSync('docker/certificates/docker.dev.key'),
            cert: fs.readFileSync('docker/certificates/docker.dev.crt'),
        },
        host: true,
        port: 7050,
        hmr: {
            host: 'openshift.docker.dev',
            protocol: 'wss'
        },
    },
});
