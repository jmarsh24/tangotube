FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  yarn \
  libffi-dev \
  libc-dev \
  file \
  imagemagick \
  git \
  tzdata \
  ffmpeg

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY docker/rails_start.sh /myapp/docker/
RUN chmod +x /myapp/docker/rails_start.sh
CMD ["docker/rails_start.sh"]
EXPOSE 3000
