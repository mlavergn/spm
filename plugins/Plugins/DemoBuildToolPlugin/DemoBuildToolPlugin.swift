import Foundation
import PackagePlugin

// Error helper
enum DemoBuildToolPluginError: Error {
    case error(String)
}

// SPM implementation
@main
struct DemoBuildToolPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // using `sed` as an example, but any executable that modified files should work
        let tool = try context.tool(named: "sed")

        guard let target = target as? SwiftSourceModuleTarget else {
            throw DemoBuildToolPluginError.error("Not a source module target.")
        }

        let commands: [Command] = target
            .sourceFiles.map { $0.path }
            .compactMap {
                let filename = $0.lastComponent
                let outputName = $0.stem + "Post" + ".swift"
                let outputPath = context.pluginWorkDirectory.appending(outputName)

                return .buildCommand(displayName: "Processing \(filename)",
                                     executable: tool.path,
                                     arguments: ["-i", "", "s/OK/ok/", $0, outputPath],
                                     inputFiles: [$0],
                                     outputFiles: [outputPath])
            }

        return commands
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

// Xcode extension
extension DemoBuildToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command]
        debugPrint(context)
        return []
    }
}
#endif