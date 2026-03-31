import ArgumentParser
import Foundation
import Version

enum CLIMode: String, EnumerableFlag {
    case dev, fork, release
}

enum GenerationMode {
    case dev
    case fork(username: String, branch: String)
    case release(tag: Version)
}

@main
struct SymbolsGeneratorCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Generate Swift source files for SFSafeSymbols from SF Symbols metadata."
    )

    @Argument(
        help: "The output directory for generated symbol files.",
        transform: URL.init(fileURLWithPath:)
    )
    private var outputDir: URL

    @Flag(help: "The generation mode")
    private var mode: CLIMode = .dev

    @Option(help: "GitHub username (required for fork mode)")
    private var username: String?

    @Option(help: "Branch name (required for fork mode)")
    private var branch: String?

    @Option(help: "Tag name (required for release mode)", transform: Version.init)
    private var tag: Version?

    mutating func validate() throws {
        guard (try? outputDir.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true else {
            throw ValidationError("❌ Output path must be a directory.")
        }

        switch mode {
            case .dev:
                break
            case .release:
                guard let _ = tag else {
                    throw ValidationError("❌ Missing or invalid version tag. Usage: make release <tag>")
                }
            case .fork:
                guard username != nil, branch != nil else {
                    throw ValidationError("❌ Missing username or branch. Usage: make fork <user> <branch>")
                }
        }
    }

    func run() async throws {
        let start = Date()
        var generationMode: GenerationMode {
            switch mode {
                case .dev: .dev
                case .fork: .fork(username: username!, branch: branch!)
                case .release: .release(tag: tag!)
            }
        }
        let generator = GeneratorCore(outputDir: outputDir, mode: generationMode)
        try await generator.run()
        let duration = Date().timeIntervalSince(start)
        print("✅ Generation completed in \(String(format: "%.2f", duration)) seconds.")
    }
}
