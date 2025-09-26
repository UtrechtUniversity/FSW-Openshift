FROM php:8.2-apache
# set workdir
WORKDIR /var/www

COPY ../public /var/www/html

RUN apt-get -qq install -y git

#Naar het voorbeeld van:
#https://github.com/UtrechtUniversity/containerplatform-docs Apache rootless openshift
RUN chgrp -R 0 /var/www && \
    chmod -R g=u /var/www

EXPOSE 7050