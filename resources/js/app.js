import { createApp, h } from 'vue';
import { createInertiaApp } from '@inertiajs/vue3';
import { createVuetify } from 'vuetify';
import * as components from 'vuetify/components';
import * as directives from 'vuetify/directives';
import '@mdi/font/css/materialdesignicons.css';

const appName = window.document.getElementsByTagName('title')[0]?.innerText || 'FSW-Openshift';

const pages = import.meta.glob('./Pages/**/*.vue');

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => {
        const path = `./Pages/${name}.vue`;
        if (!pages[path]) {
            throw new Error(`Page not found: ${name} (looked for ${path})`);
        }
        return pages[path]();
    },
    setup({ el, App, props, plugin }) {
        const vuetify = createVuetify({
            components,
            directives,
            theme: {
                defaultTheme: 'light',
                themes: {
                    light: {
                        colors: {
                            // Utrecht University brand colors
                            primary: '#ffcd00',      // UU Yellow - primary brand color
                            secondary: '#c00a35',    // UU Red/Burgundy - accent color
                            error: '#c00a35',        // UU Red for errors
                            warning: '#ff9800',      // Orange warning
                            info: '#262626',         // Dark text for info
                            success: '#4caf50',      // Green success
                            background: '#ffffff',   // White background
                            surface: '#ffffff',      // White surface
                            'on-primary': '#000000', // Black text on yellow
                            'on-secondary': '#ffffff', // White text on red
                        },
                    },
                },
            },
        });

        createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(vuetify)
            .mount(el);
    },
    progress: {
        color: '#ffcd00', // UU Yellow for progress bar
    },
});
