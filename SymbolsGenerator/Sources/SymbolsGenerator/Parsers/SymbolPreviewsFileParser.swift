typealias SymbolPreviewsFile = [String]

struct SymbolPreviewsFileParser {
    static func parse(symbolFileContents: String?) -> SymbolPreviewsFile {
        return ((symbolFileContents ?? "").components(separatedBy: "\n").last { !$0.isEmpty } ?? "").map { String($0) }.filter { !$0.isEmpty }
    }
}
