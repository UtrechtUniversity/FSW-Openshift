FROM nginxinc/nginx-unprivileged:stable-alpine

## nginx conf is added with nginx-com.yaml
## nginx config is added via 11_nginx-cm.yaml
## ADD ./nginx/vhost.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 8080
EXPOSE 9000
EXPOSE 9001
EXPOSE 7050
EXPOSE 5173

#RUN MKDIR -p /var/www
# copy webapp files
COPY ../public /var/www/html

CMD ["nginx", "-g", "daemon off;"]