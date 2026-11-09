import AppKit

// Original, reproducible vector artwork; no third-party images or fonts.
let image = NSImage(size: NSSize(width: 512, height: 512))
image.lockFocus()
let background = NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: 512, height: 512), xRadius: 112, yRadius: 112)
NSGradient(starting: NSColor(calibratedRed: 0.15, green: 0.12, blue: 0.31, alpha: 1),
           ending: NSColor(calibratedRed: 0.06, green: 0.06, blue: 0.12, alpha: 1))!.draw(in: background, angle: -45)
let cone = NSBezierPath()
cone.move(to: NSPoint(x: 102, y: 93))
cone.line(to: NSPoint(x: 175, y: 285))
cone.line(to: NSPoint(x: 287, y: 173))
cone.close()
NSColor(calibratedRed: 1, green: 0.72, blue: 0.25, alpha: 1).setFill()
cone.fill()
let colors: [NSColor] = [.systemPink, .systemCyan, .systemYellow, .systemGreen]
let pieces: [(CGFloat, CGFloat, CGFloat)] = [
    (225, 344, -25), (316, 393, 30), (375, 302, -15), (333, 231, 40),
    (157, 384, 15), (405, 404, -35), (263, 257, 28), (411, 203, 12)
]
for (index, piece) in pieces.enumerated() {
    NSGraphicsContext.saveGraphicsState()
    let transform = NSAffineTransform()
    transform.translateX(by: piece.0, yBy: piece.1)
    transform.rotate(byDegrees: piece.2)
    transform.concat()
    colors[index % colors.count].setFill()
    NSBezierPath(roundedRect: NSRect(x: -12, y: -23, width: 24, height: 46), xRadius: 5, yRadius: 5).fill()
    NSGraphicsContext.restoreGraphicsState()
}
image.unlockFocus()
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 512, pixelsHigh: 512,
                             bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
                             isPlanar: false, colorSpaceName: .deviceRGB,
                             bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
image.draw(in: NSRect(x: 0, y: 0, width: 512, height: 512))
NSGraphicsContext.restoreGraphicsState()
try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "assets/icon.png"))
