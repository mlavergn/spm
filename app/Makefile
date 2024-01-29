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
	swift package reset
	rm -r .build

build:
	swift build

ios:
	swift build --sdk `xcrun --sdk iphoneos --show-sdk-path` --triple arm64e-apple-ios

run:
	swift run

test:
	swift test

dist:
	swift build -c release --product DemoApp
	cp .build/arm64-apple-macosx/release/DemoApp .

