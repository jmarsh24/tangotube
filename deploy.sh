#!/bin/bash

# Log into the registry
export MRSK_REGISTRY_USERNAME="jmarsh24"
export MRSK_REGISTRY_TOKEN="ZG9wX3YxXzVhMTlkOTUzMTcxMmUxOGVlNjI0Y2NhMjJjNzRmNzBkMmY3MGQyYjRlYzA1MmUwZGU2MGVhZjBlNGE2YTExYjE6ZG9wX3YxXzVhMTlkOTUzMTcxMmUxOGVlNjI0Y2NhMjJjNzRmNzBkMmY3MGQyYjRlYzA1MmUwZGU2MGVhZjBlNGE2YTExYjE="

echo $MRSK_REGISTRY_TOKEN | docker login -u $MRSK_REGISTRY_USERNAME --password-stdin registry.digitalocean.com

# Build the Docker image
docker build -t registry.digitalocean.com/jmarsh24/tangotube .

# Push the Docker image
docker push registry.digitalocean.com/jmarsh24/tangotube

# Add the rest of your deployment logic
# ...
