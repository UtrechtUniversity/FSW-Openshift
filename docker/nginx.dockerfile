FROM nginx:1.10-alpine
# entrypoint
COPY ./docker/nginx-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh

ENTRYPOINT /entrypoint.sh
