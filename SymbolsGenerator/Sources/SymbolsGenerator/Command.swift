import ArgumentParser
import Foundation
import Version

enum CLIMode: String, EnumerableFlag {
    case dev, pr, release
}

enum GenerationMode {
    case dev
    case pr(username: String, branch: String)
    case release(tag: Version)
}

@main
struct SymbolsGeneratorCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Generate Swift source files for SFSafeSymbols from SF Symbols metadata."
    )

    static let prUsageError = """
        ❌ Invalid arguments for pr mode. The only options are:
           make pr                              (detects the username and branch from git)
           make pr <username> <branch-name>
        """

    @Argument(
        help: "The output directory for generated symbol files.",
        transform: URL.init(fileURLWithPath:)
    )
    private var outputDir: URL

    @Flag(help: "The generation mode")
    private var mode: CLIMode = .dev

    @Argument(help: "pr mode only: <username> <branch-name>, or nothing to detect both from git.")
    private var prArguments: [String] = []

    @Option(help: "Tag name (required for release mode)", transform: Version.init)
    private var tag: Version?

    mutating func validate() throws {
        guard (try? outputDir.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true else {
            throw ValidationError("❌ Output path must be a directory.")
        }

        switch mode {
            case .dev:
                guard prArguments.isEmpty else {
                    throw ValidationError("❌ Unexpected arguments: \(prArguments.joined(separator: " ")). Usage: make")
                }
            case .release:
                guard let _ = tag else {
                    throw ValidationError("❌ Missing or invalid version tag. Usage: make release <tag>")
                }
                guard prArguments.isEmpty else {
                    throw ValidationError("❌ Unexpected arguments: \(prArguments.joined(separator: " ")). Usage: make release <tag>")
                }
            case .pr:
                // Either nothing (detected from git in `run()`), or exactly a username and a branch.
                guard prArguments.count == 0 || prArguments.count == 2 else {
                    throw ValidationError(Self.prUsageError)
                }
        }
    }

    func run() async throws {
        let start = Date()
        let generationMode: GenerationMode
        switch mode {
            case .dev:
                generationMode = .dev
            case .pr:
                if prArguments.count == 2 {
                    generationMode = .pr(username: prArguments[0], branch: prArguments[1])
                } else {
                    let detected = try await detectGitBranchInfo()
                    generationMode = .pr(username: detected.username, branch: detected.branch)
                }
            case .release:
                generationMode = .release(tag: tag!)
        }
        let generator = GeneratorCore(outputDir: outputDir, mode: generationMode)
        try await generator.run()
        let duration = Date().timeIntervalSince(start)
        print("✅ Generation completed in \(String(format: "%.2f", duration)) seconds.")
    }

    private func detectGitBranchInfo() async throws -> GitBranchInfo {
        let detected: GitBranchInfo
        do {
            detected = try await GitBranchInfo.detect(in: outputDir)
        } catch {
            throw ValidationError("""
                \(error)
                   You can pass them explicitly instead: make pr <username> <branch-name>
                """)
        }
        print("""
            ℹ️ Generating for user '\(detected.username)', branch '\(detected.branch)' \
            (detected from git remote '\(detected.remote)').
               If this is wrong, run: make pr <username> <branch-name>
            """)
        return detected
    }
}
