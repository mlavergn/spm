// swift-tools-version: 5.9
// Minimum Swift version required

import Foundation
import PackageDescription

enum SDK: String {
    case iphoneos
    case iphonesimulator
    case macosx
    case watchos

    var description: String {
        self.rawValue
    }
    
    static var _currentSDK: SDK?
    var currentSDK: SDK {
        if let currentSDK = Self._currentSDK {
            return currentSDK
        } else {
            Self._currentSDK = self
            return self
        }
    }
    
    var SDKROOT: String {
        let stdout = Pipe()
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["--show-sdk-path", "--sdk", "\(self.currentSDK.description)"]
        process.standardOutput = stdout
        
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            print(error.localizedDescription)
            return ""
        }
        
        guard process.terminationStatus == 0 else {
            return ""
        }
        
        let data = stdout.fileHandleForReading.readDataToEndOfFile()
        let path = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return path
    }
    
    var frameworkPath: String {
        let path = "\(self.SDKROOT)/System/Library/Frameworks"
        return path
    }
}

var swiftSettings: [SwiftSetting] = [
    .unsafeFlags(["-Osize"], .when(configuration: .release)),
    .unsafeFlags(["-enable-library-evolution"]),
    .unsafeFlags(
        [
            "-Xcc", "-isysroot", "-Xcc", SDK.iphoneos.SDKROOT,
            "-sdk", SDK.iphoneos.SDKROOT,
            "-Fsystem", SDK.iphoneos.frameworkPath,
        ],
        .when(platforms: [.iOS])
    ),
    .unsafeFlags(
        [
            "-Xcc", "-isysroot", "-Xcc", SDK.macosx.SDKROOT,
            "-sdk", SDK.macosx.SDKROOT,
            "-Fsystem", SDK.macosx.frameworkPath,
        ],
        .when(platforms: [.macOS])
    ),
]

var cxxSettings: [CXXSetting] = [
    .unsafeFlags(["-fvisibility=hidden"]),
]

var cSettings: [CSetting] = [
    .define("ONLY_ACTIVE_ARCH", to: "YES", .when(configuration: .debug)),
    .unsafeFlags(
        [
            "-isysroot", SDK.iphoneos.SDKROOT,
        ],
        .when(platforms: [.iOS])
    ),
    .unsafeFlags(
        [
            "-isysroot", SDK.macosx.SDKROOT,
        ],
        .when(platforms: [.macOS])
    )
]

var linkerSettings: [LinkerSetting] = [
    .linkedFramework("Foundation"),
    .linkedFramework("CoreData"),
]

let package = Package(
    name: "Demo",
    platforms: [.iOS("17.0"), .macOS("13.0"), .watchOS("10.0")],
    products: [
        .library(name: "Demo" ,targets: ["Demo"])
    ],
    targets: [
        .target(
            name: "Demo",
            dependencies: [],
            path: "Sources",
            exclude: ["Demo.xcdatamodeld", "Info.plist"],
            resources: [ .copy("Info.plist") ],
            cSettings: cSettings,
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
