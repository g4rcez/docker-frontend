FROM debian:bullseye-slim

LABEL version="0.0.0"
LABEL description="One docker frontend to rule them all"
LABEL name="docker-frontend"

RUN apt update
RUN apt install -y curl 

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libnotify-dev \
  libgconf-2-4 \
  libgbm-dev \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  xvfb \
  fonts-arphic-bkai00mp \
  fonts-arphic-bsmi00lp \
  fonts-arphic-gbsn00lp \
  fonts-arphic-gkai00mp \
  fonts-arphic-ukai \
  fonts-arphic-uming \
  ttf-wqy-zenhei \
  ttf-wqy-microhei \
  xfonts-wqy \
  # clean up
  && rm -rf /var/lib/apt/lists/*

RUN npm i -g npm@latest
RUN npm install -g yarn@latest
RUN npm install -g pnpm@latest

RUN pnpm setup

ENV TERM xterm
ENV npm_config_loglevel warn
ENV npm_config_unsafe_perm true
RUN node -p process.versions

RUN mkdir /app
WORKDIR /app

RUN pnpm install axios axios-retry date-fns react react-dom brouther react-router-dom react-router typescript cypress jest
RUN $(npm bin)/cypress install
RUN rm -rf /app/yarn.lock /app/pnpm-lock.yaml

