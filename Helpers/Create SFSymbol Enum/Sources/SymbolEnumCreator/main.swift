import AppKit
import Foundation

// Read from pasteboard
let pasteboard = NSPasteboard.general
guard let stringToParse = pasteboard.pasteboardItems?.first?.string(forType: .string) else {
    exit(1)
}

// Perform transformation
let icons = stringToParse.components(separatedBy: ", ").filter { !$0.isEmpty && $0 != "" }
let iconCaseNames = icons.map { ($0.toEnumCaseName, $0) }
let outputString = "public enum SFSymbol: String, CaseIterable {\n"
    + iconCaseNames.reduce("") { $0 + "    case \($1.0) = \"\($1.1)\"\n" }
    + "}"

// Write to pasteboard
pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
pasteboard.setString(outputString, forType: NSPasteboard.PasteboardType.string)
