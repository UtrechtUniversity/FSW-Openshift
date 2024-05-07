#!/usr/bin/env sh
# get the owner of the current directory
dirOwner=$(ls -ld . | awk '{print $3}')
ls -la

echo "👨 all user: "
cut -d: -f1 /etc/passwd

echo "👨 current user: "
whoami
echo "👨 Dir owner: $dirOwner"

echo "⭐️ Install npm packages"
npm install

echo "⭐️ Build npm packages"
npm run build

echo "⭐️ Change node_modules user"
chown $dirOwner ./node_modules -R

echo "⭐️ Start dev server"
npm run dev
