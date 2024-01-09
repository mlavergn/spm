###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

clean:
	swift package clean

distclean: clean
	swift package purge-cache
	rm -r .build

build:
	swift build

test:
	swift test
