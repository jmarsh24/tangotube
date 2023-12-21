# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-slim as base

WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development" \
  RUBY_YJIT_ENABLE="1"

FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential curl git libvips libpq-dev pkg-config nodejs && \
  rm -rf /var/lib/apt/lists/*

# Install JavaScript dependencies
ARG NODE_VERSION=18.17.1
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  npm install -g yarn@$YARN_VERSION && \
  rm -rf /tmp/node-build-master


COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

# Copy over package.json and yarn.lock and install npm packages
COPY package.json yarn.lock ./
RUN yarn install

COPY . .

RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

# Install packages and tools
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libvips ffmpeg postgresql-client python3-pip python3-venv

RUN python3 -m venv /opt/venv 

RUN /opt/venv/bin/pip install yt-dlp

ENV PATH="/opt/venv/bin:$PATH"

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
  chown -R rails:rails db log storage tmp

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
