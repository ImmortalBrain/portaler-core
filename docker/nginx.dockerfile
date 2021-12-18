FROM node:14-alpine as build

WORKDIR /usr/build

COPY package.json .
COPY yarn.lock .
COPY tsconfig.json .

COPY shared ./shared
COPY packages/frontend ./packages/frontend

RUN yarn install
RUN yarn build:front
RUN yarn clean


FROM jonasal/nginx-certbot:3.0.0-nginx1.21.3
COPY --from=build /usr/build/packages/frontend/build /usr/share/nginx/html