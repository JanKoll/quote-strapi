FROM node:18.15-alpine3.17
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
WORKDIR /opt
COPY ./app/package.json ./app/package-lock.json ./
COPY ./app/providers ./providers
COPY ./app/patches ./patches
RUN chown 1000:1000 /opt -R
USER node
ENV PATH /opt/node_modules/.bin:$PATH
RUN npm install
WORKDIR /opt/app
COPY ./app/ .
RUN npm run build
WORKDIR /opt/app
USER root
RUN chown 1000:1000 /opt/app -R
EXPOSE 1337
CMD ["npm", "run", "start"]
