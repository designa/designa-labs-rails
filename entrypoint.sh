#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ -f Gemfile ]; then
  bundle check || bundle install && bundle binstubs --all
fi

bundle exec rails s -b 0.0.0.0