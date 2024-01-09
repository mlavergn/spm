// swift-tools-version: 5.10
// Minimum Swift version required

import Foundation
import PackageDescription

enum Platforms: String {
    case iphoneos
    case iphonesimulator
    case macosx
    case watchos

    var sdkroot: String {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/usr/bin/xcrun"
        task.arguments = ["--sdk", "\(self.rawValue)", "--show-sdk-path"]
        task.standardOutput = pipe
        try! task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let result = String(data: data, encoding: .utf8) ?? ""
        task.waitUntilExit()
        return result
    }    
}

let SDKROOT = Platforms.iphoneos.sdkroot

var swiftSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-Xcc", "-I", "-Xcc", "../include"
    ]),
]

var cxxSettings: [CXXSetting] = [
    .headerSearchPath("/System/Library/Frameworks"),
    .unsafeFlags(["-fvisibility=hidden"]),
]

var cSettings: [CSetting] = [
    .unsafeFlags([
        "-isysroot", SDKROOT,
        "-iframework", "\(SDKROOT)/System/Library/Frameworks"
    ])
]

var linkerSettings: [LinkerSetting] = [
    .unsafeFlags(["-F", "/System/Library/Frameworks"]),
    .linkedFramework("CoreData", nil),
    .linkedFramework("Foundation", nil),
]

let package = Package(
    name: "Demo",
    platforms: [.iOS("17.0"), .macOS("14.0"), .watchOS("10.0")],
    products: [
        .library(name: "Demo", targets: ["Demo"])
    ],
    targets: [
        .target(
            name: "Demo",
            dependencies: [],
            path: "Sources",
            exclude: ["Demo.xcdatamodeld", "Info.plist"],
            resources: [ .copy("Info.plist") ],
            swiftSettings: swiftSettings,
            linkerSettings: linkerSettings
        ),
        .testTarget(
            name: "DemoTests",
            dependencies: ["Demo"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5],
    cxxLanguageStandard: CXXLanguageStandard.cxx17
)
