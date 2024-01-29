// swift-tools-version: 5.7
// Minimum Swift version required

// Note:
// swift-tools-version and platforms.macOS are version adjusted to
// work with GitHub actions as of 01/2024.

import PackageDescription

let package = Package(
    name: "Demo",
    platforms: [.iOS("17.0"), .macOS("13.1"), .watchOS("10.0")],
    products: [
        .library(name: "DemoFramework", targets: ["DemoFramework"]),
        .executable(name: "DemoApp", targets: ["DemoApp"])
    ],
    targets: [
        .target(
            name: "DemoFramework",
            dependencies: [],
            path: "Sources/Fmwk",
            exclude: ["Info.plist"],
            resources: [ .copy("Info.plist") ],
            linkerSettings: [
                .linkedFramework("Foundation")
            ]
        ),
        .executableTarget(
            name: "DemoApp",
            dependencies: ["DemoFramework"],
            path: "Sources/App",
            exclude: ["Info.plist"],
            resources: [ .copy("Info.plist") ]
        ),
        .testTarget(
            name: "DemoTests",
            dependencies: ["DemoFramework"],
            path: "Tests",
            linkerSettings: [
                .linkedFramework("Foundation")
            ]
        )
    ]
)
