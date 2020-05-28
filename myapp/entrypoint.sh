#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
# rm -f /myapp/tmp/pids/server.pid
cd /home/myapp

echo "Starting Puma server..."
# Then exec the container's main process (what's set as CMD in the Dockerfile).
web: bundle exec puma -C config/puma.rb
release: bundle exec rails db:migrate