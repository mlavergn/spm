# SPM

Swift Package Manager Template with Plugins

At the time of writing, examples of SPM plugins are either too minimalist or too abtract. This template is intended to give a reusable template for creating command and/or build plugins to use with SPM.

This is  useful when attempting to use SPM to deliver modules for use with non-macOS targets for which xcodebuild must be involved via the plugin mechanism.

## Makefile

The included makefile contains useful call samples, but in brief, there are 2 commands of interest:

1) Trigger the `demo` command plugin:
```
swift package demo iphoneos --disable-sandbox
```

2) Trigger the build plugin:
```
swift build
```

## Contents

This template includes 2 plugin templates:

- DemoCommandPlugin
  - Adds a command to `swift package` that runs an external procress. (eg. xcodebuild)
- DemoBuildToolPlugin.
  - Preprocesses the source directory with sed to lowercase the string "OK".
