typealias SymbolNamesFile = [String]

struct SymbolNamesFileParser {
    static func parse(symbolNameFileContents: String?) -> SymbolNamesFile {
        return (symbolNameFileContents ?? "").components(separatedBy: "\n").filter { !$0.isEmpty && !$0.hasPrefix("//") }
    }
}
