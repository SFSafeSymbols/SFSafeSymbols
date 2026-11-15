import Foundation

typealias SymbolManifest = [ScannedSymbol]

struct SymbolManifestParser {
    private struct Plist: Decodable {
        enum CodingKeys: String, CodingKey {
            case symbols
            case yearToReleaseMapping = "year_to_release"
        }

        var symbols: [String: String]
        var yearToReleaseMapping: [String: [String: String]]
    }

    static func parse(availabilityFileData: Data) throws -> SymbolManifest? {
        let data = availabilityFileData
        let plist = try PropertyListDecoder().decode(Plist.self, from: data)


        var availabilityFile: SymbolManifest = []
        let availabilities = plist.yearToReleaseMapping.compactMap { key, value in
            Availability(
                iOS: value["iOS"]!,
                macOS: value["macOS"]!,
                tvOS: value["tvOS"]!,
                watchOS: value["watchOS"]!,
                visionOS: value["visionOS"]!,
                year: key
            )
        }

        let availabilityForYear = Dictionary(availabilities.map { ($0.year, $0) }) { first, _ in first }

        for (key, value) in plist.symbols.sorted(using: KeyPathComparator(\.key)) {
            guard let availability = availabilityForYear[value] else {
                // Cancel on single failure
                return nil
            }
            availabilityFile.append(ScannedSymbol(name: key, availability: availability))
        }

        // Unfortunately, the data is inconsistent and for some symbols there are conflicting availability dates
        // We just remove those symbols completely
        let symbolsForName = Dictionary(grouping: availabilityFile, by: \.name)
        availabilityFile = availabilityFile.filter { scannedSymbol in
            symbolsForName[scannedSymbol.name]!.allSatisfy { $0.availability == scannedSymbol.availability }
        }
        
        return availabilityFile
    }
}
