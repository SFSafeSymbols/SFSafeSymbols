import AppKit
import Foundation

// MARK: - Step 1: READ INPUT FILES
print("⏳ GENERATING...")

guard
    let symbolManifest = FileReader.read(file: "name_availability.plist").flatMap(SymbolManifestParser.parse),
    var nameAliases = FileReader.read(file: "name_aliases_strings.txt").flatMap(StringEqualityFileParser.parse),
    let legacyAliases = FileReader.read(file: "legacy_aliases_strings.txt").flatMap(StringEqualityFileParser.parse),
    let asIsSymbols = FileReader.read(file: "as_is_symbols.txt").flatMap(StringEqualityFileParser.parse),
    let localizationSuffixes = FileReader.read(file: "localization_suffixes.txt").flatMap(StringEqualityFileParser.parse),
    let symbolNames = FileReader.read(file: "symbol_names.txt").flatMap(SymbolNamesFileParser.parse),
    let symbolPreviews = FileReader.read(file: "symbol_previews.txt").flatMap(SymbolPreviewsFileParser.parse)
else {
    fatalError("Error reading input files")
}

// MARK: - Step 2: MERGE INTO SINGLE DATABASE

// Create symbol preview dictionary based on symbolNames and symbolPreviews
let symbolPreviewForName: [String: String] = Dictionary(uniqueKeysWithValues: zip(symbolNames, symbolPreviews))
var symbolsWherePreviewIsntAvailable: [String] = []

// Merge the two alias files
nameAliases = nameAliases.filter { lhs, rhs in !legacyAliases.contains { $0.lhs == lhs && $0.rhs == rhs } }

// Merge all versions of the same symbol into one type.
// This process takes care of merging multiple localized variants + renamed variants from previous versions
var symbols: [Symbol] = .init()
for scannedSymbol in symbolManifest {
    let localizationSuffixAndName: (lhs: String, rhs: String)? = localizationSuffixes.first { scannedSymbol.name.hasSuffix(".\($0.lhs)") }
    let localization: String? = localizationSuffixAndName?.rhs
    let nameWithoutSuffix: String = String(scannedSymbol.name.dropLast((localizationSuffixAndName?.lhs.count ?? -1) + 1)) // + 1 because the . before the suffix must also go

    let preview: String? = symbolPreviewForName[nameWithoutSuffix]
    if preview == nil {
        symbolsWherePreviewIsntAvailable.append(nameWithoutSuffix)
    }

    let primaryName = nameAliases.first { $0.lhs == nameWithoutSuffix }?.rhs ?? nameWithoutSuffix

    let newSymbol: Symbol
    if let (index, existingSymbol) = (symbols.enumerated().first { $1.name == primaryName }) {
        // The symbol already exists -> Manage localizations
        var availableLocalizations: [Availability: Set<String>] = existingSymbol.availableLocalizations
        if var existingLocalizations = existingSymbol.availableLocalizations[scannedSymbol.availability] {
            if let localization = localization {
                existingLocalizations.insert(localization)
            }

            availableLocalizations[scannedSymbol.availability] = existingLocalizations
        } else {
            availableLocalizations[scannedSymbol.availability] = localization.map { [$0] } ?? []
        }

        // Manage names
        var nameVersions: [Availability: String] = existingSymbol.nameVersions
        nameVersions[scannedSymbol.availability] = nameWithoutSuffix

        // Remove old symbol & define new symbol
        symbols.remove(at: index)
        newSymbol = Symbol(
            name: primaryName,
            canOnlyReferTo: existingSymbol.canOnlyReferTo,
            preview: existingSymbol.preview ?? preview,
            nameVersions: nameVersions,
            availableLocalizations: availableLocalizations
        )
    } else {
        // The symbol doesn't exist yet
        newSymbol = Symbol(
            name: primaryName,
            canOnlyReferTo: asIsSymbols.first { $0.lhs == primaryName }?.rhs,
            preview: preview,
            nameVersions: [scannedSymbol.availability: nameWithoutSuffix],
            availableLocalizations: [scannedSymbol.availability: localization.map { [$0] } ?? []]
        )
    }

    symbols.append(newSymbol)
}

symbols = symbols.sorted { $0.name < $1.name }

// MARK: - Step 3: CODE GENERATION

// Generate a type for each enum case that shall be created
let symbolEnumCases: [SymbolEnumCase] = symbols.flatMap { symbol -> [SymbolEnumCase] in
    var symbolEnumCases: [SymbolEnumCase] = .init()

    // Generate an enum case for the latest name
    let primaryEnumCaseName = symbol.name.toEnumCaseName
    symbolEnumCases.append(
        SymbolEnumCase(
            caseName: primaryEnumCaseName,
            nameVersions: symbol.nameVersions,
            canOnlyReferTo: symbol.canOnlyReferTo,
            preview: symbol.preview,
            availableLocalizations: symbol.availableLocalizations,
            availability: symbol.nameVersions.keys.max()!,
            deprecation: nil
        )
    )

    // Sort name versions, so that the greatest (broadest) availability comes first, e. g. meaning 2019 availability is before 2020 availability (!)
    let sortedNameVersions = symbol.nameVersions.sorted { $0.0 > $1.0 }

    // Generate a (deprecated) enum case for each previous name to keep compatibility
    for (availability, name) in (sortedNameVersions.reversed().filter { $0.value != symbol.name }) {
        guard let deprecation = (sortedNameVersions.first { $0 < availability && $1 != name }?.key) else { fatalError() }
        symbolEnumCases.append(
            SymbolEnumCase(
                caseName: name.toEnumCaseName,
                nameVersions: symbol.nameVersions,
                canOnlyReferTo: symbol.canOnlyReferTo,
                preview: symbol.preview,
                availableLocalizations: symbol.availableLocalizations.filter { $0.key >= availability }, // Don't mention localizations of future versions
                availability: availability,
                deprecation: (availability: deprecation, renamedTo: primaryEnumCaseName)
            )
        )
    }

    return symbolEnumCases
}

let symbolsAsCode: [String] = symbolEnumCases.map { symbolEnumCase in
    // Generate preview docs
    var outputString = "\t/// " + (symbolEnumCase.preview ?? "No preview available.")

    // Generate localization docs based on the assumption that localizations don't get removed
    var handledLocalizations: Set<String> = .init()
    for (availability, localizations) in (symbolEnumCase.availableLocalizations.sorted { $0.0 > $1.0 }) {
        let newLocalizations = localizations.subtracting(handledLocalizations)
        if !newLocalizations.isEmpty {
            handledLocalizations.formUnion(newLocalizations)
            outputString += "\n\t/// From iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS) and watchOS \(availability.watchOS) on, the following localizations are available: \(Array(newLocalizations).sorted().joined(separator: ", "))"
        }
    }

    // Generate canOnlyReferTo docs
    if let canOnlyReferTo = symbolEnumCase.canOnlyReferTo {
        outputString += "\n\t/// ⚠️ This symbol can refer only to Apple's \(canOnlyReferTo)."
    }

    // Generate availability / deprecation specifications
    if let (deprecation, renamedTo) = symbolEnumCase.deprecation {
        outputString += "\n\t@available(iOS, introduced: \(symbolEnumCase.availability.iOS), deprecated: \(deprecation.iOS), renamed: \"\(renamedTo)\")"
        outputString += "\n\t@available(macOS, introduced: \(symbolEnumCase.availability.macOS), deprecated: \(deprecation.macOS), renamed: \"\(renamedTo)\")"
        outputString += "\n\t@available(tvOS, introduced: \(symbolEnumCase.availability.tvOS), deprecated: \(deprecation.tvOS), renamed: \"\(renamedTo)\")"
        outputString += "\n\t@available(watchOS, introduced: \(symbolEnumCase.availability.watchOS), deprecated: \(deprecation.watchOS), renamed: \"\(renamedTo)\")"
    } else {
        outputString += "\n\t@available(iOS \(symbolEnumCase.availability.iOS), macOS \(symbolEnumCase.availability.macOS), tvOS \(symbolEnumCase.availability.tvOS), watchOS \(symbolEnumCase.availability.watchOS), *)"
    }

    // Generate case
    outputString += "\n\tcase \(symbolEnumCase.caseName)"

    return outputString
}

// Retrieve all availabilities
var availabilities: Set<Availability> = .init()
symbols.forEach { availabilities.formUnion($0.nameVersions.keys) }

// Compute enum case name, enum raw value and enum case availability relationship
let symbolEnumRawValues = symbolEnumCases.flatMap { symbolEnumCase in
    symbolEnumCase.nameVersions.flatMap { nameVersion in
        availabilities
            .filter { availability in (availability == nameVersion.key) || (availability < nameVersion.key && !symbolEnumCase.nameVersions.contains { $0.key == availability } ) }
            .map {
            SymbolEnumRawValue(availability: $0, caseName: symbolEnumCase.caseName, name: nameVersion.value)
        }
    }
}

// Generate rawValue and caseIterable code
var rawValueString: String = "\tpublic var rawValue: String {\n\t\t"
var caseIterableString: String = "\tpublic static var allCases: [SFSymbol] {\n\t\t"

for availability in (availabilities.sorted { $0 < $1 }) {
    let ifClause = availability.iOS == "13.0" ? "" : "if #available(iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS), *) "
    rawValueString += "\(ifClause){\n\t\t\tswitch self {\n"
    caseIterableString += "\(ifClause){\n\t\t\treturn [\n"

    let items = symbolEnumRawValues.filter { $0.availability == availability }
    for item in items {
        rawValueString += "\t\t\tcase .\(item.caseName): return \"\(item.name)\"\n"
        caseIterableString += "\t\t\t\t.\(item.caseName),\n"
    }

    rawValueString += "\t\t\tdefault: fatalError() // While this triggers a compiler warning, without this, the compiler would fail\n"
    rawValueString += "\t\t\t}\n\t\t} else "
    caseIterableString = String(caseIterableString.dropLast(2))
    caseIterableString += "\n\t\t\t]\n\t\t} else "
}

rawValueString = String(rawValueString.dropLast(6))
rawValueString += "\n\t}"

caseIterableString = String(caseIterableString.dropLast(6))
caseIterableString += "\n\t}"

// Put output code together
var outputString = "// Don't touch this manually, this code is generated by the SymbolEnumCreator helper tool\n\n"
    + "@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)\npublic enum SFSymbol: String, CaseIterable {\n"
    + symbolsAsCode.joined(separator: "\n\n")
    + "\n\n\(rawValueString)\n\n\(caseIterableString)\n}"

// MARK: - Step 4: FINISHING

let pasteboard = NSPasteboard.general
pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
pasteboard.setString(outputString, forType: NSPasteboard.PasteboardType.string)

if !symbolsWherePreviewIsntAvailable.isEmpty {
    print("⚠️ No symbol preview available for symbols \(symbolsWherePreviewIsntAvailable)")
}

print("✅ DONE. Result copied to clipboard.")
