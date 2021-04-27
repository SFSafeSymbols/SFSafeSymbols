//
//  SFSymbol.swift
//  SFSafeSymbols
//
//  Created by Steven on 4/23/21.
//

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SFSymbol: Equatable, Hashable {
    public let rawValue: String

    internal init(systemName: String) {
        self.rawValue = systemName
    }

    public init(customName: String) {
        self.rawValue = customName
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension SFSymbol {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(customName: value)
    }

    func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}

