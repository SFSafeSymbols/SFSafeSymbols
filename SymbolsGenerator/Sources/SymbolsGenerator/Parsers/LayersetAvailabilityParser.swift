import Foundation

typealias LayersetAvailabilitiesList = [String: [LayersetAvailability]]

struct LayersetAvailabilityParser {
    private struct Plist: Decodable {
        enum CodingKeys: String, CodingKey {
            case symbols
            case yearToReleaseMapping = "year_to_release"
        }

        var symbols: [String: [String: String]]
        var yearToReleaseMapping: [String: [String: String]]
    }

    static func parse(layersetAvailabilityFileData: Data?) -> LayersetAvailabilitiesList? {
        guard
            let data = layersetAvailabilityFileData,
            let plist = try? PropertyListDecoder().decode(Plist.self, from: data)
        else {
            return nil
        }

        var layersetAvailabilitiesList: LayersetAvailabilitiesList = [:]
        let availabilities = plist.yearToReleaseMapping.compactMap { key, value in
            Availability(iOS: value["iOS"]!, tvOS: value["tvOS"]!, watchOS: value["watchOS"]!, macOS: value["macOS"]!, year: key)
        }

        for (key, value) in plist.symbols.sorted(on: \.key, by: <) {
            var layerSetAvailabilities = [LayersetAvailability]()

            for (layerset, year) in value {
                guard let availability = (availabilities.first { $0.year == year }) else {
                    // Cancel on single failure
                    return nil
                }

                layerSetAvailabilities.append(LayersetAvailability(name: layerset, availability: availability))
            }

            layersetAvailabilitiesList[key] = layerSetAvailabilities
        }

        return layersetAvailabilitiesList
    }
}
