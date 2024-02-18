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
        .read(file: "name_aliases", withExtension: "strings")
        .flatMap(StringDictionaryFileParser.parse)?
        .map({ (oldName: $0.key, newName: $0.value) }),
    let legacyAliases = SFFileManager
        .read(file: "legacy_aliases", withExtension: "strings")
        .flatMap(StringDictionaryFileParser.parse)?
        .map({ (legacyName: $0.key, releasedName: $0.value) }),
    var symbolRestrictions = SFFileManager
        .read(file: "symbol_restrictions", withExtension: "strings")
        .flatMap(StringDictionaryFileParser.parse),
    let missingSymbolRestrictions = SFFileManager
        .read(file: "symbol_restrictions_missing", withExtension: "strings")
        .flatMap(StringDictionaryFileParser.parse),
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
nameAliases = nameAliases.filter { alias in !legacyAliases.contains { legacyAlias in legacyAlias.legacyName == alias.oldName } }

// Add missing restricted symbols
symbolRestrictions = symbolRestrictions.merging(missingSymbolRestrictions) { original, _ in
    print("Duplicate restricted symbol was found")
    return original
}

let versionsWithNoLayersetInfo: [String] = []

func otherAliases(for symbolName: String) -> [ScannedSymbol] {
    var result: [String] = []
    let olderAliases = nameAliases.filter { $0.newName == symbolName }.map(\.oldName)
    if olderAliases.isNotEmpty {
        result = olderAliases
    } else if let newestAlias = nameAliases.first(where: { $0.oldName == symbolName })?.newName {
        result = nameAliases
            .filter { $0.newName == newestAlias && $0.oldName != symbolName }
            .map(\.oldName) + [newestAlias]
    }
    return result
        .compactMap { name in symbolManifest.first { $0.name == name } }
        .sorted(on: \.availability, by: >)
}

// Merge all versions of the same symbol into one type.
// This process takes care of merging multiple localized variants + renamed variants from previous versions
var symbols: [Symbol] = []
for scannedSymbol in symbolManifest {
    let localization = Localization.allCases.first { scannedSymbol.name.hasSuffix(".\($0.rawValue)") }
    let nameWithoutSuffix = scannedSymbol.name.replacingOccurrences(
        of: (localization?.rawValue).flatMap { ".\($0)" } ?? "",
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

    let primaryName = nameAliases.first { $0.oldName == nameWithoutSuffix }?.newName ?? nameWithoutSuffix

    let preview: String? = symbolPreviewForName[primaryName]
    if preview == nil {
        symbolsWherePreviewIsntAvailable.append(nameWithoutSuffix)
    }

    let otherAliases = otherAliases(for: nameWithoutSuffix)
    let newerSymbol = otherAliases.filter { $0.availability < scannedSymbol.availability }.first
    let olderSymbol = otherAliases.filter { $0.availability > scannedSymbol.availability }.last

    if let (index, existingSymbol) = (symbols.enumerated().first { $1.name == nameWithoutSuffix }) {
        // The symbol already exists -> Manage localizations

        var availableLocalizations = existingSymbol.availableLocalizations
        var existingLocalizations = existingSymbol.availableLocalizations[scannedSymbol.availability] ?? []

        if let localization = localization {
            existingLocalizations.insert(localization)
        }
        if existingLocalizations.isNotEmpty {
            availableLocalizations[scannedSymbol.availability] = existingLocalizations
        }

        // Remove old symbol & define new symbol
        symbols[index] = Symbol(
            name: nameWithoutSuffix,
            restriction: existingSymbol.restriction,
            preview: existingSymbol.preview ?? preview,
            availability: [existingSymbol.availability, scannedSymbol.availability].max()!,
            isBaseLocalizationAvailable: existingSymbol.isBaseLocalizationAvailable || localization == nil,
            availableLocalizations: availableLocalizations,
            availableLayersets: availableLayersets,
            olderSymbol: existingSymbol.olderSymbol,
            newerSymbol: existingSymbol.newerSymbol
        )
    } else {
        // The symbol doesn't exist yet
        symbols.append(
            .init(
                name: nameWithoutSuffix,
                restriction: symbolRestrictions[primaryName],
                preview: preview,
                availability: scannedSymbol.availability,
                isBaseLocalizationAvailable: localization == nil,
                availableLocalizations: localization.flatMap { [scannedSymbol.availability: [$0]] } ?? [:],
                availableLayersets: availableLayersets,
                olderSymbol: olderSymbol,
                newerSymbol: newerSymbol
            )
        )
    }
}

// This is to fix a rare bug that only localized variants of a symbol, but not the base variant is available
// (see https://github.com/SFSafeSymbols/SFSafeSymbols/issues/107)
symbols = symbols.filter { $0.isBaseLocalizationAvailable }
symbolsWherePreviewIsntAvailable = symbolsWherePreviewIsntAvailable.filter { name in symbols.contains { $0.name == name } }

func layersetsOfAllVersions(of symbol: Symbol) -> [Availability: Set<String>] {
    var toMerge: [Availability: Set<String>] = [:]
    if let newerSymbol = symbol.newerSymbol {
        toMerge = symbols.first { $0.name == newerSymbol.name }!.availableLayersets
    } else if let olderSymbol = symbol.olderSymbol {
        toMerge = symbols.first { $0.name == olderSymbol.name }!.availableLayersets
    }
    return symbol.availableLayersets.merging(toMerge) { $0.union($1) }
}

// MARK: - Step 3: CODE GENERATION

let symbolToCode: (Symbol) -> String = { symbol in
    let completeLayersets = layersetsOfAllVersions(of: symbol)
    let layersetCount = completeLayersets.values.joined().count + 1
    let localizationCount = symbol.availableLocalizations.values.joined().count + 1

    let layersetString: String? = {
        guard !versionsWithNoLayersetInfo.contains(symbol.availability.version) else {
            return nil
        }
        return layersetCount > 1 ? "\(layersetCount) Layersets" : "Single Layerset"
    }()

    // Generate summary for docs (preview + number of localizations, layersets + potential use restriction)
    var outputString = "\t/// " + (symbol.preview ?? "No preview available") + "\n"
    let supplementString = [
        localizationCount > 1 ? "\(localizationCount) Localizations" : "Single Localization",
        layersetString,
        symbol.restriction != nil ? "⚠️ Restricted" : nil
    ].compactMap { $0 }.joined(separator: ", ")
    if supplementString.isNotEmpty {
        outputString += "\t/// \(supplementString)\n"
    }

    // Generate localization docs
    if symbol.availableLocalizations.isNotEmpty { // Omit localization block if only the Latin localization is available
        // Use "Left-to-Right" name for the standard localization if "Right-To-Left" is the only other localization
        let standardLocalizationName = symbol.availableLocalizations.values.joined().contains(.rtl) ? "Left-to-Right" : "Latin"

        outputString += "\t///\n\t/// Localizations:\n\t/// - \(standardLocalizationName)\n"
        var handledLocalizations: Set<Localization> = .init()
        for (availability, localizations) in symbol.availableLocalizations.sorted(on: \.key, by: >) {
            let newLocalizations = localizations.subtracting(handledLocalizations)
            if newLocalizations.isNotEmpty {
                handledLocalizations.formUnion(newLocalizations)
                let availabilityNotice: String = availability < symbol.availability ? " (iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS))" : ""
                for localization in Array(newLocalizations).sorted(on: \.title, by: <) {
                    outputString += "\t/// - \(localization.title)\(availabilityNotice)\n"
                }
            }
        }
    }

    if !versionsWithNoLayersetInfo.contains(symbol.availability.version){
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
    } else {
        outputString += "\t///\n\t/// Layerset information unavailable\n"
    }

    // Generate use restriction docs
    if let restrictionMessage = symbol.restriction {
        outputString += "\t///\n\t/// - Warning: ⚠️ \(restrictionMessage)\n"
    }

    // Generate availability / deprecation specifications
    if let newerSymbol = symbol.newerSymbol {
        let newerName = newerSymbol.name.toPropertyName
        outputString += "\t@available(iOS, introduced: \(symbol.availability.iOS), deprecated: \(newerSymbol.availability.iOS), renamed: \"\(newerName)\")\n"
        outputString += "\t@available(macOS, introduced: \(symbol.availability.macOS), deprecated: \(newerSymbol.availability.macOS), renamed: \"\(newerName)\")\n"
        outputString += "\t@available(tvOS, introduced: \(symbol.availability.tvOS), deprecated: \(newerSymbol.availability.tvOS), renamed: \"\(newerName)\")\n"
        outputString += "\t@available(watchOS, introduced: \(symbol.availability.watchOS), deprecated: \(newerSymbol.availability.watchOS), renamed: \"\(newerName)\")\n"
        outputString += "\t@available(visionOS, introduced: \(symbol.availability.visionOS), deprecated: \(newerSymbol.availability.visionOS), renamed: \"\(newerName)\")\n"
    }

    // Generate symbol
    // Reduce [A: Set<B>] -> [(A, B)] -> [String]
    let structNames = symbol.availableLocalizations.flatMap { availability, localizations in
        localizations.map {
            symbol.availability == availability ? $0.baseStructName : $0.structName(for: availability)
        }
    }.sorted()

    let nonVariadicClassName: (Int) -> String = {
        $0 == 0 ? "SFSymbol" : ("SymbolWith\($0)Localization" + (($0 > 1) ? "s" : ""))
    }
    let variadics = structNames.isNotEmpty ? "<\(structNames.joined(separator: ", "))>" : ""

    outputString += "\tstatic let \(symbol.propertyName) = \(nonVariadicClassName(localizationCount-1))\(variadics)(rawValue: \"\(symbol.name)\")"

    return outputString
}

let localizationsGroupedByAvailability: [Availability: [Symbol: Set<Localization>]] = {
    var result: [Availability: [Symbol: Set<Localization>]] = [:]
    symbols.forEach { sym in
        result[sym.availability, default: [:]][sym] = []
        sym.availableLocalizations.forEach { ava, loc in
            var currentValue = result[ava] ?? [:]
            currentValue[sym, default: []].formUnion(loc)
            result[ava] = currentValue
        }
    }
    return result
}()

let baseAvailability = "@\(Availability.base.availableExpression)"

let symbolLocalizations: String = {
    let availabilities = Array(Set(symbols.map { $0.availability }))
    
    let usedCombinations: [(Localization, Availability)] = (Localization.allCases × availabilities).filter { loc, ava in
        ava.isBase || symbols.contains {
            $0.availability > ava && $0.availableLocalizations[ava]?.contains(loc) ?? false
        }
    }.sorted {
        let ((loc1, ava1), (loc2, ava2)) = ($0, $1)
        return loc1.structName(for: ava1) < loc2.structName(for: ava2)
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
    
    outputString += "public enum Localization: String, Equatable {\n"
    outputString += Localization.allCases.map { "\tcase \($0.variableName) = \"\($0.rawValue)\""}.joined(separator: "\n")
    outputString += "\n}\n\n"
    
    outputString += "// MARK: - Static Localization\n\n"
    outputString += usedCombinations.map(structDecl).joined(separator: "\n\n")
    outputString += "\n"
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

let groupedAllLatestSymbolsFileContents: Dictionary<Availability, String> = localizationsGroupedByAvailability.reduce(into: [:]) {
    let (availability, symbolLocalizations) = $1
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "@\(availability.availableExpression)\n"
    outputString += "extension SFSymbol {\n"
    outputString += "\tinternal static var localizationsAvailableSince\(availability.versionUnderscored): [SFSymbol : Set<Localization>] {\n"
    outputString += "\t\t["
    outputString += symbolLocalizations
        .sorted(on: \.key.name, by: <)
        .map { sym, loc -> String in
            let locSet = "[" + loc.map { "." + $0.variableName }.sorted().joined(separator: ", ") + "]"
            return "\n\t\t\t" + sym.propertyName + ": " + locSet
        }.joined(separator: ",") + "\n"
    outputString += "\t\t]\n"
    outputString += "\t}\n"

    if !availability.isBase {
        outputString += "\n"
        let symbolsDeprecatedSinceThisAvailability = groupedSymbols[availability]!.compactMap(\.olderSymbol?.name).sorted()
        outputString += "\tinternal static var symbolsDeprecatedSince\(availability.versionUnderscored): Set<SFSymbol> {\n"
        outputString += "\t\t["
        outputString += symbolsDeprecatedSinceThisAvailability.map { "\n\t\t\t" + $0.toPropertyName }.joined(separator: ",")
        outputString += symbolsDeprecatedSinceThisAvailability.isNotEmpty ? "\n\t\t" : ""
        outputString += "]\n"
        outputString += "\t}\n"
    }

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

    outputString += "\tinternal static let allLocalizations: [SFSymbol : Set<Localization>] = {\n"
    let availabilities = groupedSymbols.keys.sorted(by: >).dropFirst()
    outputString += "\t\tvar result = localizationsAvailableSince\(Availability.base.versionUnderscored)\n"
    outputString += "\t\t"
    outputString += availabilities.map { availability in
        var bodyString = "if #\(availability.availableExpressionWithoutRedundancyToBase) "
        bodyString += "{\n"
        bodyString += "\t\t\tresult.merge(localizationsAvailableSince\(availability.versionUnderscored)) { $0.union($1) }\n"
        return bodyString
    }.joined(separator: "\t\t}\n\t\t")
    outputString += "\t\t}\n"
    outputString += "\t\treturn result\n"
    outputString += "\t}()\n"

    outputString += "\n"

    outputString += "\tpublic static let allSymbols: Set<SFSymbol> = {\n"
    outputString += "\t\tvar result = Set(allLocalizations.keys)\n"
    outputString += "\t\t"
    outputString += availabilities.map { availability in
        var bodyString = "if #\(availability.availableExpressionWithoutRedundancyToBase) "
        bodyString += "{\n"
        bodyString += "\t\t\tresult.subtract(symbolsDeprecatedSince\(availability.versionUnderscored))\n"
        return bodyString
    }.joined(separator: "\t\t}\n\t\t")
    outputString += "\t\t}\n"
    outputString += "\t\treturn result\n"
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

if symbolsWherePreviewIsntAvailable.isNotEmpty {
    print("⚠️ No symbol preview available for symbols \(symbolsWherePreviewIsntAvailable)", to: &stderr)
}
