## About FSW-Openshift

A first default laravel project with openshift.

local testing:
https://www.redhat.com/sysadmin/codeready-containers

`crc start -p /<path-to-the-pull-secret-file>/pull-secret.txt`

Soms wil hij niet starten, dan moet je de vm verwijderen en opnieuw starten:
`crc cleanup`


### Local development:
Add the following to your /etc/hosts file:

``` 127.0.0.1        openshift.docker.dev```

run the following command in the root of the project:

```docker compose up -d --build```
