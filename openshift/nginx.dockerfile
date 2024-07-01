FROM nginxinc/nginx-unprivileged:stable-alpine

ADD ./openshift/vhost.conf /etc/nginx/conf.d/default.conf

# Expose port 8443 and start php-fpm server
EXPOSE 8080

#CMD ["nginx", "-g", "daemon off;"]