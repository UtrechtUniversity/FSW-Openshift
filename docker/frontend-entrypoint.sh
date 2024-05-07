#!/usr/bin/env sh
# get the owner of the current directory
dirOwner=$(ls -ld . | awk '{print $3}')


echo "⭐️ Start dev server"
npm run dev
