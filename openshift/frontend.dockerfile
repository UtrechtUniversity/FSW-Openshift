FROM node:20-alpine
# set workdir
RUN mkdir /var/www && chown node:node /var/www
WORKDIR /var/www

RUN apk add --no-cache git

COPY --chown=node:node package.json package-lock.json* ./

RUN npm install
EXPOSE 7050
CMD "npm" "run" "build"