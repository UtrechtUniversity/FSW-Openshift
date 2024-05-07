#!/usr/bin/env sh

if [ "$APP_ENV" = "local" ]; then
    echo "⭐️ Start dev server"
    npm run dev
fi
