FROM node:20-alpine
# set workdir
RUN mkdir /var/www && chown node:node /var/www
WORKDIR /var/www

RUN apk add --no-cache git

COPY --chown=node:node package.json package-lock.json* vite.config.js ./

#Naar het voorbeeld van:
#https://github.com/UtrechtUniversity/containerplatform-docs Apache rootless openshift
RUN chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

RUN npm install
EXPOSE 7050
CMD "npm" "run" "dev"