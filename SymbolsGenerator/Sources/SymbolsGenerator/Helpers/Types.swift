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
    var availability: Availability
    var availableLocalizations: [Availability: Set<String>]
    var deprecation: ScannedSymbol?
    var propertyName: String { name.toPropertyName }
}


struct Availability: Comparable, Equatable, Hashable {
    var iOS: String
    var tvOS: String
    var watchOS: String
    var macOS: String
    var year: String // E. g. "2020" or "2020.1"
    var isBase: Bool { year == "2019" }

    static func < (lhs: Availability, rhs: Availability) -> Bool {
        // The `orderedDescending` is intentional, because the availability is smaller when the year is higher
        return lhs.year.compare(rhs.year, options: .numeric) == .orderedDescending
    }

    static func > (lhs: Availability, rhs: Availability) -> Bool {
        return lhs.year.compare(rhs.year, options: .numeric) == .orderedAscending
    }

    static func == (lhs: Availability, rhs: Availability) -> Bool {
        return lhs.year == rhs.year
    }
}
