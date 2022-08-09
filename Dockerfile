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

COPY bin/entrypoint.sh /myapp/bin/
RUN chmod +x /myapp/bin/entrypoint.sh
ENTRYPOINT ["bin/entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
