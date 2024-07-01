FROM nginxinc/nginx-unprivileged:stable-alpine

ADD ./docker/vhost.conf /etc/nginx/conf.d/default.conf
EXPOSE 443
