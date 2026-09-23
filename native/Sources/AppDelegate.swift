import Cocoa
import SpriteKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let size = NSSize(width: 1024, height: 768)
        window = NSWindow(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Pixel Vault 36"
        window.center()
        window.minSize = NSSize(width: 640, height: 480)

        let view = GameView(frame: NSRect(origin: .zero, size: size))
        view.autoresizingMask = [.width, .height]
        window.contentView = view

        let scene = MenuScene(size: CGSize(width: 512, height: 480))
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
        window.makeKeyAndOrderFront(nil)
        window.makeFirstResponder(view)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
