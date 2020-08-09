import Foundation

struct FileReader {
    static func read(file name: String) -> String? {
        if let url = URL(string: "file://\(FileManager.default.currentDirectoryPath)/\(name)") {
            if let fileContents = try? String(contentsOf: url) {
                return fileContents
            }
        }

        return nil
    }

    static func read(file name: String) -> Data? {
        if let url = URL(string: "file://\(FileManager.default.currentDirectoryPath)/\(name)") {
            if let fileData = try? Data(contentsOf: url) {
                return fileData
            }
        }

        return nil
    }
}
