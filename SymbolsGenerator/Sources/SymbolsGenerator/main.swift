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
    var symbolRestrictions = SFFileManager
        .read(file: "symbol_restrictions", withExtension: "strings")
        .flatMap(SymbolRestrictionsParser.parse),
    let missingSymbolRestrictions = SFFileManager
        .read(file: "symbol_restrictions_missing", withExtension: "strings")
        .flatMap(SymbolRestrictionsParser.parse),
    let localizations = SFFileManager
        .read(file: "localization_suffixes", withExtension: "txt")
        .flatMap(StringEqualityFileParser.parse)?
        .map(Localization.init(suffix:longName:)),
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

// Add missing restricted symbols
symbolRestrictions = symbolRestrictions.merging(missingSymbolRestrictions) { original, _ in
    print("Duplicate restricted symbol was found")
    return original
}

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
                restriction: symbolRestrictions[primaryName],
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
    // Reduce [A: Set<B>] -> [(A, B)] -> [String]
    let structNames = symbol.availableLocalizations.flatMap { availability, localizations in
        localizations.map {
            symbol.availability == availability ? $0.baseStructName : $0.structName(for: availability)
        }
    }.sorted()

    let nonVariadicClassName: (Int) -> String = {
        $0 == 0 ? "NonLocalizedSymbol" : ("SymbolWith\($0)Localization" + (($0 > 1) ? "s" : ""))
    }
    let variadics = structNames.isEmpty ? "" : "<\(structNames.joined(separator: ", "))>"

    outputString += "\tstatic let \(symbol.propertyName) = \(nonVariadicClassName(localizationCount-1))\(variadics)(rawValue: \"\(symbol.name)\")"

    return outputString
}

let baseAvailability = "@\(Availability.base.availableExpression)"

let symbolLocalizations: String = {
    let availabilities = Array(Set(symbols.map { $0.availability }))
    
    let usedCombinations: [(Localization, Availability)] = (localizations × availabilities).filter { loc, ava in
        ava.isBase || symbols.contains {
            $0.availability > ava && $0.availableLocalizations[ava]?.contains(loc) ?? false
        }
    }.sorted {
        let ((loc1, ava1), (loc2, ava2)) = ($0, $1)
        return loc1.structName(for: ava1) < loc2.structName(for: ava2)
    }
    
    let groupedCombinations = Dictionary(grouping: usedCombinations) { $0.1 }
    
    let enclosingIfStatement: (Availability) -> String = { ava in
        let enclosingIf = "\t\tif #\(ava.availableExpressionWithoutRedundancyToBase) {"
        let locs = groupedCombinations[ava]!.map { $0.0 }
        let deeperIfs = locs.map { loc in
            "\t\t\tif (localizations.contains { $0 == \(loc.structName(for: ava)).self }) { result.update(with: .\(loc.variableName)) }"
        }
        return ([enclosingIf] + deeperIfs + ["\t\t}"]).joined(separator: "\n")
    }
    
    let structDecl: (Localization, Availability) -> String = { loc, ava in
        var outputString = "\(baseAvailability)\n"
        outputString += "public struct \(loc.structName(for: ava)): SymbolLocalization {\n"
        outputString += "\tlet source: SFSymbol\n"
        outputString += "\tpublic init(source: SFSymbol) { self.source = source }\n"
        outputString += "\t@\(ava.availableExpression)\n"
        outputString += "\tpublic var \(loc.variableName): SFSymbol { .init(rawValue: \"\\(source.rawValue).\\(Localization.\(loc.variableName).rawValue)\") }\n"
        outputString += "}"
        return outputString
    }
    
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    
    outputString += "// MARK: - Dynamic Localization\n\n"
    outputString += "public enum Localization: String, Equatable {\n"
    outputString += localizations.map { "\tcase \($0.variableName) = \"\($0.suffix)\""}.joined(separator: "\n")
    outputString += "\n}\n\n"
    outputString += "\(baseAvailability)\n"
    outputString += "internal extension LocalizableSFSymbol {\n"
    outputString += "\tvar _availableLocalizations: Set<Localization> {\n"
    outputString += "\t\tvar result = Set<Localization>()\n"
    outputString += groupedCombinations.keys.sorted().map(enclosingIfStatement).joined(separator: "\n")
    outputString += "\n\t\treturn result\n"
    outputString += "\t}\n}\n\n"
    
    outputString += "// MARK: - Static Localization\n\n"
    outputString += usedCombinations.map(structDecl).joined(separator: "\n\n")
    return outputString
}()

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
    outputString += "\tinternal static var allSymbols\(versionUnderscored): Set<LocalizableSFSymbol> { \n"
    outputString += "\t\t[\n"
    outputString += symbols.map { "\t\t\t" + $0.propertyName }.joined(separator: ",\n") + "\n"
    outputString += "\t\t]\n"
    outputString += "\t}\n"
    outputString += "}\n"
    $0[availability] = outputString
}

let allSymbolsExtension: String = {
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "\(baseAvailability)\n"
    outputString += "extension SFSymbol {\n"

    // `allCases` has been deprecated with the v3 release (spring of 2022)
    // It shall be removed entirely ~2 years after the v3 release
    outputString += "\t@available(*, deprecated, renamed: \"allSymbols\")\n"
    outputString += "\tpublic static var allCases: [SFSymbol] { Array(allSymbols) }\n\n"
    //

    outputString += "\tpublic static var allSymbols: Set<LocalizableSFSymbol> = {\n"
    outputString += "\t\t"
    outputString += groupedAllLatestSymbolsFileContents.keys.sorted().map { availability in
        let versionUnderscored = availability.version.replacingOccurrences(of: ".", with: "_")
        var bodyString = availability.isBase ? "" : "if #\(availability.availableExpressionWithoutRedundancyToBase) "
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

SFFileManager.write(symbolLocalizations,
                    to: outputDir.appendingPathComponent("SymbolLocalizations.swift"))

SFFileManager.write(allSymbolsExtension,
                    to: outputDir.appendingPathComponent("SFSymbol+AllSymbols.swift"))

// MARK: - Step 5: FINISHING

if !symbolsWherePreviewIsntAvailable.isEmpty {
    print("⚠️ No symbol preview available for symbols \(symbolsWherePreviewIsntAvailable)", to: &stderr)
}
