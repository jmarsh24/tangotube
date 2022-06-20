# The official Elasticsearch Docker image
FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.1@sha256:1000eae211ce9e3fcd1850928eea4ee45a0a5173154df954f7b4c7a093b849f8
curl -L https://github.com/yt-dlp/yt-dlp/releases/lastest/download/yt-dlp -o /usr/local/bin/yt-dlp

# Copy our config file over
COPY --chown=1000:0 config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Allow Elasticsearch to create `elasticsearch.keystore`
# to circumvent https://github.com/elastic/ansible-elasticsearch/issues/430
RUN chmod g+ws /usr/share/elasticsearch/config
RUN chmod a+rx /usr/local/bin/yt-dlp

USER 1000:0
