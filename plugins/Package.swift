// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Demo",
    platforms: [
        .iOS("17.0"), 
        .macOS("14.0"), 
        .tvOS("17.0"),
        .visionOS("1.0"),
        .watchOS("10.0")
    ],
    targets: [
        .plugin(
            name: "DemoCommandPlugin",
            capability: .command(
                intent: .custom(
                    verb: "demo",
                    description: "Demonstration command plugin."
                )
            ),
            // permissions: [
            //     .writeToPackageDirectory(reason: "Required if the plugin modifies source files")
            // ],
            path: "Plugins/DemoCommandPlugin"
        ),
        .plugin(
            name: "DemoBuildToolPlugin",
            capability: .buildTool(),
            path: "Plugins/DemoBuildToolPlugin"
        ),
        .target(
            name: "Demo",
            path: "Sources"
        )
    ]
)