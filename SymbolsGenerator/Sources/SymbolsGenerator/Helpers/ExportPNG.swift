import Foundation
import AppKit
import ImageIO
import UniformTypeIdentifiers

extension GeneratorCore {
    static var exportImageExtension: String {
        let type = UTType.png
        return type.preferredFilenameExtension!
    }
}

extension NSImage {
    func exportSymbol(scale: CGFloat = 1) -> Data? {
        let size = self.size
        let dim = max(size.width, size.height)
        let pixelDim = Int((dim * scale).rounded(.up))

        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(
                  data: nil,
                  width: pixelDim,
                  height: pixelDim,
                  bitsPerComponent: 8,
                  bytesPerRow: 0,
                  space: colorSpace,
                  bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
              )
        else {
            return nil
        }

        context.setFillColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: pixelDim, height: pixelDim))
        context.scaleBy(x: scale, y: scale)

        let canvasDim = CGFloat(pixelDim) / scale
        let imageRect = CGRect(
            x: ((canvasDim - size.width) / 2 * scale).rounded(.down) / scale,
            y: ((canvasDim - size.height) / 2 * scale).rounded(.down) / scale,
            width: size.width,
            height: size.height
        )

        let previousContext = NSGraphicsContext.current
        NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
        NSAppearance(named: .aqua)?.performAsCurrentDrawingAppearance {
            self.draw(in: imageRect)
        }
        NSGraphicsContext.current = previousContext

        guard let cgImage = context.makeImage() else {
            return nil
        }

        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(
            data,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else {
            return nil
        }
        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else {
            return nil
        }
        return data as Data
    }
}
