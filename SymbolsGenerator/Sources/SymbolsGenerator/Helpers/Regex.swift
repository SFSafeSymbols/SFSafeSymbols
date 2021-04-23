// Taken from https://github.com/Flinesoft/HandySwift/blob/main/Sources/HandySwift/Structs/Regex.swift (MIT License)

import Foundation

/// `Regex` is a swifty regex engine built on top of the NSRegularExpression api.
public struct Regex {
    // MARK: - Properties
    @usableFromInline internal let regularExpression: NSRegularExpression

    // MARK: - Initializers
    /// Create a `Regex` based on a pattern string.
    ///
    /// If `pattern` is not a valid regular expression, an error is thrown
    /// describing the failure.
    ///
    /// - parameters:
    ///     - pattern: A pattern string describing the regex.
    ///     - options: Configure regular expression matching options.
    ///       For details, see `Regex.Options`.
    ///
    /// - throws: A value of `ErrorType` describing the invalid regular expression.
    public init(_ pattern: String, options: Options = []) throws {
        regularExpression = try NSRegularExpression(
            pattern: pattern,
            options: options.toNSRegularExpressionOptions
        )
    }

    // MARK: - Methods: Matching
    /// Returns `true` if the regex matches `string`, otherwise returns `false`.
    ///
    /// - parameter string: The string to test.
    ///
    /// - returns: `true` if the regular expression matches, otherwise `false`.
    @inlinable
    public func matches(_ string: String) -> Bool {
        firstMatch(in: string) != nil
    }

    /// If the regex matches `string`, returns a `Match` describing the
    /// first matched string and any captures. If there are no matches, returns
    /// `nil`.
    ///
    /// - parameter string: The string to match against.
    ///
    /// - returns: An optional `Match` describing the first match, or `nil`.
    @inlinable
    public func firstMatch(in string: String) -> Match? {
        let firstMatch = regularExpression
            .firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
            .map { Match(result: $0, in: string) }
        return firstMatch
    }

    /// If the regex matches `string`, returns an array of `Match`, describing
    /// every match inside `string`. If there are no matches, returns an empty
    /// array.
    ///
    /// - parameter string: The string to match against.
    ///
    /// - returns: An array of `Match` describing every match in `string`.
    @inlinable
    public func matches(in string: String) -> [Match] {
        let matches = regularExpression
            .matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
            .map { Match(result: $0, in: string) }
        return matches
    }

    // MARK: Replacing
    /// Returns a new string where each substring matched by `regex` is replaced
    /// with `template`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - parameters:
    ///     - regex: A regular expression to match against `self`.
    ///     - template: A template string used to replace matches.
    ///     - count: The maximum count of matches to replace, beginning with the first match.
    ///
    /// - returns: A string with all matches of `regex` replaced by `template`.
    @inlinable
    public func replacingMatches(in input: String, with template: String, count: Int? = nil) -> String {
        var output = input
        let matches = self.matches(in: input)
        let rangedMatches = Array(matches[0 ..< min(matches.count, count ?? .max)])
        for match in rangedMatches.reversed() {
            let replacement = match.string(applyingTemplate: template)
            output.replaceSubrange(match.range, with: replacement)
        }

        return output
    }
}

// MARK: - CustomStringConvertible
extension Regex: CustomStringConvertible {
    /// Returns a string describing the regex using its pattern string.
    public var description: String {
        "Regex<\"\(regularExpression.pattern)\">"
    }
}

// MARK: - Equatable
extension Regex: Equatable {
    /// Determines the equality of to `Regex`` instances.
    /// Two `Regex` are considered equal, if both the pattern string and the options
    /// passed on initialization are equal.
    public static func == (lhs: Regex, rhs: Regex) -> Bool {
        lhs.regularExpression.pattern == rhs.regularExpression.pattern &&
        lhs.regularExpression.options == rhs.regularExpression.options
    }
}

// MARK: - Hashable
extension Regex: Hashable {
    /// Manages hashing of the `Regex` instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(regularExpression)
    }
}

// MARK: - Options
extension Regex {
    /// `Options` defines alternate behaviours of regular expressions when matching.
    public struct Options: OptionSet {
        // MARK: - Properties
        /// Ignores the case of letters when matching.
        public static let ignoreCase = Options(rawValue: 1)

        /// Ignore any metacharacters in the pattern, treating every character as
        /// a literal.
        public static let ignoreMetacharacters = Options(rawValue: 1 << 1)

        /// By default, "^" matches the beginning of the string and "$" matches the
        /// end of the string, ignoring any newlines. With this option, "^" will
        /// the beginning of each line, and "$" will match the end of each line.
        public static let anchorsMatchLines = Options(rawValue: 1 << 2)

        /// Usually, "." matches all characters except newlines (\n). Using this,
        /// options will allow "." to match newLines
        public static let dotMatchesLineSeparators = Options(rawValue: 1 << 3)

        /// The raw value of the `OptionSet`
        public let rawValue: Int

        /// Transform an instance of `Regex.Options` into the equivalent `NSRegularExpression.Options`.
        ///
        /// - returns: The equivalent `NSRegularExpression.Options`.
        var toNSRegularExpressionOptions: NSRegularExpression.Options {
            var options = NSRegularExpression.Options()
            if contains(.ignoreCase) { options.insert(.caseInsensitive) }
            if contains(.ignoreMetacharacters) { options.insert(.ignoreMetacharacters) }
            if contains(.anchorsMatchLines) { options.insert(.anchorsMatchLines) }
            if contains(.dotMatchesLineSeparators) { options.insert(.dotMatchesLineSeparators) }
            return options
        }

        // MARK: - Initializers
        /// The raw value init for the `OptionSet`
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Match
extension Regex {
    /// A `Match` encapsulates the result of a single match in a string,
    /// providing access to the matched string, as well as any capture groups within
    /// that string.
    public class Match: CustomStringConvertible {
        // MARK: Properties
        /// The entire matched string.
        public lazy var string: String = {
            String(describing: self.baseString[self.range])
        }()

        /// The range of the matched string.
        public lazy var range: Range<String.Index> = {
            Range(self.result.range, in: self.baseString)!
        }()

        /// The matching string for each capture group in the regular expression
        /// (if any).
        ///
        /// **Note:** Usually if the match was successful, the captures will by
        /// definition be non-nil. However if a given capture group is optional, the
        /// captured string may also be nil, depending on the particular string that
        /// is being matched against.
        ///
        /// Example:
        ///
        ///     let regex = Regex("(a)?(b)")
        ///
        ///     regex.matches(in: "ab")first?.captures // [Optional("a"), Optional("b")]
        ///     regex.matches(in: "b").first?.captures // [nil, Optional("b")]
        public lazy var captures: [String?] = {
            let captureRanges = stride(from: 0, to: result.numberOfRanges, by: 1)
                .map(result.range)
                .dropFirst()
                .map { [unowned self] in
                    Range($0, in: self.baseString)
                }

            return captureRanges.map { [unowned self] captureRange in
                guard let captureRange = captureRange else { return nil }
                return String(describing: self.baseString[captureRange])
            }
        }()

        private let result: NSTextCheckingResult

        private let baseString: String

        // MARK: - Initializers
        @usableFromInline
        internal init(result: NSTextCheckingResult, in string: String) {
            precondition(
                result.regularExpression != nil,
                "NSTextCheckingResult must originate from regular expression parsing."
            )

            self.result = result
            self.baseString = string
        }

        // MARK: - Methods
        /// Returns a new string where the matched string is replaced according to the `template`.
        ///
        /// The template string may be a literal string, or include template variables:
        /// the variable `$0` will be replaced with the entire matched substring, `$1`
        /// with the first capture group, etc.
        ///
        /// For example, to include the literal string "$1" in the replacement string,
        /// you must escape the "$": `\$1`.
        ///
        /// - parameters:
        ///     - template: The template string used to replace matches.
        ///
        /// - returns: A string with `template` applied to the matched string.
        public func string(applyingTemplate template: String) -> String {
            let replacement = result.regularExpression!.replacementString(
                for: result,
                in: baseString,
                offset: 0,
                template: template
            )

            return replacement
        }

        // MARK: - CustomStringConvertible
        /// Returns a string describing the match.
        public var description: String {
            "Match<\"\(string)\">"
        }
    }
}
