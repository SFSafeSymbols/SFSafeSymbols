import Foundation

extension String {
    var toEnumCaseName: String {
        var outputString = ""
        var shouldCapitalizeNextChar = false
        for char in self {
            if char == "." {
                shouldCapitalizeNextChar = true
            } else {
                if shouldCapitalizeNextChar {
                    outputString += char.uppercased()
                } else {
                    outputString += char.lowercased()
                }

                shouldCapitalizeNextChar = false
            }
        }

        return outputString
    }
}
