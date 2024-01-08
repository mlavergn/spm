import Foundation
import PackagePlugin

// Error helper
enum DemoCommandPluginError: Error {
    case error(String)
}

// SPM implementation
@main
struct DemoCommandPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        // Throw if missing disable sandbox argument
        guard arguments.contains("--disable-sandbox") else {
            throw DemoCommandPluginError.error("If the command writes to paths outside of the package .build it requires disabling of the SPM sandbox. eg. swift package demo foo --disable-sandbox")
        }

        // Throw if missing expected arguments
        guard !arguments.isEmpty else {
            throw DemoCommandPluginError.error("Commands can require additional parameters. eg. swift package demo foo")
        }

        // Dump the invocation context and any passed arguments to stdout
        debugPrint(context)
        debugPrint(arguments)

        let xcodebuild = try context.tool(named: "xcodebuild")

        var argExtractor = ArgumentExtractor(arguments)
        let targetNames = argExtractor.extractOption(named: "target")
        let targets = targetNames.isEmpty
            ? context.package.targets
            : try context.package.targets(named: targetNames)

        guard let module = targets.first?.sourceModule else {
            throw DemoCommandPluginError.error("No source module found, aborting")
        }

        let scheme = module.name
        let platform = arguments.first ?? "iphoneOS"
        let config = "Debug"

        let sometoolExec = URL(fileURLWithPath: xcodebuild.path.string)
            let sometoolArgs = [
                "-scheme", "\(scheme)-Package",
                "-sdk", "\(platform.lowercased())",
                "-destination", "platform=Any \(platform)",
                "-configuration", "\(config)"
            ]
            debugPrint("Invocation arguments: \(sometoolArgs.joined())")
            let process = try Process.run(sometoolExec, arguments: sometoolArgs)
            process.waitUntilExit()

            // Check whether the subprocess invocation was successful.
            if process.terminationReason == .exit && process.terminationStatus == 0 {
                print("Processed source code in \(module.directory).")
            } else {
                let problem = "\(process.terminationReason):\(process.terminationStatus)"
                Diagnostics.error("Process invocation failed \(problem)")
            }        
    }}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

// Xcode extension
extension DemoCommandPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        debugPrint(context)
    }
}
#endif