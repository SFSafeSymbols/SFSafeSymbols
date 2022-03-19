import Foundation

struct SymbolRestrictionsParser {
    static func parse(from data: Data?) -> [String: String]? {
        guard let data = data else { return nil }
        return try? PropertyListDecoder().decode([String: String].self, from: data)
    }
}
