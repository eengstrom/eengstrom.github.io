#!/bin/bash

PROGNAME=$(basename "$0")
warn()  { echo "$PROGNAME: ${@}" 1>&2; }
die()   { warn "${@}"; exit 1; }
# usage() { echo "usage: $PROGNAME <MEETING-TYPE>" 1>&2; }

set -e  # exit on error
#set -x  # print each line as executed

# setup exit trap to kill all subjobs
trap 'kill $(jobs -p) 2>/dev/null' EXIT
trap 'exit' SIGHUP SIGINT SIGQUIT SIGTERM

# Handle updating bundler itself
bundle --version >/dev/null ||
 ( gem install bundler && bundler update --bundler )
# Update jekyll/ruby modules and start server
bundle update
bundle exec jekyll serve &

while ! (nc -z 127.0.0.1 4000 >/dev/null 2>&1); do
  echo waiting for server to startup...
  sleep 1
done

URL="http://localhost:4000"
sleep 1
open ${URL} \
  || start ${URL} \
  || echo "open browser and point at '$URL'"

# start a trivial subjob that is long lived
#sleep 99999 &

# Wait until the user 'terminates' the meeeting
echo "Press Ctrl-C to terminate..."
wait
