import AppKit
import Foundation

// MARK: - Step 1: READ INPUT FILES

guard
    let symbolManifest = SFFileManager
        .read(file: "name_availability", withExtension: "plist")
        .flatMap(SymbolManifestParser.parse),
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
    let nameWithoutSuffix = scannedSymbol.name.replacingOccurrences(of: (localizationSuffixAndName?.lhs).flatMap { ".\($0)" } ?? "",
                                                                    with: "")

    let primaryName = nameAliases.first { $0.lhs == nameWithoutSuffix }?.rhs ?? nameWithoutSuffix

    let preview: String? = symbolPreviewForName[primaryName]
    if preview == nil {
        symbolsWherePreviewIsntAvailable.append(nameWithoutSuffix)
    }

    let symbolType: SymbolType = {
        if let aliasName = nameAliases.first(where: { $0.lhs == nameWithoutSuffix })?.rhs {
            return .replaced(by: symbolManifest.first { $0.name == aliasName }!)
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
            canOnlyReferTo: existingSymbol.canOnlyReferTo,
            preview: existingSymbol.preview ?? preview,
            availability: [existingSymbol.availability, scannedSymbol.availability].max()!,
            availableLocalizations: availableLocalizations,
            type: existingSymbol.type
        )
    } else {
        // The symbol doesn't exist yet
        symbols.append(
            .init(
                name: nameWithoutSuffix,
                canOnlyReferTo: asIsSymbols.first { $0.lhs == primaryName }?.rhs,
                preview: preview,
                availability: scannedSymbol.availability,
                availableLocalizations: localization.flatMap { [scannedSymbol.availability: [$0]] } ?? [:],
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

// MARK: - Step 3: CODE GENERATION

let symbolToCode: (Symbol) -> String = { symbol in
    // Generate preview docs
    var outputString = "\t/// " + (symbol.preview ?? "No preview available.") + "\n"

    // Generate localization docs based on the assumption that localizations don't get removed
    var handledLocalizations: Set<String> = .init()
    for (availability, localizations) in localizationsOfAllVersions(of: symbol).sorted(by: { $0.0 > $1.0 }) {
        let newLocalizations = localizations.subtracting(handledLocalizations)
        if !newLocalizations.isEmpty {
            handledLocalizations.formUnion(newLocalizations)
            outputString += "\t/// From iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS) and watchOS \(availability.watchOS) on, the following localizations are available: \(Array(newLocalizations).sorted().joined(separator: ", "))\n"
        }
    }

    // Generate canOnlyReferTo docs
    if let canOnlyReferTo = symbol.canOnlyReferTo {
        outputString += "\t/// ⚠️ This symbol can refer only to Apple's \(canOnlyReferTo).\n"
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
    outputString += "// \(availability.year) Symbols\n"
    outputString += "@available(iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS), *)\n"
    outputString += "public extension SFSymbol {\n"
    outputString += symbols.map(symbolToCode).joined(separator: "\n\n")
    outputString += "\n}\n"
    return outputString
}

var caseIterableExtension: String = {
    var outputString = "// Don't touch this manually, this code is generated by the SymbolsGenerator helper tool\n\n"
    outputString += "@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)\n"
    outputString += "extension SFSymbol: CaseIterable {\n"
    outputString += "\tpublic static var allCases: [SFSymbol] = {\n\t\t"

    let temp: [(Availability, [Symbol])] = groupedSymbols.keys.sorted().map { availability in
        return (availability, symbols.filter { $0.availability >= availability })
    }

    let body: String = temp.map { availability, symbols in
        var bodyString = availability.isBase ? "" : "if #available(iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS), *) "
        bodyString += "{\n"
        bodyString += "\t\t\t// MARK: - \(availability.year)\n"
        bodyString += "\t\t\treturn [\n" + symbols.map { "\t\t\t\t.\($0.propertyName)" }.joined(separator: ",\n") + "\n\t\t\t]\n"
        bodyString += "\t\t}"
        return bodyString
    }.joined(separator: " else ")

    outputString += body
    outputString += "\n\t}()\n}\n"
    return outputString
}()

// MARK: - Step 4: OUTPUT

// Write availability extenstions
zip(groupedSymbols.keys, availabilityExtensions).forEach { availability, fileContents in
    let outputPath = outputDir.appendingPathComponent("SFSymbol+\(availability.year).swift")
    SFFileManager.write(fileContents, to: outputPath)
}

// Write CaseIterable extenstion
SFFileManager.write(caseIterableExtension,
                    to: outputDir.appendingPathComponent("SFSymbol+CaseIterable.swift"))

// MARK: - Step 5: FINISHING

if !symbolsWherePreviewIsntAvailable.isEmpty {
    print("⚠️ No symbol preview available for symbols \(symbolsWherePreviewIsntAvailable)", to: &stderr)
}
