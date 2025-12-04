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
        let size = self.size
        let rect = CGRect(origin: .zero, size: size)
        
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        ) else {
            return nil
        }
        
        context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
        context.fill(rect)
        
        var imageRect = rect
        if let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) {
            context.draw(cgImage, in: rect)
        }
        
        guard let opaqueCGImage = context.makeImage() else {
            return nil
        }
        
        let opaqueBitmap = NSBitmapImageRep(cgImage: opaqueCGImage)
        return opaqueBitmap.representation(using: .png, properties: [:])
    }
}
