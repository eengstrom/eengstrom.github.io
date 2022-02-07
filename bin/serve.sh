#!/bin/bash

PROGNAME=$(basename "$0")
DIRNAME=$(dirname "$0")
warn()  { echo "$PROGNAME: ${@}" 1>&2; }
die()   { warn "${@}"; exit 1; }
# usage() { echo "usage: $PROGNAME <MEETING-TYPE>" 1>&2; }

set -e  # exit on error
#set -x  # print each line as executed

cd $DIRNAME/..

# setup exit trap to kill all subjobs
trap 'kill $(jobs -p) 2>/dev/null' EXIT
trap 'exit' SIGHUP SIGINT SIGQUIT SIGTERM

# ensure that we have build required ruby first
test -d ./vendor || (
  #bundle install --path vendor/bundle
  make vendor
)

# Update jekyll/ruby modules
# bundle update

# Serve up the site
bundle exec jekyll serve --trace --livereload &

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

# Wait until the user 'terminates'
echo "Press Ctrl-C to terminate..."
wait
