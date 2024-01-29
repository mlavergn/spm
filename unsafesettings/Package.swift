// swift-tools-version: 5.9
// Minimum Swift version required

import Foundation
import PackageDescription

enum Toolchain: String, CaseIterable, CustomStringConvertible {
    case appletvos
    case appletvsimulator
    case iphoneos
    case iphonesimulator
    case macosx
    case watchos
    case watchsimulator
    case xros
    case xrsimulator
    case windows
    case linux

    init(string: String) {
        let scrubbed = string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        self = Self.init(rawValue: scrubbed) ?? .macosx
    }

    var triple: String {
        switch self {
        case .appletvos, .appletvsimulator:
            "arm64-apple-tvos"
        case .iphoneos, .iphonesimulator:
            "arm64e-apple-ios"
        case .macosx:
            "arm64-apple-macosx"
        case .watchos, .watchsimulator:
            "arm64_32-apple-watchos"
        case .xros, .xrsimulator:
            "arm64e-apple-xros"
        case .windows:
            "x86_64-unknown-windows-msvc"
        case .linux:
            "x86_64-unknown-linux-gnu"
        }
    }
    
    var description: String {
        self.rawValue
    }
    
    static var current: Self = {
        if let sdkString = ProcessInfo.processInfo.environment["SDK"] {
            if let current = Self(rawValue: sdkString) {
                print(">>> Toolchain \(current.description) from environment[SDK] \(sdkString)")
                return current
            } else {
                print(">>> Toolchain default .macosx since no environment[SDK] not matched [\(sdkString)]")
                return .macosx
            }
        }
        
        guard let sdkrootString = ProcessInfo.processInfo.environment["SDKROOT"]?.lowercased() else {
            print(">>> Toolchain default .macosx since environment[SDKROOT] not found")
            return .macosx
        }
        
        let toolchain = Self.allCases.first { toolchain in
            sdkrootString.contains(toolchain.description)
        }
        
        guard let toolchain else {
            print(">>> Toolchain default .macosx since environment[SDKROOT] not matched [\(sdkrootString)]")
            return .macosx
        }
        print(">>> Toolchain \(current.description) from environment[SDKROOT] \(sdkrootString)")
        return toolchain
    }()

    var SDKROOT: String {
        let stdout = Pipe()
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["--show-sdk-path", "--sdk", "\(self.description)"]
        process.standardOutput = stdout
        
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            print(">>> Error:", error.localizedDescription)
            return ""
        }
        
        guard process.terminationStatus == 0 else {
            print(">>> Error:", "SDK path lookup exited abnormally.")
            return ""
        }
        
        let data = stdout.fileHandleForReading.readDataToEndOfFile()
        let path = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        setenv("SDKROOT", path, 1)
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
            "-Xcc", "-isysroot", "-Xcc", Toolchain.current.SDKROOT,
            "-sdk", Toolchain.current.SDKROOT,
            "-Fsystem", Toolchain.current.frameworkPath
        ]
    )
]

var cxxSettings: [CXXSetting] = [
    .unsafeFlags(["-fvisibility=hidden"])
]

var cSettings: [CSetting] = [
    .define("ONLY_ACTIVE_ARCH", to: "YES", .when(configuration: .debug)),
    .unsafeFlags(
        [
            "-isysroot", Toolchain.current.SDKROOT,
        ]
    )
]

var linkerSettings: [LinkerSetting] = [
    .linkedFramework("Foundation"),
    .linkedFramework("CoreData")
]

let package = Package(
    name: "Demo",
    platforms: [.iOS("17.0"), .macOS("13.0"), .watchOS("10.0"), .tvOS("17.0"), .visionOS("1.0")],
    products: [
        .library(name: "Demo" ,targets: ["DemoFramework"]),
        .executable(name: "demo", targets: ["DemoApp"])
    ],
    targets: [
        .target(
            name: "DemoFramework",
            dependencies: [],
            path: "Sources",
            exclude: ["Demo.xcdatamodeld", "Info.plist"],
            resources: [ .copy("Info.plist") ],
            cSettings: cSettings,
            swiftSettings: swiftSettings,
            linkerSettings: linkerSettings
        ),
        .executableTarget(
            name: "DemoApp",
            dependencies: ["DemoFramework"],
            path: "App",
            cSettings: cSettings,
            swiftSettings: swiftSettings,
            linkerSettings: linkerSettings
        ),
        .testTarget(
            name: "DemoTests",
            dependencies: ["DemoFramework"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5],
    cxxLanguageStandard: CXXLanguageStandard.cxx17
)
