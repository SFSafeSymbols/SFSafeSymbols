import Foundation

struct FileReader {
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
}
