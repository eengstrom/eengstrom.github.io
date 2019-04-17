#!/bin/bash

PROGNAME=$(basename "$0")
DIRNAME=$(dirname "$0")
POSTDIR=$(realpath $(dirname "${DIRNAME}")/_posts)
warn()  { echo "$PROGNAME: ${@}" 1>&2; }
die()   { warn "${@}"; exit 1; }
# usage() { echo "usage: $PROGNAME <MEETING-TYPE>" 1>&2; }

set -e  # exit on error
#set -x  # print each line as executed

title="$@"
post=$(echo $title | perl -ple 's/\s+/-/g' | tr A-Z a-z)
file="${POSTDIR}/$(date +%Y-%m-%d)-${post}.md"
date=$(date '+%Y-%m-%d %T %z')

echo $file
echo $date

cat - >$file <<EOP
---
layout: post
title:  ${title}
description:  ${title}
date:   ${date}
tags:   ${title}
excerpt_separator: <!--more-->
---
EOP

edit $file
