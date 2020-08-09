import Foundation

typealias SymbolManifest = [ScannedSymbol]

struct SymbolManifestParser {
    private struct Plist: Decodable {
        enum CodingKeys: String, CodingKey {
            case symbols
            case yearToReleaseMapping = "year_to_release"
        }

        var symbols: [String: String]
        var yearToReleaseMapping: [Int: [String: String]]
    }

    static func parse(availabilityFileData: Data?) -> SymbolManifest? {
        guard
            let data = availabilityFileData,
            let plist = try? PropertyListDecoder().decode(Plist.self, from: data)
        else {
            return nil
        }

        var availabilityFile: SymbolManifest = []
        let availabilities = plist.yearToReleaseMapping.compactMap { key, value in
            Availability(iOS: value["iOS"]!, tvOS: value["tvOS"]!, watchOS: value["watchOS"]!, macOS: value["macOS"]!, year: key)
        }

        for (key, value) in plist.symbols {
            guard let availability = (availabilities.first { $0.year == Int(value) }) else {
                // Cancel on single failure
                return nil
            }
            availabilityFile.append(ScannedSymbol(name: key, availability: availability))
        }

        return availabilityFile
    }
}
