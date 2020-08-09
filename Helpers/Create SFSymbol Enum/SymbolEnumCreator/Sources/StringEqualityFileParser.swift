import Foundation

typealias StringEqualityFile = [(lhs: String, rhs: String)]

struct StringEqualityFileParser {
    static func parse(stringEqualityFileContents: String?) -> StringEqualityFile? {
        guard
            let contents = stringEqualityFileContents,
            let regex = try? Regex("\"(.+)\" = \"(.+)\";")
        else {
            return nil
        }

        var stringEqualityFile: StringEqualityFile = []
        let components = contents.components(separatedBy: "\n").filter { !$0.starts(with: "//") && $0 != "" }
        for component in components {
            if let captures = regex.firstMatch(in: component)?.captures, captures.count == 2, let lhs = captures[0], let rhs = captures[1] {
                stringEqualityFile.append((lhs: lhs, rhs: rhs))
            } else {
                // Cancel on single failure
                return nil
            }
        }

        return stringEqualityFile
    }
}
