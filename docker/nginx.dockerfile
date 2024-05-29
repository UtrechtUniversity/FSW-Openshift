FROM nginx:1.10-alpine

RUN echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "
ADD ./docker/vhost.conf /etc/nginx/conf.d/default.conf
