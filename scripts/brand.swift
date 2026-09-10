import AppKit

let output = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
for (name, size) in [("logo", 512), ("icon", 128)] {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    let scale = CGFloat(size) / 512
    let transform = NSAffineTransform()
    transform.scale(by: scale)
    transform.concat()
    let background = NSBezierPath(roundedRect: NSRect(x: 12, y: 12, width: 488, height: 488),
                                 xRadius: 112, yRadius: 112)
    NSGradient(starting: NSColor(srgbRed: 0.10, green: 0.24, blue: 0.59, alpha: 1),
               ending: NSColor(srgbRed: 0.20, green: 0.57, blue: 0.98, alpha: 1))!
        .draw(in: background, angle: 65)
    let paper = NSBezierPath(roundedRect: NSRect(x: 135, y: 108, width: 240, height: 304),
                            xRadius: 30, yRadius: 30)
    NSColor.white.withAlphaComponent(0.96).setFill()
    paper.fill()
    NSColor(srgbRed: 0.70, green: 0.80, blue: 0.95, alpha: 1).setStroke()
    for y in [338, 295] {
        let line = NSBezierPath()
        line.move(to: NSPoint(x: 182, y: y))
        line.line(to: NSPoint(x: 294, y: y))
        line.lineWidth = 14
        line.lineCapStyle = .round
        line.stroke()
    }
    NSColor(srgbRed: 0.10, green: 0.50, blue: 0.91, alpha: 1).setStroke()
    let check = NSBezierPath()
    check.move(to: NSPoint(x: 185, y: 208))
    check.line(to: NSPoint(x: 229, y: 165))
    check.line(to: NSPoint(x: 323, y: 250))
    check.lineWidth = 26
    check.lineCapStyle = .round
    check.lineJoinStyle = .round
    check.stroke()
    NSGraphicsContext.restoreGraphicsState()
    try bitmap.representation(using: .png, properties: [:])!
        .write(to: output.appendingPathComponent(name + ".png"))
}
