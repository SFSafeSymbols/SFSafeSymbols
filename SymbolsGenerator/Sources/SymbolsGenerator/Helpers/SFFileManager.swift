import Foundation

enum SFFileManager {
    static func write(_ contents: String, to file: URL) throws {
        try write(Data(contents.utf8), to: file)
    }
    
    static func write(_ contents: Data, to file: URL) throws {
        try FileManager.default.createDirectory(at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try contents.write(to: file, options: .atomic)
    }
}
