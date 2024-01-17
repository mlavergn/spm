// swift-tools-version: 5.9
// Minimum Swift version required

import PackageDescription

var linkerSettings: [LinkerSetting] = [
    .linkedFramework("Foundation", nil),
]

let package = Package(
    name: "Demo",
    platforms: [.iOS("17.0"), .macOS("14.0"), .watchOS("10.0")],
    products: [
        .library(name: "DemoFmwk", targets: ["DemoFmwk"]),
        .executable(name: "Demo", targets: ["Demo"])
    ],
    targets: [
        .target(
            name: "DemoFmwk",
            dependencies: [],
            path: "Sources/Fmwk",
            exclude: ["Info.plist"],
            resources: [ .copy("Info.plist") ],
            linkerSettings: linkerSettings
        ),
        .executableTarget(
            name: "Demo",
            dependencies: [],
            path: "Sources/App",
            exclude: ["Info.plist"],
            resources: [ .copy("Info.plist") ]
        ),
        .testTarget(
            name: "DemoTests",
            dependencies: ["Demo"],
            path: "Tests"
        )
    ]
)
