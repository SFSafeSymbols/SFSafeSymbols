import Foundation
import OrderedCollections

typealias StringDictionary = OrderedDictionary<String, String>

struct StringDictionaryFileParser {
    static func parse(from data: Data?) -> StringDictionary? {
        guard let data = data,
                let unorderedDict = try? PropertyListDecoder().decode([String: String].self, from: data)
        else { return nil }
        return .init(uncheckedUniqueKeysWithValues: unorderedDict.sorted(on: \.key, by: <))
    }
}
