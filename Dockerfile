# This is intended to only be used by Render.
# Do not use this for local development.
# You have been warned.
FROM ruby:3.1.2

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Install yt-dlp
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp

# Install nodejs
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN sh -c "echo deb https://deb.nodesource.com/node_14.x buster main > /etc/apt/sources.list.d/nodesource.list"

# Adds nodejs and upgrade yarn
RUN apt-get update && apt-get install -y --no-install-recommends \
  nodejs \
  yarn \
  && rm -rf /var/lib/apt/lists/*

ENV APP_PATH /opt/app
RUN mkdir -p $APP_PATH

WORKDIR $APP_PATH
COPY . .
RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN yarn install
RUN bundle install
RUN RAILS_SERVE_STATIC_FILES=true \
  RAILS_MASTER_KEY=054ef579f31d3f4ce3d0b2ed3a2f1098eb8780a18c0628f50f39dbf5a2f68becae7997dc37d336ae1cfb661b77c1d8ea6f9bb7e9d5d5f37de51bd7b405403aae \
  bundle exec rails assets:precompile

