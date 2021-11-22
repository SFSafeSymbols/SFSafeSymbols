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
    let localizationSuffixes = SFFileManager
        .read(file: "localization_suffixes", withExtension: "txt")
        .flatMap(StringEqualityFileParser.parse),
    let symbolNames = SFFileManager
        .read(file: "symbol_names", withExtension: "txt")
        .flatMap(SymbolNamesFileParser.parse),
    let symbolPreviews = SFFileManager
        .read(file: "symbol_previews", withExtension: "txt")
        .flatMap(SymbolPreviewsFileParser.parse)
else {
    fatalError("Error reading input files")
}

guard CommandLine.argc > 1 else {
    fatalError("Invalid output Directory")
}
let outputDir = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)

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
    let localizationSuffixAndName: (lhs: String, rhs: String)? = localizationSuffixes.first { scannedSymbol.name.hasSuffix(".\($0.lhs)") }
    let localization: String? = localizationSuffixAndName?.rhs
    let nameWithoutSuffix = scannedSymbol.name.replacingOccurrences(
        of: (localizationSuffixAndName?.lhs).flatMap { ".\($0)" } ?? "",
        with: ""
    )

    var availableLayersets: [Availability: Set<String>] = [:]

    // Only lookup layerset availability for main name (without loclization suffix)
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

func localizationsOfAllVersions(of symbol: Symbol) -> [Availability: Set<String>] {
    let toMerge: [Availability: Set<String>]
    switch symbol.type {
        case .replaced(let newerSymbol):
            toMerge = symbols.first { $0.name == newerSymbol.name }!.availableLocalizations
        case .replacement(let originalSymbol):
            toMerge = symbols.first { $0.name == originalSymbol.name }!.availableLocalizations
        default: toMerge = [:]
    }
    return symbol.availableLocalizations.merging(toMerge) { $0.union($1) }
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
    let completeLocalizations = localizationsOfAllVersions(of: symbol)
    let layersetCount = completeLayersets.values.reduce(0) { $0 + $1.count } + 1
    let localizationCount = completeLocalizations.values.reduce(0) { $0 + $1.count } + 1

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

    // Generate localization docs based on the assumption that localizations don't get removed
    if !completeLocalizations.isEmpty {
        outputString += "\t///\n\t/// Localizations:\n\t/// - Latin\n"
        var handledLocalizations: Set<String> = .init()
        for (availability, localizations) in completeLocalizations.sorted(by: { $0.0 > $1.0 }) {
            let newLocalizations = localizations.subtracting(handledLocalizations)
            if !newLocalizations.isEmpty {
                handledLocalizations.formUnion(newLocalizations)
                let availabilityNotice: String = availability < symbol.availability ? " (\(availability.version) – iOS \(availability.iOS))" : ""
                for localization in Array(newLocalizations).sorted() {
                    outputString += "\t/// - \(localization)\(availabilityNotice)\n"
                }
            }
        }
    }

    // Generate layerset availability docs based on the assumption that layersets don't get removed
    if !completeLayersets.isEmpty {
        var handledLayersets: Set<String> = .init()
        outputString += "\t///\n\t/// Layersets:\n\t/// - Monochrome\n"
        for (availability, layersets) in completeLayersets.sorted(by: { $0.0 > $1.0 }) {
            let newLayersets = layersets.subtracting(handledLayersets)
            if !newLayersets.isEmpty {
                handledLayersets.formUnion(newLayersets)
                let availabilityNotice: String = availability < symbol.availability ? " (\(availability.version) – iOS \(availability.iOS))" : ""
                for layerset in Array(newLayersets).sorted() {
                    outputString += "\t/// - \(layerset.capitalized)\(availabilityNotice)\n"
                }
            }
        }
    }

    // Generate canOnlyReferTo docs
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

    // Generate case
    outputString += "\tstatic let \(symbol.propertyName) = SFSymbol(rawValue: \"\(symbol.name)\")"

    return outputString
}

let groupedSymbols = Dictionary(grouping: symbols, by: \.availability)

let availabilityExtensions: [String] = groupedSymbols.map { availability, symbols in
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "// \(availability.version) Symbols\n"
    outputString += "@available(iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS), *)\n"
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
    outputString += "@available(iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS), *)\n"
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
    //

    outputString += "\tpublic static var allSymbols: Set<SFSymbol> = {\n"
    outputString += "\t\t"
    outputString += groupedAllLatestSymbolsFileContents.keys.sorted().map { availability in
        let versionUnderscored = availability.version.replacingOccurrences(of: ".", with: "_")
        var bodyString = availability.isBase ? "" : "if #available(iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS), *) "
        bodyString += "{\n"
        bodyString += "\t\t\treturn allSymbols\(versionUnderscored)\n"
        return bodyString
    }.joined(separator: "\t\t} else ")
    outputString += "\t\t}\n"
    outputString += "\t}()\n"
    outputString += "}\n"
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

// MARK: - Step 5: FINISHING

if !symbolsWherePreviewIsntAvailable.isEmpty {
    print("⚠️ No symbol preview available for symbols \(symbolsWherePreviewIsntAvailable)", to: &stderr)
}
