FROM docker.io/httpd:2.4.59
# set workdir
#WORKDIR /var/www

# upgrades!
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -qq install -y git

RUN sed -i 's/^Listen 80/Listen 7050/' /usr/local/apache2/conf/httpd.conf

#Naar het voorbeeld van:
#https://github.com/UtrechtUniversity/containerplatform-docs Apache rootless openshift
#RUN chgrp -R 0 /var/www && \
#    chmod -R g=u /var/www
#COPY ../public /var/www/html

RUN chgrp -R 0 /usr/local/apache2 && \
    chmod -R g=u /usr/local/apache2

COPY ../public /usr/local/apache2/htdocs/

EXPOSE 7050