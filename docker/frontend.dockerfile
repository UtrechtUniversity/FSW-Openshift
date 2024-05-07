FROM node:20-alpine

# entrypoint
COPY ./docker/frontend-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh
RUN dos2unix /entrypoint.sh

ENTRYPOINT /entrypoint.sh
