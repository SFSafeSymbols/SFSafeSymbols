import Foundation

private let fm = FileManager.default

func stringifyResources() throws {
    let rootDir = URL(fileURLWithPath: fm.currentDirectoryPath)
    let resDir = rootDir.appending(path: "Sources/SymbolsGenerator/Resources")
    guard let fileList = fm.enumerator(at: resDir, includingPropertiesForKeys: [.isRegularFileKey]) else { return }
    for case let fileURL as URL in fileList {
        if fileURL.pathExtension == "plist"  {
            try convertBinaryPlist(inPlace: fileURL)
        } else if fileURL.pathExtension == "strings"  {
           try convertBinaryStrings(inPlace: fileURL)
        }
    }
}

private func convertBinaryStrings(inPlace url: URL) throws {
    guard isBinary(url) else {
        return
    }
    let data = try Data(contentsOf: url)
    if (data.isEmpty) { return }
    let plistDict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String: String]
    let out = plistDict.sorted(using: KeyPathComparator(\.key)).reduce(into: "") { (res, element) in
        res += "\"\(element.key)\" = \"\(element.value)\";\n"
    }
    let outData = out.data(using: .utf8)!
    let tmp = url.deletingLastPathComponent().appending(path: "\(UUID().uuidString).strings")
    try outData.write(to: tmp, options: .atomic)
    _ = try fm.replaceItemAt(url, withItemAt: tmp)
}

private func convertBinaryPlist(inPlace url: URL) throws {
    guard isBinary(url) else {
        return
    }
    let data = try Data(contentsOf: url)
    let plistDict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
    let xmlData = try PropertyListSerialization.data(fromPropertyList: plistDict, format: .xml, options: 0)

    let tmp = url.deletingLastPathComponent().appending(path: "\(UUID().uuidString).plist")
    try xmlData.write(to: tmp, options: .atomic)
    _ = try fm.replaceItemAt(url, withItemAt: tmp)
}

private func isBinary(_ url: URL) -> Bool {
    // If it can decode as UTF-8 text, treat as text; otherwise call it binary.
    guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else { return true }
    return String(data: data, encoding: .utf8) == nil
}
