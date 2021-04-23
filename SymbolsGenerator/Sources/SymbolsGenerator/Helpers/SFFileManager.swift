import Foundation

enum SFFileManager {
    static func read(file name: String, withExtension ext: String? = nil) -> String? {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext, subdirectory: "Resources") else {
            return nil
        }
        return try? String(contentsOf: url)
    }

    static func read(file name: String, withExtension ext: String? = nil) -> Data? {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext, subdirectory: "Resources") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }

    static func write(_ contents: String, to file: URL) {
        guard let data = contents.replacingOccurrences(of: "\t", with: "    ").data(using: .utf8) else {
            fatalError("Could not convert string to data")
        }
        do {
            try data.write(to: file, options: .atomic)
        } catch {
            fatalError("Could not write data to file: \(error)")
        }
    }
}
