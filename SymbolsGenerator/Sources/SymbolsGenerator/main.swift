import AppKit
import Foundation

// MARK: - Step 1: READ INPUT FILES

guard
    let symbolManifest = SFFileManager
        .read(file: "name_availability", withExtension: "plist")
        .flatMap(SymbolManifestParser.parse),
    let layerSetAvailabilitiesList = SFFileManager
        .read(file: "layerset_availability", withExtension: "plist")
        .flatMap(LayersetAvailabilityParser.parse),
    var nameAliases = SFFileManager
        .read(file: "name_aliases_strings", withExtension: "txt")
        .flatMap(StringEqualityFileParser.parse),
    let legacyAliases = SFFileManager
        .read(file: "legacy_aliases_strings", withExtension: "txt")
        .flatMap(StringEqualityFileParser.parse),
    let asIsSymbols = SFFileManager
        .read(file: "as_is_symbols", withExtension: "txt")
        .flatMap(StringEqualityFileParser.parse),
    let localizations = SFFileManager
        .read(file: "localization_suffixes", withExtension: "txt")
        .flatMap(StringEqualityFileParser.parse)?.map(Localization.init(suffix:longName:)),
    let symbolNames = SFFileManager
        .read(file: "symbol_names", withExtension: "txt")
        .flatMap(SymbolNamesFileParser.parse),
    let symbolPreviews = SFFileManager
        .read(file: "symbol_previews", withExtension: "txt")
        .flatMap(SymbolPreviewsFileParser.parse)
else {
    fatalError("Error reading input files")
}

/*guard CommandLine.argc > 1 else {
    fatalError("Invalid output Directory")
}*/
let outputDir = URL(fileURLWithPath: "/Users/David/Desktop/A", isDirectory: true)

// MARK: - Step 2: MERGE INTO SINGLE DATABASE

// Create symbol preview dictionary based on symbolNames and symbolPreviews
let symbolPreviewForName: [String: String] = Dictionary(uniqueKeysWithValues: zip(symbolNames, symbolPreviews))
var symbolsWherePreviewIsntAvailable: [String] = []

// Remove legacy symbols
nameAliases = nameAliases.filter { lhs, _ in !legacyAliases.contains { $0.lhs == lhs } }

// Merge all versions of the same symbol into one type.
// This process takes care of merging multiple localized variants + renamed variants from previous versions
var symbols: [Symbol] = []
for scannedSymbol in symbolManifest {
    let localization = localizations.first { scannedSymbol.name.hasSuffix(".\($0.suffix)") }
    let nameWithoutSuffix = scannedSymbol.name.replacingOccurrences(
        of: (localization?.suffix).flatMap { ".\($0)" } ?? "",
        with: ""
    )

    var availableLayersets: [Availability: Set<String>] = [:]

    // Only lookup layerset availability for main name (without localization suffix)
    // Assuming it is equal across all localizations...
    for layersetAvailability in layerSetAvailabilitiesList[nameWithoutSuffix] ?? [] {
        availableLayersets[layersetAvailability.availability] =
            (availableLayersets[layersetAvailability.availability] ?? Set())
            .union([layersetAvailability.name])
    }

    let primaryName = nameAliases.first { $0.lhs == nameWithoutSuffix }?.rhs ?? nameWithoutSuffix

    let preview: String? = symbolPreviewForName[primaryName]
    if preview == nil {
        symbolsWherePreviewIsntAvailable.append(nameWithoutSuffix)
    }

    let symbolType: SymbolType = {
        if let aliasName = nameAliases.first(where: { $0.lhs == nameWithoutSuffix })?.rhs {
            // Search for in-between aliases (if symbol was renamed as A -> B -> C, Apple only mentions the A -> C)
            let lhsSymbols = nameAliases.filter { $0.rhs == aliasName }
                .map { currentAlias in symbolManifest.first(where: { $0.name == currentAlias.lhs })! }
                .filter { $0.availability < scannedSymbol.availability }
                .sorted { $0.availability > $1.availability }
            if let firstLhsSymbol = lhsSymbols.first {
                return .replaced(by: firstLhsSymbol)
            } else {
                return .replaced(by: symbolManifest.first { $0.name == aliasName }!)
            }
        } else if let aliasName = nameAliases.first(where: { $0.rhs == nameWithoutSuffix })?.lhs {
            return .replacement(for: symbolManifest.first { $0.name == aliasName }!)
        } else {
            return .normal
        }
    }()

    if let (index, existingSymbol) = (symbols.enumerated().first { $1.name == nameWithoutSuffix }) {
        // The symbol already exists -> Manage localizations

        var availableLocalizations = existingSymbol.availableLocalizations
        var existingLocalizations = existingSymbol.availableLocalizations[scannedSymbol.availability] ?? []

        if let localization = localization {
            existingLocalizations.insert(localization)
        }
        if !existingLocalizations.isEmpty {
            availableLocalizations[scannedSymbol.availability] = existingLocalizations
        }

        // Remove old symbol & define new symbol
        symbols[index] = Symbol(
            name: nameWithoutSuffix,
            restriction: existingSymbol.restriction,
            preview: existingSymbol.preview ?? preview,
            availability: [existingSymbol.availability, scannedSymbol.availability].max()!,
            availableLocalizations: availableLocalizations,
            availableLayersets: availableLayersets,
            type: existingSymbol.type
        )
    } else {
        // The symbol doesn't exist yet
        symbols.append(
            .init(
                name: nameWithoutSuffix,
                restriction: asIsSymbols.first { $0.lhs == primaryName }?.rhs,
                preview: preview,
                availability: scannedSymbol.availability,
                availableLocalizations: localization.flatMap { [scannedSymbol.availability: [$0]] } ?? [:],
                availableLayersets: availableLayersets,
                type: symbolType
            )
        )
    }
}

func layersetsOfAllVersions(of symbol: Symbol) -> [Availability: Set<String>] {
    let toMerge: [Availability: Set<String>]
    switch symbol.type {
        case .replaced(let newerSymbol):
            toMerge = symbols.first { $0.name == newerSymbol.name }!.availableLayersets
        case .replacement(let originalSymbol):
            toMerge = symbols.first { $0.name == originalSymbol.name }!.availableLayersets
        default: toMerge = [:]
    }
    return symbol.availableLayersets.merging(toMerge) { $0.union($1) }
}

// MARK: - Step 3: CODE GENERATION

let symbolToCode: (Symbol) -> String = { symbol in
    let completeLayersets = layersetsOfAllVersions(of: symbol)
    let layersetCount = completeLayersets.values.reduce(Set<String>()) { $0.union($1) }.count + 1
    let localizationCount = symbol.availableLocalizations.values.reduce(Set()) { $0.union($1) }.count + 1

    // Generate summary for docs (preview + number of localizations, layersets + potential use restriction)
    var outputString = "\t/// " + (symbol.preview ?? "No preview available") + "\n"
    let supplementString = [
        localizationCount > 1 ? "\(localizationCount) Localizations" : "Single Localization",
        layersetCount > 1 ? "\(layersetCount) Layersets" : "Single Layerset",
        symbol.restriction != nil ? "⚠️ Restricted" : nil
    ].compactMap { $0 }.joined(separator: ", ")
    if !supplementString.isEmpty {
        outputString += "\t/// \(supplementString)\n"
    }

    // Generate localization docs
    if !symbol.availableLocalizations.isEmpty { // Omit localization block if only the Latin localization is available
        // Use "Left-to-Right" name for the standard localization if "Right-To-Left" is the only other localization
        let standardLocalizationName = symbol.availableLocalizations.values.reduce(Set()) {
            $0.union(Set($1.map { $0.longName }))
        } == ["Right-To-Left"] ? "Left-To-Right" : "Latin"

        outputString += "\t///\n\t/// Localizations:\n\t/// - \(standardLocalizationName)\n"
        var handledLocalizations: Set<Localization> = .init()
        for (availability, localizations) in symbol.availableLocalizations.sorted(by: { $0.0 > $1.0 }) {
            let newLocalizations = localizations.subtracting(handledLocalizations)
            if !newLocalizations.isEmpty {
                handledLocalizations.formUnion(newLocalizations)
                let availabilityNotice: String = availability < symbol.availability ? " (iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS))" : ""
                for localization in (Array(newLocalizations).sorted { $0.longName < $1.longName }) {
                    outputString += "\t/// - \(localization.longName)\(availabilityNotice)\n"
                }
            }
        }
    }

    // Generate layerset availability docs based on the assumption that layersets don't get removed
    var handledLayersets: Set<String> = .init()
    outputString += "\t///\n\t/// Layersets:\n\t/// - Monochrome\n"
    for (availability, layersets) in completeLayersets.sorted(by: { $0.0 > $1.0 }) {
        let newLayersets = layersets.subtracting(handledLayersets)
        if !newLayersets.isEmpty {
            handledLayersets.formUnion(newLayersets)
            let availabilityNotice: String = availability < symbol.availability ? " (iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS))" : ""
            for layerset in Array(newLayersets).sorted() {
                outputString += "\t/// - \(layerset.capitalized)\(availabilityNotice)\n"
            }
        }
    }

    // Generate use restriction docs
    if let restrictionMessage = symbol.restriction {
        outputString += "\t///\n\t/// - Warning: ⚠️ \(restrictionMessage)\n"
    }

    // Generate availability / deprecation specifications
    if case let .replaced(newerSymbol) = symbol.type {
        let newerName = newerSymbol.name.toPropertyName
        outputString += "\t@available(iOS, introduced: \(symbol.availability.iOS), deprecated: \(newerSymbol.availability.iOS), renamed: \"\(newerName)\")\n"
        outputString += "\t@available(macOS, introduced: \(symbol.availability.macOS), deprecated: \(newerSymbol.availability.macOS), renamed: \"\(newerName)\")\n"
        outputString += "\t@available(tvOS, introduced: \(symbol.availability.tvOS), deprecated: \(newerSymbol.availability.tvOS), renamed: \"\(newerName)\")\n"
        outputString += "\t@available(watchOS, introduced: \(symbol.availability.watchOS), deprecated: \(newerSymbol.availability.watchOS), renamed: \"\(newerName)\")\n"
    }

    // Generate symbol
    if symbol.availableLocalizations.isEmpty {
        outputString += "\tstatic let \(symbol.propertyName) = SFSymbol(rawValue: \"\(symbol.name)\")"
    } else {
        // Reduce [A: Set<B>] -> [(A, B)] -> [String]
        let protocolNames = symbol.availableLocalizations.flatMap { availability, localizations in
            localizations.map { $0.protocolName(for: availability) }
        }

        let protocols = (["SFSymbol"] + protocolNames).joined(separator: " & ")
        outputString += "\tstatic let \(symbol.propertyName): \(protocols) = LocalizableSymbol(rawValue: \"\(symbol.name)\")"
    }

    return outputString
}

let allAvailabilities = Array(Set(symbols.map { $0.availability })).sorted(by: >) // Base availability (v1.0) is first
let groupedSymbols = Dictionary(grouping: symbols, by: \.availability)

let availabilityExtensions: [String] = groupedSymbols.map { availability, symbols in
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "// \(availability.version) Symbols\n"
    outputString += "@\(availability.availableExpression)\n"
    outputString += "public extension SFSymbol {\n"
    outputString += symbols.map(symbolToCode).joined(separator: "\n\n")
    outputString += "\n}\n"
    return outputString
}

let groupedAllLatestSymbols: Dictionary<Availability, [Symbol]> = groupedSymbols.keys.reduce(into: [:]) { result, current in
    result[current] = symbols.filter { $0.availability >= current }.filter {
        switch $0.type {
            case .replaced(let replacementSymbol): return replacementSymbol.availability < current
            default: return true
        }
    }
}

let groupedAllLatestSymbolsFileContents: Dictionary<Availability, String> = groupedAllLatestSymbols.reduce(into: [:]) {
    let availability = $1.key
    let symbols = $1.value
    let versionUnderscored = availability.version.replacingOccurrences(of: ".", with: "_")
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "@\(availability.availableExpression)\n"
    outputString += "extension SFSymbol {\n"
    outputString += "\tinternal static var allSymbols\(versionUnderscored): Set<SFSymbol> { \n"
    outputString += "\t\t[\n"
    outputString += symbols.map { "\t\t\t" + $0.propertyName }.joined(separator: ",\n") + "\n"
    outputString += "\t\t]\n"
    outputString += "\t}\n"
    outputString += "}\n"
    $0[availability] = outputString
}

let allSymbolsExtension: String = {
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)\n"
    outputString += "extension SFSymbol {\n"

    // `allCases` has been deprecated with the v3 release (fall of 2021)
    // It shall be removed entirely ~2 years after the v3 release
    outputString += "\t@available(*, deprecated, renamed: \"allSymbols\")\n"
    outputString += "\tpublic static var allCases: [SFSymbol] { Array(allSymbols) }\n\n"

    outputString += "\tpublic static var allSymbols: SFSymbolSet = {\n"
    outputString += "\t\t"
    outputString += groupedAllLatestSymbolsFileContents.keys.sorted().map { availability in
        let versionUnderscored = availability.version.replacingOccurrences(of: ".", with: "_")
        var bodyString = availability.isBase ? "" : "if #\(availability.availableExpression) "
        bodyString += "{\n"
        bodyString += "\t\t\treturn SFSymbolSet(elements: allSymbols\(versionUnderscored))\n"
        return bodyString
    }.joined(separator: "\t\t} else ")
    outputString += "\t\t}\n"
    outputString += "\t}()\n"
    outputString += "}\n"
    return outputString
}()

let localizable: String = {
    let protocolFor: (Availability, Localization) -> String = { availability, localization -> String in
        "@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)\n" +
            "public protocol \(localization.protocolName(for: availability)) {\n" +
            (availability.isBase ? "" : "\t@\(availability.availableExpression)\n") +
            "\tvar \(localization.variableName): SFSymbol { get }\n" +
        "}"
    }

    let property: (Localization) -> String = { localization -> String in
        "\tvar \(localization.variableName): SFSymbol { .init(rawValue: \"\\(rawValue).\(localization.suffix)\") }"
    }

    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)\n"
    let protocols = (allAvailabilities × localizations).map { $1.protocolName(for: $0) }.joined(separator: ", ")
    outputString += "internal class LocalizableSymbol: SFSymbol, \(protocols) {\n"
    outputString += localizations.map(property).joined(separator: "\n")
    outputString += "\n}\n\n"
    outputString += (allAvailabilities × localizations).map(protocolFor).joined(separator: "\n\n")
    return outputString
}()

let symbolSetExtension: String = {
    let codeFor: (Localization) -> String = { loc -> String in
        var output = "\t/// Localize each symbol in the collection in \(loc.longName).\n"
        output += "\t/// Symbols which are not localizable in \(loc.longName) remain unchanged.\n"
        output += "\tvar \(loc.variableName): Set<SFSymbol> {\n\t\tSet(map { symbol in\n"
        let lines: [String] = allAvailabilities.map { ava -> String in
            (ava.isBase ? "\t\t\tif" : "\t\t\t} else if #\(ava.availableExpression),")
                + " symbol is \(loc.protocolName(for: ava)) {\n"
                + "\t\t\t\treturn (symbol as! \(loc.protocolName(for: ava))).\(loc.variableName)"
        } + ["\t\t\t} else {\n\t\t\t\treturn symbol\n\t\t\t}"]
        output += lines.joined(separator: "\n") + "\n\t\t})\n\t}"
        return output
    }

    var outputString =
        "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n" +
        "@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)\n" +
        "public extension SFSymbolSet {\n" +
        "\t/// Return every localized variant of every symbol.\n" +
        "\tvar allLocalizedVariants: Set<SFSymbol> {\n" +
        "\t\t\((["elements"] + localizations.map { "(\($0.variableName))" }).joined(separator: ".union"))\n" +
        "\t}\n\n"
    outputString += localizations.map(codeFor).joined(separator: "\n\n")
    outputString += "\n}"
    return outputString
}()

// MARK: - Step 4: OUTPUT

// Write availability extensions
zip(groupedSymbols.keys, availabilityExtensions).forEach { availability, fileContents in
    let outputPath = outputDir.appendingPathComponent("SFSymbol+\(availability.version).swift")
    SFFileManager.write(fileContents, to: outputPath)
}

// Write AllSymbols extensions
groupedAllLatestSymbolsFileContents.forEach { availability, fileContents in
    let outputPath = outputDir.appendingPathComponent("SFSymbol+AllSymbols+\(availability.version).swift")
    SFFileManager.write(fileContents, to: outputPath)
}

SFFileManager.write(allSymbolsExtension,
                    to: outputDir.appendingPathComponent("SFSymbol+AllSymbols.swift"))

SFFileManager.write(localizable,
                    to: outputDir.appendingPathComponent("Localizable.swift"))

SFFileManager.write(symbolSetExtension,
                    to: outputDir.appendingPathComponent("SFSymbolSet+Localizable.swift"))

// MARK: - Step 5: FINISHING

if !symbolsWherePreviewIsntAvailable.isEmpty {
    print("⚠️ No symbol preview available for symbols \(symbolsWherePreviewIsntAvailable)", to: &stderr)
}
