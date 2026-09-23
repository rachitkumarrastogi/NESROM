import Cocoa
import SpriteKit

/// Native SpriteKit view that captures keyboard for gameplay.
final class GameView: SKView {
    override var acceptsFirstResponder: Bool { true }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.makeFirstResponder(self)
    }

    override func keyDown(with event: NSEvent) {
        (scene as? InputReceiving)?.handleKeyDown(event)
    }

    override func keyUp(with event: NSEvent) {
        (scene as? InputReceiving)?.handleKeyUp(event)
    }
}

protocol InputReceiving: AnyObject {
    func handleKeyDown(_ event: NSEvent)
    func handleKeyUp(_ event: NSEvent)
}
