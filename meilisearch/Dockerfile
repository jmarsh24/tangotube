RUN echo "deb [trusted=yes] https://apt.fury.io/meilisearch/ /" > /etc/apt/sources.list.d/fury.list

RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y meilisearch-http

RUN meilisearch
