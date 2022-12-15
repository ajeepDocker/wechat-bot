FROM debian:bullseye

# Instal the 'apt-utils' package to solve the error 'debconf: delaying package configuration, since apt-utils is not installed'
# https://peteris.rocks/blog/quiet-and-unattended-installation-with-apt-get/
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    autoconf \
    automake \
    bash \
    build-essential \
    ca-certificates \
    chromium \
    coreutils \
    curl \
    ffmpeg \
    figlet \
    git \
    gnupg2 \
    jq \
    libgconf-2-4 \
    libtool \
    libxtst6 \
    moreutils \
    python-dev \
    shellcheck \
    sudo \
    tzdata \
    vim \
    wget \
    unzip \
  && apt-get purge --auto-remove \
  && wget -q https://registry.npmmirror.com/-/binary/chromium-browser-snapshots/Linux_x64/970486/chrome-linux.zip -O /tmp/chrome.zip \
  && unzip /tmp/chrome.zip -d /opt/ \
  && rm -rf /tmp/* /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && apt-get purge --auto-remove \
    && rm -rf /tmp/* /var/lib/apt/lists/*


RUN mkdir -p /app
WORKDIR /app

COPY package.json ./
COPY .env ./
RUN npm i

COPY *.js ./
COPY src/ ./src/
COPY ChromeLauncher.js ./node_modules/puppeteer-core/lib/cjs/puppeteer/node/
CMD ["npm", "run", "dev"]
