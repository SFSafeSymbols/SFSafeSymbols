//
//  ExportPNG.swift
//  SymbolsGenerator
//
//  Created by Phineas Guo on 2025/12/4.
//

import Foundation
import AppKit


extension NSImage{
    func exportSymbol(symbolName:String) -> Data? {
        guard let tiffData = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:])
        else {
            print("Cannot export SFSymbol(\(symbolName)) data")
            return nil
        }
        return pngData
    }
}
