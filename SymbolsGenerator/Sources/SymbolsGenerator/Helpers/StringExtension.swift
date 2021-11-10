import Foundation

extension String {
    var toPropertyName: String {
        // Handle special swift keywords
        guard self != "return" else { return "`return`" }
        guard self != "repeat" else { return "`repeat`" }
        guard self != "case" else { return "`case`" }

        // Perform naming style transformation
        var outputString = ""
        var shouldCapitalizeNextChar = false

        // Avoid non-compiling leading numbers by prefixing with _
        if first?.isNumber == true {
            outputString += "_"
        }

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
