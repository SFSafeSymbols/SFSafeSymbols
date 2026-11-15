import Foundation
import SFSymbols

/// The SF Symbols data of the macOS the generator runs on.
///
/// Symbol names, availability, renames and use restrictions are files of the system's CoreGlyphs bundle.
/// Preview glyphs and layerset availability come from the private SFSymbols framework, which reads the system's
/// (obfuscated) symbol metadata store.
enum SystemSymbols {
    private static let coreGlyphsResources = URL(
        fileURLWithPath: "/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources"
    )

    nonisolated(unsafe) private static let store = SymbolMetadataStore.system

    /// A file of the system's CoreGlyphs bundle, e. g. `name_availability.plist`.
    static func read(file name: String, withExtension ext: String) throws -> Data {
        try Data(contentsOf: coreGlyphsResources.appending(path: "\(name).\(ext)"), options: .mappedIfSafe)
    }

    /// The symbol's character in the SF fonts, or `nil` if it has none (e. g. symbols composed of a badge).
    static func preview(of name: String) -> String? {
        store.symbolMetadata(forSystemName: name)?.privateScalar.map { String($0) }
    }

    /// Whether the symbol has no metadata of its own, because it's composed of another symbol and a badge or slash
    /// (e. g. `alarm.badge.exclamationmark`). Such symbols have no character in the SF fonts.
    static func isCompositeOnly(_ name: String) -> Bool {
        store.symbolMetadata(forSystemName: name) == nil
    }

    /// The SF Symbols version (e. g. `"3.0"`) in which each layerset other than monochrome became available.
    ///
    /// Only for current names: for old names (aliases), the store returns the renamed symbol's metadata.
    static func layersetVersions(of name: String) -> [String: String] {
        guard let metadata = store.symbolMetadata(forSystemName: name), metadata.name == name else { return [:] }
        let features: [(layerset: String, feature: SymbolFeature)] = [
            ("hierarchical", .hierarchical),
            ("multicolor", .multicolor),
        ]
        var versions: [String: String] = [:]
        for (layerset, feature) in features {
            versions[layerset] = metadata.availability(for: feature)?.earliestSupportedRelease(for: .sfSymbols)?.description
        }
        return versions
    }
}
