FROM node:20-alpine
# set workdir
RUN mkdir -p /var/www/
WORKDIR /var/www

RUN apk add --no-cache git

# copy webapp files
COPY .. /var/www
RUN npm install
RUN npm run build

RUN chmod -R a+rw vite.conifg.js
RUN chmod -R a+rw /var/www/public/build

# entrypoint
COPY ./docker/frontend-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh
RUN dos2unix /entrypoint.sh

ENTRYPOINT /entrypoint.sh
