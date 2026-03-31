import Foundation
import AppKit
import UniformTypeIdentifiers

extension GeneratorCore {
    static var exportImageExtension: String {
        let type = UTType.png
        return type.preferredFilenameExtension!
    }
}

extension NSImage {
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

        var cgImage: CGImage?
        NSAppearance(named: .aqua)?.performAsCurrentDrawingAppearance {
            cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
        }
        guard let cgImage else { return nil }

        context.draw(cgImage, in: imageRect)
        guard let opaqueCGImage = context.makeImage() else {
            return nil
        }
        let opaqueBitmap = NSBitmapImageRep(cgImage: opaqueCGImage)

        return opaqueBitmap.representation(using: .png, properties: [:])
    }
}
