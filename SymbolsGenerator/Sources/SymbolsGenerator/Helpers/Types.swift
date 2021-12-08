import Foundation

/// The base symbol when scanned from the manifest
struct ScannedSymbol {
    var name: String
    var availability: Availability
}

/// The symbol data type containing all versions for one specific symbol
struct Symbol {
    var name: String
    var restriction: String?
    var preview: String?
    var availability: Availability
    var availableLocalizations: [Availability: Set<Localization>]
    var availableLayersets: [Availability: Set<String>]
    var type: SymbolType
    var propertyName: String { name.toPropertyName }
}

enum SymbolType {
  case normal
  case replacement(for: ScannedSymbol)
  case replaced(by: ScannedSymbol)
}

struct Availability: Comparable, Equatable, Hashable {
    var iOS: String
    var tvOS: String
    var watchOS: String
    var macOS: String
    var year: String // E. g. "2020" or "2020.1"
    var isBase: Bool { version == "1.0" }
    var version: String {
        let ver = Decimal(string: "1.0")! + (Decimal(string: year)! - Decimal(string: "2019")!)
        return String(format: "%.1f", NSDecimalNumber(decimal: ver).doubleValue)
    }

    var availableExpression: String {
        "available(iOS \(iOS), macOS \(macOS), tvOS \(tvOS), watchOS \(watchOS), *)"
    }

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

/// A single layerset availability specification when scanned from the layerset plist
struct LayersetAvailability {
    var name: String
    var availability: Availability
}

struct Localization: Equatable, Hashable {
    let suffix: String
    let longName: String

    /// The name for a variable exposing this localization, e.g. "zhTraditional".
    var variableName: String {
        decapFirst(noDots(suffix.capitalized))
    }

    var baseProtocolName: String {
        decapFirst(noDots(suffix.capitalized))
    }

    /// The name for the protocol exposing this localization given a specific (or base) availability.
    /// E.g. "ar" or "ar_v20".
    func protocolName(for availability: Availability) -> String {
        let availabilitySuffix = availability.isBase ? "" : "_v" + noDots(availability.version)
        return baseProtocolName + availabilitySuffix
    }
}

private let noDots: (String) -> String = { $0.replacingOccurrences(of: ".", with: "") }
private let decapFirst: (String) -> String = { String($0.prefix(1)).lowercased() + String($0.dropFirst()) }
