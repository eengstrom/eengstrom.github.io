#!/bin/bash

set -e
set -x

bundle update
bundle exec jekyll serve
