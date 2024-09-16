FROM nginxinc/nginx-unprivileged:stable-alpine

ADD ./openshift/vhost.conf /etc/nginx/conf.d/default.conf

# Expose port 8443 and start php-fpm server
EXPOSE 8080
EXPOSE 7050
EXPOSE 5173
#CMD ["nginx", "-g", "daemon off;"]