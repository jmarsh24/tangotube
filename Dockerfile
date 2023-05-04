# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.1
FROM ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# imagemagick AND vips, usually only one is needed.
ENV RUNTIME_DEPS="curl gnupg2 libvips libvips-dev tzdata imagemagick librsvg2-dev libmagickwand-dev postgresql-client ffmpeg" \
  BUILD_DEPS="build-essential libpq-dev git less pkg-config python-is-python3 node-gyp vim rsync python3-pip"

# Common dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends $RUNTIME_DEPS $BUILD_DEPS && \
  pip3 install yt-dlp

# Install JavaScript dependencies
ARG NODE_VERSION=14.21.3
ARG YARN_VERSION="^1.22.19"
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  npm install -g yarn@$YARN_VERSION && \
  rm -rf /tmp/node-build-master

# COPY Aptfile /tmp/Aptfile
# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#   --mount=type=cache,target=/var/lib/apt,sharing=locked \
#   --mount=type=tmpfs,target=/var/log \
#   apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
#   DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
#     $(grep -Ev '^\s*#' /tmp/Aptfile | xargs)

# Set production environment
ENV RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_JOBS="4" \
  BUNDLE_NO_CACHE="true" \
  BUNDLE_WITHOUT="development,test" \
  GEM_HOME="/usr/local/bundle"

# Install application gems
COPY Gemfile Gemfile.lock ./

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Final stage for app image
FROM base as app

# Install packages needed for deployment
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y $RUNTIME_DEPS cron

# Install Google Chrome for some scraping stuff.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y google-chrome-stable

# Copy built artifacts: gems, application
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --home /rails --shell /bin/bash && \
  chown -R rails:rails db log tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
