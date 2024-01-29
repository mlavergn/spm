###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

SDK ?= macosx
SDK_PATH := $(shell xcrun --sdk ${SDK} --show-sdk-path)

ifeq ($(SDK),iphoneos)
SDK_TRIPLE := arm64e-apple-ios
else ifeq ($(SDK),appletvos)
SDK_TRIPLE := arm64-apple-tvos
else ifeq ($(SDK),watchos)
SDK_TRIPLE := arm64_32-apple-watchos
else ifeq ($(SDK),xros)
SDK_TRIPLE := arm64e-apple-xros
else
SDK_TRIPLE := arm64-apple-macosx
endif

env:
	@echo ${SDK}
	@echo ${SDK_PATH}
	@echo ${SDK_TRIPLE}

open:
	open Package.swift

st:
	open -a SourceTree .

clean:
	swift package clean
	swift package purge-cache
	swift package reset
	rm -rf .build

distclean: clean
	swift package purge-cache
	rm -r .build

build:
	swift build -v --sdk ${SDK_PATH} --triple ${SDK_TRIPLE}

test:
	swift test
