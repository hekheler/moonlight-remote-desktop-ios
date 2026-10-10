import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
// Draws the Hecate app icon: the triple moon, waxing crescent, full moon and
// waning crescent, on deep purple. Full bleed, because iOS rounds the corners.
//   swift Artwork/make-icon.swift Limelight/Images.xcassets/AppIcon.appiconset/AppIcon.png
// Shapes are in symbol units, scaled 6.37 about the centre.
let px = 1024, s: CGFloat = 6.37, c: CGFloat = 512, r: CGFloat = 26
let ctx = CGContext(data: nil, width: px, height: px, bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
func rgb(_ h: Int) -> CGColor { CGColor(srgbRed: CGFloat(h >> 16 & 255) / 255, green: CGFloat(h >> 8 & 255) / 255, blue: CGFloat(h & 255) / 255, alpha: 1) }
func circle(_ x: CGFloat) -> CGRect { CGRect(x: c + (x - r) * s, y: c - r * s, width: 2 * r * s, height: 2 * r * s) }
ctx.setFillColor(rgb(0x1b1033)); ctx.fill(CGRect(x: 0, y: 0, width: px, height: px))
ctx.setFillColor(rgb(0xefe6ff))
ctx.fillEllipse(in: circle(0))
// Each crescent is a disc with an offset disc cut out, horns pointing outward
for (disc, cut) in [(CGFloat(-56), CGFloat(-70)), (56, 70)] {
    ctx.saveGState()
    let p = CGMutablePath(); p.addRect(CGRect(x: 0, y: 0, width: px, height: px)); p.addEllipse(in: circle(cut))
    ctx.addPath(p); ctx.clip(using: .evenOdd)
    ctx.fillEllipse(in: circle(disc))
    ctx.restoreGState()
}
let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: CommandLine.arguments[1]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil); CGImageDestinationFinalize(dest)
