#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
# rm -f /myapp/tmp/pids/server.pid
cd /home/app
# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle exec puma -C config/puma.rb
bundle exec rails db:migrate