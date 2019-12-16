import AppKit
import Foundation

// Read from pasteboard
let pasteboard = NSPasteboard.general
guard let stringToParse = pasteboard.pasteboardItems?.first?.string(forType: .string) else {
    exit(1)
}

if stringToParse.contains(", ,") {
    fatalError("Some icons are still missing and must be manually added to the input by searching for \", ,\"")
}

// Perform transformation
let iconNamesAndIcons: [(String, String?)] = stringToParse.components(separatedBy: ", ")
    .filter { !$0.isEmpty && $0 != "" }
    .reduce ([]) { existing, new in
        if existing.isEmpty || existing.last?.1 != nil {
            return existing + [(new, nil)]
        } else {
            var last = existing.last!
            let existing = existing.dropLast()
            last.1 = new
            return existing + [last]
        }
    }

var iconCaseNamesIconNamesAndIcons = iconNamesAndIcons
    .map { ($0.0.toEnumCaseName, $0.0, $0.1!) }
    .sorted { $0.0 < $1.0 } // Sort alphabetically

let outputString = "@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)\npublic enum SFSymbol: String, CaseIterable {"
    + iconCaseNamesIconNamesAndIcons.reduce("") {
        let appleServiceString = asIsSymbols[$1.1].map { "    /// (Can only refer to Apple's \($0))\n"  } ?? ""
        return $0 + "\n    /// \($1.2)\n\(appleServiceString)    case \($1.0) = \"\($1.1)\"\n"
    }
    + "}"

// Write to pasteboard
pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
pasteboard.setString(outputString, forType: NSPasteboard.PasteboardType.string)
