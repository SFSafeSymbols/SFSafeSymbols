import Foundation

typealias SymbolPreviewsFile = [String]

struct SymbolPreviewsFileParser {
    static func parse(symbolFileContents: Data) -> SymbolPreviewsFile {
        let str = String(data: symbolFileContents, encoding: .utf8)!
        return (str.components(separatedBy: "\n").last { !$0.isEmpty } ?? "").map { String($0) }.filter { !$0.isEmpty }
    }
}
