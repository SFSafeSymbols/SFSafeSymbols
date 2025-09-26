import Foundation

typealias SymbolNamesFile = [String]

struct SymbolNamesFileParser {
    static func parse(symbolNameFileContents: Data) -> SymbolNamesFile {
        let str = String(data: symbolNameFileContents, encoding: .utf8)!
        return str.components(separatedBy: "\n").filter { !$0.isEmpty && !$0.hasPrefix("//") }
    }
}
