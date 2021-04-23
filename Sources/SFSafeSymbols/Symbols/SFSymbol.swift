//
//  SFSymbol.swift
//  SFSafeSymbols
//
//  Created by Steven on 4/23/21.
//

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SFSymbol: RawRepresentable, Equatable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
