import { defineConfig } from 'vite';
import fs from 'fs';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
import vuetify from 'vite-plugin-vuetify';
import dotenv from 'dotenv';
import path from 'path';

import {viteStaticCopy} from "vite-plugin-static-copy";

dotenv.config() // load env vars from .env

const host = `${process.env.VITE_API_URL ?? 'http://localhost:3000'}`;
const port = `${process.env.VITE_PORT ?? '3000'}`;
console.log('Start vite!!!')
console.log(`Vite server running on ${host}:${port}`);
export default defineConfig({
    plugins: [
        laravel({
            input: [
                'resources/sass/app.scss',
                'resources/js/app.js'
            ],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
        vuetify({
            autoImport: true,
        }),
        viteStaticCopy({
            targets: [
                {
                    src: 'node_modules/circle-flags/flags/',
                    dest: 'images'
                }
            ]
        })
    ],
    resolve: {
        alias: {
            '@': path.resolve(__dirname, 'resources/js'),
        }
    },
    server: {
        https: {
            key: fs.readFileSync('docker/certificates/docker.dev.key'),
            cert: fs.readFileSync('docker/certificates/docker.dev.crt'),
        },
        host: true,
        port: port,
        cors: true,
        hmr: {
            host: host,
            protocol: 'wss'
        },

        // https: {
        //     key: fs.readFileSync('docker/certificates/docker.dev.key'),
        //     cert: fs.readFileSync('docker/certificates/docker.dev.crt'),
        // },
        // host: host,
        // hmr: {
        //     host: host,
        //     clientPort: port,
        //     port: port,
        //     protocol: 'wss'
        // },
    },
});
