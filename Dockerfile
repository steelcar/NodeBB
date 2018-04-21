ARG NODE_VERSION



FROM node:${NODE_VERSION} as node-modules
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn --production --pure-lockfile



FROM node:${NODE_VERSION}-slim as PROD

ENV NODE_ENV production
ENV TINI_VERSION v0.17.0

WORKDIR /app

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY . .
COPY --from=node-modules /app/node_modules/ /app/node_modules/

RUN chmod +x /tini

ENTRYPOINT ["/tini", "--", "./nodebb"]
CMD ["start"]

EXPOSE 4567
