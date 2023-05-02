#!/bin/bash

# Log into the registry
export MRSK_REGISTRY_USERNAME="jmarsh24"
export MRSK_REGISTRY_TOKEN="ZG9wX3YxXzBmMjUwNDVkZjdhNmJmZDc1MzY0OTNhNzFlYjdlMzBjMTg4NWRmNGM2YmY5NTg5NmZiYTE5MWFkZWQyMjM4Yjc6ZG9wX3YxXzBmMjUwNDVkZjdhNmJmZDc1MzY0OTNhNzFlYjdlMzBjMTg4NWRmNGM2YmY5NTg5NmZiYTE5MWFkZWQyMjM4Yjc="

echo $MRSK_REGISTRY_TOKEN | docker login -u $MRSK_REGISTRY_USERNAME --password-stdin registry.digitalocean.com

# Build the Docker image
docker build -t registry.digitalocean.com/jmarsh24/tangotube .

# Push the Docker image
docker push registry.digitalocean.com/jmarsh24/tangotube

# Add the rest of your deployment logic
# ...
