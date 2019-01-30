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

# Update jekyll/ruby modules and start server
bundle update
bundle exec jekyll serve &

sleep 2

URL="http://localhost:4000"
open ${URL} \
  || start ${URL} \
  || echo "open browser and point at '$URL'"

# start a trivial subjob that is long lived
#sleep 99999 &

# Wait until the user 'terminates' the meeeting
echo "Press Ctrl-C to terminate..."
wait
