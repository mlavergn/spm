// swift-tools-version: 5.9
// Minimum Swift version required

import PackageDescription

let package = Package(
    name: "Demo",
    platforms: [.iOS("17.0"), .macOS("14.0"), .watchOS("10.0")],
    products: [
        .library(name: "DemoFramework", type: .dynamic, targets: ["DemoFramework"]),
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
                .linkedFramework("Foundation", nil),
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
            path: "Tests"
        )
    ]
)
