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

list:
	swift package plugin --list

build:
	# triggers DemoBuildToolPlugin
	swift build

command:
	# triggers DemoCommandPlugin
	swift package demo iphoneos --disable-sandbox
