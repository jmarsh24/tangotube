#!/usr/bin/env bash
# exit on error
set -o errexit
# Check build cache
if [[ ! -d $XDG_CACHE_HOME/yt-dlp ]]; then
echo "...Downloading yt-dlp"
cd $XDG_CACHE_HOME
  mkdir -p ./yt-dlp
cd ./yt-dlp
  wget $(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest | jq -r '.assets[2] | .browser_download_url')
  chmod a+rx yt-dlp
cd $HOME/project/src # Make sure we return to where we were
else
echo "...Using yt-dlp from build cache"
fi
mkdir -p $HOME/project/src/yt-dlp
cp $XDG_CACHE_HOME/yt-dlp/yt-dlp $HOME/project/src/yt-dlp/

# add it to the PATH as part of the start command/script:

export PATH="$PATH:$HOME/project/src/yt-dlp"

echo $PATH

# Add the rest of your build commands
# bundle install, etc.

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

