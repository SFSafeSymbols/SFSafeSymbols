import Foundation
import OrderedCollections

typealias StringDictionary = OrderedDictionary<String, String>

extension Data {
    func parse<T>(using parser: (Data) throws -> T) rethrows -> T {
        return try parser(self)
    }
}

struct StringDictionaryFileParser {
    static func parse(from data: Data) throws -> StringDictionary {
        if (data.isEmpty) { return [:] }
        let unorderedDict = try PropertyListDecoder().decode([String: String].self, from: data)
        return .init(uncheckedUniqueKeysWithValues: unorderedDict.sorted(using: KeyPathComparator(\.key)))
    }
}
