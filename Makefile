
# Ensure that required components are pre-installed.
# https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
REQUIRED = bundle
CHECK := $(foreach exec,$(REQUIRED),$(if $(shell $(exec) --version),'',$(error "required '$(exec)' not found in PATH")))

.PHONY: default list

defaut: serve
# default:
# 	@echo 'Makefile does nothing by default; avaliable targets:'
# 	@make list | sed 's/^/  /'
# 	@exit 1

# Show list of available targets
# https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
list:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' -e '^$(.DEFAULT_GOAL)$$'

# -----------------
# Real Targets Here
# -----------------

# bundler:
# 	gem install bundler
# 	bundler update --bundler

install: vendor
vendor:
	bundle install --path vendor/bundle

update upgrade: vendor
	bundle update

s serve: update
	./bin/serve.sh

clean:
	git clean -X -d -f
