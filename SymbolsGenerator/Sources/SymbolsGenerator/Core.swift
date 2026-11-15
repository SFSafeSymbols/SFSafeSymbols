import Foundation
import AppKit

class GeneratorCore {

    private let outputDir: URL
    private let imagesDir: URL
    private let mode: GenerationMode
    private var symbols: [Symbol] = []
    private var symbolsByName: [String: Symbol] = [:]
    private var versionsWithNoLayersetInfo: Set<String> = []
    static var imageDirectoryPath: String { "SymbolImages" }

    /// The spaces of one indentation level in the generated code.
    private static let indentationWidth = 4

    private static let baseAvailabilityAttribute = "@\(Availability.base.availableExpression)"
    private static let inlinableAttributes = ["@usableFromInline", "@_alwaysEmitIntoClient"]

    init(outputDir: URL, mode: GenerationMode) {
        self.outputDir = outputDir
        self.mode = mode
        self.imagesDir = outputDir.deletingLastPathComponent().appending(path: Self.imageDirectoryPath)
    }

    func run() async throws {
        // MARK: - Step 1: READ THE SYSTEM'S SF SYMBOLS DATA

        guard
            case let (allSymbols, availabilities)? = try SystemSymbols
                .read(file: "name_availability", withExtension: "plist")
                .parse(using: SymbolManifestParser.parse)
                else {
            fatalError("Error reading name_availability.plist")
        }

        let symbolRestrictions = try SystemSymbols
            .read(file: "symbol_restrictions", withExtension: "strings")
            .parse(using: StringDictionaryFileParser.parse)

        let symbolCategories = try PropertyListDecoder().decode(
            [String: [String]].self,
            from: SystemSymbols.read(file: "symbol_categories", withExtension: "plist")
        )

        // The SF Symbols app hides restricted devices with a badge or slash (e. g. `macpro.gen1.badge.checkmark`), which
        // are composite-only, but not other restricted composite-only symbols (e. g. `video.badge.questionmark`)
        let symbolManifest = allSymbols.filter {
            symbolRestrictions[$0.name] == nil
            || symbolCategories[$0.name]?.contains("devices") != true
            || !SystemSymbols.isCompositeOnly($0.name)
        }

        let scannedSymbolForName = Dictionary(symbolManifest.map { ($0.name, $0) }) { first, _ in first }

        // Renames whose old name was public. The others are names used internally before a symbol's release.
        let nameAliases = try SystemSymbols
            .read(file: "name_aliases", withExtension: "strings")
            .parse(using: StringDictionaryFileParser.parse)
            .map({ (oldName: $0.key, newName: $0.value) })
            .filter { scannedSymbolForName[$0.oldName] != nil }

        let availabilityForVersion = Dictionary(availabilities.map { ($0.version, $0) }) { first, _ in first }

        /// The layersets other than monochrome, with the release that introduced them.
        func layersetAvailabilities(of name: String) -> [Availability: Set<String>] {
            SystemSymbols.layersetVersions(of: name).reduce(into: [:]) { result, layerset in
                guard let availability = availabilityForVersion[layerset.value] else {
                    fatalError("SF Symbols \(layerset.value) (\(layerset.key) layerset of \(name)) has no release in name_availability.plist")
                }
                result[availability, default: []].insert(layerset.key)
            }
        }

        // MARK: - Step 2: MERGE INTO SINGLE DATABASE

        var symbolsWherePreviewIsntAvailable: [String] = []

        let newNameForOldName = Dictionary(nameAliases.map { ($0.oldName, $0.newName) }) { first, _ in first }
        let oldNamesForNewName = Dictionary(grouping: nameAliases, by: \.newName).mapValues { $0.map(\.oldName) }

        /// The symbol and all its other names, newest first.
        func allAliases(for symbolName: String) -> [ScannedSymbol] {
            var result = [symbolName]
            if let olderAliases = oldNamesForNewName[symbolName] {
                result += olderAliases
            } else if let newestAlias = newNameForOldName[symbolName] {
                result += (oldNamesForNewName[newestAlias] ?? []).filter { $0 != symbolName } + [newestAlias]
            }
            return result
                .compactMap { scannedSymbolForName[$0] }
                .sorted(using: KeyPathComparator(\.availability, order: .reverse))
        }

        // Merge all versions of the same symbol into one type.
        // This process takes care of merging multiple localized variants + renamed variants from previous versions

        var symbolIndexForName: [String: Int] = [:]

        for scannedSymbol in symbolManifest {
            let localization = Localization.allCases.first {
                scannedSymbol.name.hasSuffix(".\($0.rawValue)")
            }
            let nameWithoutSuffix = scannedSymbol.name.replacingOccurrences(
                of: (localization?.rawValue).flatMap { ".\($0)" } ?? "",
                with: ""
            )

            // Only lookup layerset availability for main name (without localization suffix)
            // Assuming it is equal across all localizations...
            let availableLayersets = layersetAvailabilities(of: nameWithoutSuffix)

            if let index = symbolIndexForName[nameWithoutSuffix] {
                // The symbol already exists -> Manage localizations
                let existingSymbol = symbols[index]
                var existingLocalizations = existingSymbol.availableLocalizations[scannedSymbol.availability] ?? []
                if let localization {
                    existingLocalizations.insert(localization)
                }
                if existingLocalizations.isNotEmpty {
                    symbols[index].availableLocalizations[scannedSymbol.availability] = existingLocalizations
                }
                symbols[index].availability = [existingSymbol.availability, scannedSymbol.availability].max()!
                symbols[index].isBaseLocalizationAvailable = existingSymbol.isBaseLocalizationAvailable || localization == nil
                symbols[index].availableLayersets = availableLayersets
                continue
            }

            // The symbol doesn't exist yet
            let otherAliases = allAliases(for: nameWithoutSuffix)
            let preview = otherAliases.lazy.compactMap { SystemSymbols.preview(of: $0.name) }.first
            if preview == nil {
                symbolsWherePreviewIsntAvailable.append(nameWithoutSuffix)
            }
            let primaryName = newNameForOldName[nameWithoutSuffix] ?? nameWithoutSuffix

            symbolIndexForName[nameWithoutSuffix] = symbols.count
            symbols.append(
                Symbol(
                    name: nameWithoutSuffix,
                    restriction: symbolRestrictions[primaryName],
                    preview: preview,
                    availability: scannedSymbol.availability,
                    isBaseLocalizationAvailable: localization == nil,
                    availableLocalizations: localization.map { [scannedSymbol.availability: [$0]] } ?? [:],
                    availableLayersets: availableLayersets,
                    olderSymbol: otherAliases.last { $0.availability > scannedSymbol.availability },
                    newerSymbol: otherAliases.first { $0.availability < scannedSymbol.availability }
                )
            )
        }

        // This is to fix a rare bug that only localized variants of a symbol, but not the base variant is available
        // (see https://github.com/SFSafeSymbols/SFSafeSymbols/issues/107)
        symbols = symbols.filter(\.isBaseLocalizationAvailable)
        symbolsByName = Dictionary(uniqueKeysWithValues: symbols.map { ($0.name, $0) })
        symbolsWherePreviewIsntAvailable = symbolsWherePreviewIsntAvailable.filter { symbolsByName[$0] != nil }

        // MARK: - Step 3: CODE GENERATION

        let groupedSymbols = Dictionary(grouping: symbols, by: \.availability)

        var localizationsGroupedByAvailability: [Availability: [Symbol: Set<Localization>]] = [:]
        for symbol in symbols {
            localizationsGroupedByAvailability[symbol.availability, default: [:]][symbol] = []
            for (availability, localizations) in symbol.availableLocalizations {
                localizationsGroupedByAvailability[availability, default: [:]][symbol, default: []].formUnion(localizations)
            }
        }

        var files: [String: String] = [:]
        for (availability, symbols) in groupedSymbols {
            files["SFSymbol+\(availability.version).swift"] = symbolsFile(availability, symbols)
        }
        for (availability, symbolLocalizations) in localizationsGroupedByAvailability {
            files["SFSymbol+AllSymbols+\(availability.version).swift"] = Self.catalogTablesFile(
                availability,
                symbolLocalizations,
                deprecatedSymbols: groupedSymbols[availability]!.compactMap(\.olderSymbol?.name).sorted()
            )
        }
        files["SymbolLocalizations.swift"] = localizationsFile(availabilities: Set(groupedSymbols.keys))
        files["SFSymbol+AllSymbols.swift"] = Self.catalogFile(
            availabilities: groupedSymbols.keys.sorted(using: ComparableComparator(order: .reverse)).dropFirst()
        )

        // MARK: - Step 4: OUTPUT

        for (fileName, contents) in files {
            try SFFileManager.write(contents, to: outputDir.appending(path: fileName))
        }

        print("Codes generated.")
        print("Generating symbol images...")

        try await withThrowingTaskGroup(of: Void.self) {[symbols, imagesDir] group in
            for symbol in symbols {
                group.addTask {
                    try await Self.symbolToPNG(symbol, imagesDir: imagesDir)
                }
            }
            try await group.waitForAll()
        }

        // MARK: - Step 5: FINISHING

        if symbolsWherePreviewIsntAvailable.isNotEmpty {
            printToStdErr(
                "⚠️ No symbol preview available for symbols \(symbolsWherePreviewIsntAvailable)"
            )
        }
    }

    // MARK: - Files

    /// `SFSymbol+<version>.swift`: the static getters of the symbols introduced in `availability`.
    private func symbolsFile(_ availability: Availability, _ symbols: [Symbol]) -> String {
        SwiftWriter.generatedFile(indentationWidth: Self.indentationWidth) { writer in
            writer.line("// \(availability.version) Symbols")
            writer.line("@\(availability.availableExpression)")
            writer.scope("public extension SFSymbol") { writer in
                writer.separated(symbols) { writer, symbol in
                    writeGetter(of: symbol, to: &writer)
                }
            }
        }
    }

    /// `SFSymbol+AllSymbols+<version>.swift`: the symbols and localizations introduced in `availability`, and the
    /// symbols it deprecates.
    private static func catalogTablesFile(
        _ availability: Availability,
        _ symbolLocalizations: [Symbol: Set<Localization>],
        deprecatedSymbols: [String]
    ) -> String {
        SwiftWriter.generatedFile(indentationWidth: Self.indentationWidth) { writer in
            writer.line("@\(availability.availableExpression)")
            writer.scope("extension SFSymbol") { writer in
                writer.lines(inlinableAttributes)
                writer.scope("internal static var localizationsAvailableSince\(availability.versionUnderscored): [SFSymbol : Set<Localization>]") { writer in
                    let entries = symbolLocalizations
                        .sorted(using: KeyPathComparator(\.key.name))
                        .map { symbol, localizations in
                            let localizationSet = localizations.map { "." + $0.variableName }.sorted().joined(separator: ", ")
                            return (rawValueExpression(symbol.name) + ": [" + localizationSet + "]", symbol.propertyName)
                        }
                    writer.scope(bracket: .square) { $0.lines(tableEntries(entries)) }
                }

                guard !availability.isBase else { return }
                writer.blankLine()
                writer.lines(inlinableAttributes)
                writer.scope("internal static var symbolsDeprecatedSince\(availability.versionUnderscored): Set<SFSymbol>") { writer in
                    let entries = deprecatedSymbols.map { (rawValueExpression($0), $0.toPropertyName) }
                    writer.scope(bracket: .square, inline: entries.isEmpty) { $0.lines(tableEntries(entries)) }
                }
            }
        }
    }

    /// `SymbolLocalizations.swift`: the `Localization` enum, and a struct for each localization and availability that
    /// symbols use.
    private func localizationsFile(availabilities: Set<Availability>) -> String {
        // Every localization exists in the base availability. Newer ones only where an older symbol gained them.
        var usedCombinations: [String: (Localization, Availability)] = [:]
        for localization in Localization.allCases {
            usedCombinations[localization.structName(for: Availability.base)] = (localization, Availability.base)
        }
        for symbol in symbols {
            for (availability, localizations) in symbol.availableLocalizations
                    where symbol.availability > availability && availabilities.contains(availability) {
                for localization in localizations {
                    usedCombinations[localization.structName(for: availability)] = (localization, availability)
                }
            }
        }

        return SwiftWriter.generatedFile(indentationWidth: Self.indentationWidth) { writer in
            writer.scope("public enum Localization: String, Equatable, Sendable") { writer in
                writer.lines(Localization.allCases.map { "case \($0.variableName) = \"\($0.rawValue)\"" })
            }
            writer.blankLine()
            writer.line("// MARK: - Static Localization")
            writer.blankLine()

            writer.separated(usedCombinations.sorted { $0.key < $1.key }) { writer, entry in
                let (structName, (localization, availability)) = entry
                let rawValue = "\\(source.rawValue).\\(Localization.\(localization.variableName).rawValue)"
                writer.line(Self.baseAvailabilityAttribute)
                writer.scope("public struct \(structName): SymbolLocalization") { writer in
                    writer.lines(["@usableFromInline", "let source: SFSymbol"])
                    writer.blankLine()
                    writer.lines(["@_alwaysEmitIntoClient", "public init(source: SFSymbol) { self.source = source }"])
                    writer.blankLine()
                    writer.lines([
                        "@\(availability.availableExpression)",
                        "@_alwaysEmitIntoClient",
                        "public var \(localization.variableName): SFSymbol { \(Self.rawValueExpression(rawValue)) }",
                    ])
                }
            }
        }
    }

    /// `SFSymbol+AllSymbols.swift`: `allSymbols` and `allLocalizations`, which merge the tables of every availability
    /// the OS supports.
    private static func catalogFile(availabilities: ArraySlice<Availability>) -> String {
        func cachedAccessor(_ declaration: [String], cache: String, builder: String, to writer: inout SwiftWriter) {
            writer.lines(declaration.dropLast())
            writer.scope(declaration.last!) { writer in
                writer.scope("\(cache).write", closureParameters: ["cached"]) { writer in
                    writer.lines([
                        "if let cached { return cached }",
                        "let result = \(builder)",
                        "cached = result",
                        "return result",
                    ])
                }
            }
        }

        /// A getter that starts from `initialValue`, then updates it for each availability the OS supports.
        func availabilityDependentGetter(
            _ declaration: String,
            initialValue: String,
            update: (Availability) -> String,
            to writer: inout SwiftWriter
        ) {
            writer.lines(inlinableAttributes)
            writer.scope(declaration) { writer in
                writer.line("var result = \(initialValue)")
                for availability in availabilities {
                    writer.scope("if #\(availability.availableExpressionWithoutRedundancyToBase)") { writer in
                        writer.line(update(availability))
                    }
                }
                writer.line("return result")
            }
        }

        return SwiftWriter.generatedFile(indentationWidth: Self.indentationWidth) { writer in
            writer.line(baseAvailabilityAttribute)
            writer.scope("extension SFSymbol") { writer in
                // `allCases` has been deprecated with the v3 release (spring of 2022)
                // It shall be removed entirely ~2 years after the v3 release
                writer.lines([
                    "@available(*, deprecated, renamed: \"allSymbols\")",
                    "@_alwaysEmitIntoClient",
                    "public static var allCases: [SFSymbol] { Array(allSymbols) }",
                ])
                writer.blankLine()

                cachedAccessor(
                    [
                        "/// All symbols available on the current platform and OS version, excluding deprecated ones.",
                        "///",
                        "/// - Important: Referencing this property links the full symbol catalog (about 1 MB) into your module.",
                        "///   Apps that only use static symbols such as `.star` don't pay that cost.",
                        "@_alwaysEmitIntoClient",
                        "public static var allSymbols: Set<SFSymbol>",
                    ],
                    cache: "_allSymbolsCache", builder: "_buildAllSymbols", to: &writer
                )
                writer.blankLine()
                cachedAccessor(
                    inlinableAttributes + ["internal static var allLocalizations: [SFSymbol : Set<Localization>]"],
                    cache: "_allLocalizationsCache", builder: "_buildAllLocalizations", to: &writer
                )
                writer.blankLine()

                writer.lines(["@usableFromInline", "internal static let _allSymbolsCache = LockWrapper<Set<SFSymbol>?>(nil)"])
                writer.blankLine()
                writer.lines(["@usableFromInline", "internal static let _allLocalizationsCache = LockWrapper<[SFSymbol : Set<Localization>]?>(nil)"])
                writer.blankLine()

                availabilityDependentGetter(
                    "internal static var _buildAllLocalizations: [SFSymbol : Set<Localization>]",
                    initialValue: "localizationsAvailableSince\(Availability.base.versionUnderscored)",
                    update: { "result.merge(localizationsAvailableSince\($0.versionUnderscored)) { $0.union($1) }" },
                    to: &writer
                )
                writer.blankLine()
                availabilityDependentGetter(
                    "internal static var _buildAllSymbols: Set<SFSymbol>",
                    initialValue: "Set(allLocalizations.keys)",
                    update: { "result.subtract(symbolsDeprecatedSince\($0.versionUnderscored))" },
                    to: &writer
                )
            }
        }
    }

    // MARK: - Symbol getters

    private func writeGetter(of symbol: Symbol, to writer: inout SwiftWriter) {
        writer.lines(documentation(of: symbol).map { $0.isEmpty ? "///" : "/// \($0)" })

        // Generate availability / deprecation specifications
        if let newerSymbol = symbol.newerSymbol {
            let newerName = newerSymbol.name.toPropertyName
            for (platform, version) in Availability.platformVersions {
                let introduced = symbol.availability[keyPath: version]
                let deprecated = newerSymbol.availability[keyPath: version]
                writer.line("@available(\(platform), introduced: \(introduced), deprecated: \(deprecated), renamed: \"\(newerName)\")")
            }
        }

        // Generate symbol
        let localizationStructNames = symbol.availableLocalizations.flatMap { availability, localizations in
            localizations.map {
                symbol.availability == availability ? $0.baseStructName : $0.structName(for: availability)
            }
        }.sorted()
        let type = switch localizationStructNames.count {
            case 0: "SFSymbol"
            case 1: "SymbolWith1Localization<\(localizationStructNames[0])>"
            default: "SymbolWith\(localizationStructNames.count)Localizations<\(localizationStructNames.joined(separator: ", "))>"
        }

        writer.line("@_alwaysEmitIntoClient")
        writer.line("static var \(symbol.propertyName): \(type) { \(Self.rawValueExpression(symbol.name)) }")
    }

    /// The doc comment lines of a symbol's getter, without the `/// ` prefix: preview, image, summary, localizations,
    /// layersets and use restriction.
    private func documentation(of symbol: Symbol) -> [String] {
        let completeLayersets = layersetsOfAllVersions(of: symbol)
        let hasLayersetInfo = !versionsWithNoLayersetInfo.contains(symbol.availability.version)
        let localizationCount = symbol.availableLocalizations.values.joined().count + 1
        let layersetCount = completeLayersets.values.joined().count + 1

        // The image's alt text is the preview glyph: autocomplete shows alt text instead of images, while Quick Help
        // shows the image, and can't render the glyph anyway (its fonts don't contain SF Symbols)
        let imageURL = makeImageURL(for: symbol)
        var lines = ["![\(symbol.preview ?? "No preview available")](\(imageURL?.absoluteString ?? ""))"]
        if imageURL != nil {
            // A hard line break (trailing `\`) keeps the summary in the first paragraph, which autocomplete shows,
            // while giving it more room below the image in Quick Help
            lines[0] += "\\"
        }

        let summary = [
            localizationCount > 1 ? "\(localizationCount) Localizations" : "Single Localization",
            hasLayersetInfo ? (layersetCount > 1 ? "\(layersetCount) Layersets" : "Single Layerset") : nil,
            symbol.restriction != nil ? "⚠️ Restricted" : nil
        ].compactMap { $0 }.joined(separator: ", ")
        if summary.isNotEmpty {
            lines.append(summary)
        }

        // Omit localization block if only the Latin localization is available
        if symbol.availableLocalizations.isNotEmpty {
            // Use "Left-to-Right" name for the standard localization if "Right-To-Left" is the only other localization
            let isRightToLeft = symbol.availableLocalizations.values.joined().contains(.rtl)
            lines += ["", "Localizations:", "- \(isRightToLeft ? "Left-to-Right" : "Latin")"]
            lines += Self.introductionList(symbol.availableLocalizations, of: symbol) {
                $0.sorted(using: KeyPathComparator(\.title)).map(\.title)
            }
        }

        if hasLayersetInfo {
            // Generate layerset availability docs based on the assumption that layersets don't get removed
            lines += ["", "Layersets:", "- Monochrome"]
            lines += Self.introductionList(completeLayersets, of: symbol) { $0.sorted().map(Self.layersetTitle) }
        } else {
            lines += ["", "Layerset information unavailable"]
        }

        // Generate use restriction docs
        if let restrictionMessage = symbol.restriction {
            lines += ["", "- Warning: ⚠️ \(restrictionMessage)"]
        }

        return lines
    }

    /// A `- <title>` line for each item, in the order the availabilities introduced them. Items that came after the
    /// symbol itself mention the availability that introduced them.
    private static func introductionList<Item>(
        _ itemsByAvailability: [Availability: Set<Item>],
        of symbol: Symbol,
        titles: (Set<Item>) -> [String]
    ) -> [String] {
        var handledItems: Set<Item> = []
        var lines: [String] = []
        for (availability, items) in itemsByAvailability.sorted(using: KeyPathComparator(\.key, order: .reverse)) {
            let newItems = items.subtracting(handledItems)
            guard newItems.isNotEmpty else { continue }
            handledItems.formUnion(newItems)
            let notice = availability < symbol.availability
            ? " (iOS \(availability.iOS), macOS \(availability.macOS), tvOS \(availability.tvOS), watchOS \(availability.watchOS))"
            : ""
            lines += titles(newItems).map { "- \($0)\(notice)" }
        }
        return lines
    }

    /// The documented name of a layerset. Palette rendering uses the hierarchical layerset (the SF Symbols app shows
    /// the hierarchical availability for both), so they're documented, and counted, as one.
    private static func layersetTitle(_ layerset: String) -> String {
        layerset == "hierarchical" ? "Hierarchical/Palette" : layerset.capitalized
    }

    private func layersetsOfAllVersions(of symbol: Symbol) -> [Availability: Set<String>] {
        guard let otherVersion = symbol.newerSymbol ?? symbol.olderSymbol else {
            return symbol.availableLayersets
        }
        return symbol.availableLayersets.merging(symbolsByName[otherVersion.name]!.availableLayersets) { $0.union($1) }
    }

    private func makeImageURL(for symbol: Symbol) -> URL? {
        guard Self.symbolToNSImage(symbol) != nil else { return nil }

        func make(_ user: String, _ ref: String) -> URL {
            let dir = Self.imageDirectoryPath
            let ext = Self.exportImageExtension
            let imageURL = "https://raw.githubusercontent.com/\(user)/SFSafeSymbols/refs/\(ref)/Sources/SFSafeSymbols/\(dir)/\(symbol.name).\(ext)"
            return URL(string: imageURL)!
        }

        switch mode {
            case .dev:
                return make("SFSafeSymbols", "heads/stable")
            case .pr(let username, let branch):
                return make(username, "heads/\(branch)")
            case .release(let tag):
                return make("SFSafeSymbols", "tags/\(tag)")
        }
    }

    /// Table lines, each followed by a comment that points to the symbol's getter.
    private static func tableEntries(_ entries: [(code: String, propertyName: String)]) -> [String] {
        entries.enumerated().map { index, entry in
            let separator = index == entries.count - 1 ? "" : ","
            return entry.code + separator + " // SFSymbol." + entry.propertyName
        }
    }

    /// The expression that creates a symbol from its raw value. The symbol and localization getters use it, and so do
    /// the generated tables, where referencing deprecated symbols by name would cause deprecation warnings.
    private static func rawValueExpression(_ rawValue: String) -> String {
        ".init(\"\(rawValue)\")"
    }

    // MARK: - Images

    private static func symbolToNSImage(_ symbol: Symbol) -> NSImage? {
        let configuration = NSImage.SymbolConfiguration(
            pointSize: 35,
            weight: .black
        )
        return NSImage(
            systemSymbolName: symbol.name,
            accessibilityDescription: nil
        )?.withSymbolConfiguration(configuration)
    }

    private static func symbolToPNG(_ symbol: Symbol, imagesDir: URL) async throws {
        guard let nsImage = symbolToNSImage(symbol),
              let imageData = nsImage.exportSymbol() else {
            print("Cannot export SFSymbol(\(symbol.name)) to PNG file")
            return
        }

        let url = imagesDir.appending(path: "\(symbol.name).\(Self.exportImageExtension)")
        try SFFileManager.write(imageData, to: url)
    }
}
