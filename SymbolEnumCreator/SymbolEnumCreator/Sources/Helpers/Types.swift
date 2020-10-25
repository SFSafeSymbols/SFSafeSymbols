import Foundation

/// The base symbol when scanned from the manifest
struct ScannedSymbol {
    var name: String
    var availability: Availability
}

/// The symbol data type containing all versions for one specific symbol
struct Symbol {
    var name: String
    var canOnlyReferTo: String?
    var preview: String?
    var nameVersions: [Availability: String]
    var availableLocalizations: [Availability: Set<String>]
}

/// The type representing a symbol enum case
struct SymbolEnumCase {
    var caseName: String
    var nameVersions: [Availability: String]
    var canOnlyReferTo: String?
    var preview: String?
    var availableLocalizations: [Availability: Set<String>]
    var availability: Availability
    var deprecation: (availability: Availability, renamedTo: String)?
}

/// The type representing the string for an enum case for a given availability
struct SymbolEnumRawValue {
    var availability: Availability
    var caseName: String
    var name: String
}

struct Availability: Comparable, Equatable, Hashable {
    var iOS: String
    var tvOS: String
    var watchOS: String
    var macOS: String
    var year: Int

    static func < (lhs: Availability, rhs: Availability) -> Bool {
        return lhs.year > rhs.year
    }

    static func > (lhs: Availability, rhs: Availability) -> Bool {
        return lhs.year < rhs.year
    }

    static func == (lhs: Availability, rhs: Availability) -> Bool {
        return lhs.year == rhs.year
    }
}
