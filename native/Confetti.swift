import AppKit
import QuartzCore

/// A short, click-through celebration. No Dock icon, keyboard capture or background service.
@MainActor
final class ConfettiApp: NSObject, NSApplicationDelegate {
    private var windows: [NSWindow] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        for screen in NSScreen.screens {
            let window = NSPanel(
                contentRect: screen.frame,
                styleMask: [.borderless, .nonactivatingPanel],
                backing: .buffered, defer: false)
            window.isOpaque = false
            window.backgroundColor = .clear
            window.hasShadow = false
            window.ignoresMouseEvents = true
            window.hidesOnDeactivate = false
            window.level = .statusBar
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]
            window.isReleasedWhenClosed = false

            let view = NSView(frame: NSRect(origin: .zero, size: screen.frame.size))
            view.wantsLayer = true
            let root = CALayer()
            root.frame = view.bounds
            view.layer = root
            window.contentView = view

            for fromLeft in [true, false] {
                let emitter = CAEmitterLayer()
                emitter.frame = view.bounds
                emitter.emitterPosition = CGPoint(
                    x: fromLeft ? 0 : view.bounds.width, y: view.bounds.height * 0.12)
                emitter.emitterShape = .point
                emitter.renderMode = .unordered
                let colors: [NSColor] = [
                    .systemPink, .systemOrange, .systemYellow,
                    .systemGreen, .systemCyan, .systemPurple
                ]
                emitter.emitterCells = colors.map { color in
                    let cell = CAEmitterCell()
                    cell.contents = Self.piece(color)
                    cell.birthRate = 48
                    cell.lifetime = 4
                    cell.lifetimeRange = 0.5
                    cell.velocity = min(1100, max(650, view.bounds.height * 1.05))
                    cell.velocityRange = 180
                    cell.emissionLongitude = fromLeft ? .pi / 3 : 2 * .pi / 3
                    cell.emissionRange = .pi / 5
                    cell.yAcceleration = -650
                    cell.xAcceleration = fromLeft ? 12 : -12
                    cell.spin = 3
                    cell.spinRange = 7
                    cell.scale = 0.7
                    cell.scaleRange = 0.35
                    cell.alphaSpeed = -0.16
                    return cell
                }
                root.addSublayer(emitter)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    emitter.birthRate = 0
                }
            }
            window.orderFrontRegardless()
            windows.append(window)
        }
        // A hard deadline also handles displays being disconnected during the animation.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            NSApplication.shared.terminate(nil)
        }
    }

    private static func piece(_ color: NSColor) -> CGImage {
        let image = NSImage(size: NSSize(width: 12, height: 7))
        image.lockFocus()
        color.setFill()
        NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: 12, height: 7),
                     xRadius: 1, yRadius: 1).fill()
        image.unlockFocus()
        return image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    }
}

let application = NSApplication.shared
let delegate = ConfettiApp()
application.setActivationPolicy(.accessory)
application.delegate = delegate
application.run()
