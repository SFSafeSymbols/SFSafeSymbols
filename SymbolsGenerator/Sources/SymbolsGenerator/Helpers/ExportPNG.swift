//
//  ExportPNG.swift
//  SymbolsGenerator
//
//  Created by Phineas Guo on 2025/12/4.
//

import Foundation
import AppKit


extension NSImage{
    func exportSymbol() -> Data? {
        let size = self.size
            let dim = max(size.width, size.height)
            let squareRect = CGRect(origin: .zero, size: .init(width: dim, height: dim))
            guard let context = CGContext(
                data: nil,
                width: Int(dim),
                height: Int(dim),
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
            ) else {
                return nil
            }
            
            context.setFillColor(.white)
            context.fill(squareRect)
            var imageRect = CGRect(
                x: (dim - size.width) / 2,
                y: (dim - size.height) / 2,
                width: size.width,
                height: size.height
            )
            guard let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
                return nil
            }
            context.draw(cgImage, in: imageRect)
            guard let opaqueCGImage = context.makeImage() else {
                return nil
            }
            let opaqueBitmap = NSBitmapImageRep(cgImage: opaqueCGImage)
        
            return opaqueBitmap.representation(using: .png, properties: [:])
    }
}
