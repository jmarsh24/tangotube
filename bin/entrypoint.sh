#!/bin/bash

set -e

rm -f /my-app/tmp/pids/server.pid
exec "$@"
