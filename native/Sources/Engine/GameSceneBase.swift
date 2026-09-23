import Cocoa
import SpriteKit

final class KeyState {
    private var held = Set<UInt16>()
    private var pressed = Set<UInt16>()

    func down(_ event: NSEvent) {
        let code = event.keyCode
        if !held.contains(code) { pressed.insert(code) }
        held.insert(code)
    }

    func up(_ event: NSEvent) {
        held.remove(event.keyCode)
    }

    func endFrame() {
        pressed.removeAll()
    }

    func isDown(_ code: UInt16) -> Bool { held.contains(code) }
    func justPressed(_ code: UInt16) -> Bool { pressed.contains(code) }

    // ANSI keycodes
    static let left: UInt16 = 123
    static let right: UInt16 = 124
    static let down: UInt16 = 125
    static let up: UInt16 = 126
    static let z: UInt16 = 6
    static let x: UInt16 = 7
    static let space: UInt16 = 49
    static let escape: UInt16 = 53
    static let returnKey: UInt16 = 36
    static let a: UInt16 = 0
    static let d: UInt16 = 2
    static let w: UInt16 = 13
    static let s: UInt16 = 1

    var leftHeld: Bool { isDown(Self.left) || isDown(Self.a) }
    var rightHeld: Bool { isDown(Self.right) || isDown(Self.d) }
    var upHeld: Bool { isDown(Self.up) || isDown(Self.w) }
    var downHeld: Bool { isDown(Self.down) || isDown(Self.s) }
    var actionJust: Bool { justPressed(Self.z) || justPressed(Self.space) }
    var escapeJust: Bool { justPressed(Self.escape) }
    var confirmJust: Bool { justPressed(Self.returnKey) || justPressed(Self.z) || justPressed(Self.space) }
}

class GameSceneBase: SKScene, InputReceiving {
    let keys = KeyState()
    private(set) var hudLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        backgroundColor = NSColor(calibratedRed: 0.07, green: 0.09, blue: 0.14, alpha: 1)
        hudLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        hudLabel.fontSize = 12
        hudLabel.fontColor = .white
        hudLabel.horizontalAlignmentMode = .left
        hudLabel.verticalAlignmentMode = .top
        hudLabel.position = CGPoint(x: 8, y: size.height - 8)
        hudLabel.zPosition = 1000
        addChild(hudLabel)
        setup()
    }

    func setup() {}

    func handleKeyDown(_ event: NSEvent) { keys.down(event) }
    func handleKeyUp(_ event: NSEvent) { keys.up(event) }

    override func update(_ currentTime: TimeInterval) {
        if keys.escapeJust {
            returnToMenu()
            return
        }
        tick(currentTime)
        keys.endFrame()
    }

    func tick(_ currentTime: TimeInterval) {}

    func returnToMenu() {
        let menu = MenuScene(size: size)
        menu.scaleMode = .aspectFit
        view?.presentScene(menu, transition: .fade(with: .black, duration: 0.25))
    }

    func setHUD(_ text: String) {
        hudLabel?.text = text
    }
}
