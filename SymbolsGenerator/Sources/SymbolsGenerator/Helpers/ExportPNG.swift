import Foundation
import AppKit
import UniformTypeIdentifiers
import WebP

extension GeneratorCore {
    static var exportImageExtension: String {
        let type = UTType.webP
        return type.preferredFilenameExtension!
    }
}

extension NSImage {
    func exportSymbol(scale: CGFloat = 1) -> Data? {
        let size = self.size
        let pixelWidth = Int((size.width * scale).rounded(.up))
        let pixelHeight = Int((size.height * scale).rounded(.up))

        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(
                  data: nil,
                  width: pixelWidth,
                  height: pixelHeight,
                  bitsPerComponent: 8,
                  bytesPerRow: 0,
                  space: colorSpace,
                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              )
        else {
            return nil
        }

        context.scaleBy(x: scale, y: scale)

        let imageRect = CGRect(origin: .zero, size: size)

        let previousContext = NSGraphicsContext.current
        NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
        NSAppearance(named: .aqua)?.performAsCurrentDrawingAppearance {
            self.draw(in: imageRect)
        }
        NSGraphicsContext.current = previousContext

        // A mid gray that reads about equally well on Quick Help's light and dark backgrounds
        context.setBlendMode(.sourceIn)
        context.setFillColor(CGColor(srgbRed: 0x9A / 255, green: 0x9A / 255, blue: 0x9F / 255, alpha: 1))
        context.fill(imageRect)

        guard let cgImage = context.makeImage() else {
            return nil
        }

        guard let config = try? WebPEncoderConfig.losslessPreset(level: 9) else {
            return nil
        }
        return try? WebPEncoder().encode(normalizing: cgImage, config: config)
    }
}
