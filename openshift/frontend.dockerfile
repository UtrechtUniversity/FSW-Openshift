FROM node:20-alpine
# set workdir
RUN mkdir /var/www && chown node:node /var/www
WORKDIR /var/www

RUN apk add --no-cache git

#Naar het voorbeeld van:
#https://github.com/UtrechtUniversity/containerplatform-docs Apache rootless openshift
RUN chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

EXPOSE 7050