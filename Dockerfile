# The official Elasticsearch Docker image
FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.1@sha256:1000eae211ce9e3fcd1850928eea4ee45a0a5173154df954f7b4c7a093b849f8

# Copy our config file over
COPY --chown=1000:0 config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Allow Elasticsearch to create `elasticsearch.keystore`
# to circumvent https://github.com/elastic/ansible-elasticsearch/issues/430
RUN chmod g+ws /usr/share/elasticsearch/config

RUN cd $1
RUN mkdir -p "vendor"
RUN cd "vendor"
RUN mkdir -p ./yt-dlp/bin/
RUN cd ./yt-dlp/bin/
RUN wget $(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest \
  | grep -e "browser_download_url.*yt-dlp" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | grep -e "yt-dlp$")
RUN chmod a+rx yt-dlp
RUN echo "Adding to PATH" | indent
RUN PROFILE="$1/.profile.d/yt-dlp.sh"
RUN mkdir -p "$1/.profile.d/"
RUN touch $PROFILE
RUN echo 'export PATH="$PATH:$HOME/vendor/yt-dlp/bin"' >> $PROFILE

USER 1000:0
