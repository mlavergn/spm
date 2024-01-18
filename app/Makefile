###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

open:
	open Package.swift

clean:
	swift package clean
	swift package purge-cache
	rm -r .build

build:
	swift build

run:
	swift run

test:
	swift test

dist:
	swift build -c release --product DemoApp
	cp .build/arm64-apple-macosx/release/DemoApp .

