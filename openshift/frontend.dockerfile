FROM docker.io/httpd:2.4.59
# set workdir
#WORKDIR /var/www

RUN sed -i 's/^Listen 80/Listen 8080/' /usr/local/apache2/conf/httpd.conf
COPY ../public /var/www/html

# upgrades!
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -qq install -y git

#Naar het voorbeeld van:
#https://github.com/UtrechtUniversity/containerplatform-docs Apache rootless openshift
#RUN chgrp -R 0 /var/www && \
#    chmod -R g=u /var/www

RUN chgrp -R 0 /usr/local/apache2 && \
    chmod -R g=u /usr/local/apache2

COPY ../public /usr/local/apache2/htdocs/

EXPOSE 8080