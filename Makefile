SHELL=/bin/bash
TEMP := $(shell mktemp)

all:
	@vim -c "redir! > $(TEMP) | echo findfile('autoload/vunit.vim', escape(&rtp, ' ')) | quit"
	@if [ -n "$$(cat $(TEMP))" ] ; then \
			vunit=$$(dirname $$(dirname $$(cat $(TEMP)))) ; \
			if [ -e $$vunit/bin/vunit ] ; then \
				mkdir -p build/test ; \
				$$vunit/bin/vunit -d build/test -r $$PWD -p plugin/archive.vim -t test/**/*.vim ; \
			else \
				echo "Unable to locate vunit script" ; \
			fi ; \
		else \
			echo "Unable to locate vunit in vim's runtimepath" ; \
		fi
	@rm $(TEMP)

dist:
	@rm archive.zip 2> /dev/null || true
	@zip archive.zip `git ls-files autoload doc plugin`

clean:
	@rm autoload/archive/*.class 2> /dev/null || true
	@rm -R build 2> /dev/null || true
