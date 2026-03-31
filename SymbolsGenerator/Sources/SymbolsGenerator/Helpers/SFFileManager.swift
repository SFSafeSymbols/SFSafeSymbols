import Foundation

enum SFFileManager {
    static func read(file name: String, withExtension ext: String? = nil) throws -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: ext, subdirectory: "Resources")!
        return try Data(contentsOf: url, options: .mappedIfSafe)
    }

    static func write(_ contents: String, to file: URL) throws {
        let data = contents.replacingOccurrences(of: "\t", with: "    ").data(using: .utf8)!
        try write(data, to: file)
    }
    
    static func write(_ contents: Data, to file: URL) throws {
        try FileManager.default.createDirectory(at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try contents.write(to: file, options: .atomic)
    }
}
