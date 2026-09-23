import Cocoa
import SpriteKit

final class MenuScene: GameSceneBase {
    private var cards: [SKNode] = []
    private var selected = 0
    private var page = 0
    private let pageSize = 12

    override func setup() {
        backgroundColor = NSColor(calibratedRed: 0.05, green: 0.08, blue: 0.14, alpha: 1)
        hudLabel.isHidden = true

        let title = SKLabelNode(fontNamed: "Menlo-Bold")
        title.text = "PIXEL VAULT 36"
        title.fontSize = 28
        title.fontColor = NSColor(calibratedRed: 0.24, green: 0.84, blue: 0.78, alpha: 1)
        title.position = CGPoint(x: size.width / 2, y: size.height - 40)
        addChild(title)

        let sub = SKLabelNode(fontNamed: "Menlo")
        sub.text = "Original games · Arrows move · Enter/Z play · Esc quit game"
        sub.fontSize = 11
        sub.fontColor = NSColor(calibratedWhite: 0.7, alpha: 1)
        sub.position = CGPoint(x: size.width / 2, y: size.height - 68)
        addChild(sub)

        rebuildPage()
    }

    private func rebuildPage() {
        cards.forEach { $0.removeFromParent() }
        cards.removeAll()

        let start = page * pageSize
        let slice = Array(GameCatalog.all[start..<min(start + pageSize, GameCatalog.all.count)])
        let cols = 3
        let cardW: CGFloat = 150
        let cardH: CGFloat = 70
        let gapX: CGFloat = 12
        let gapY: CGFloat = 12
        let originX = (size.width - CGFloat(cols) * cardW - CGFloat(cols - 1) * gapX) / 2
        let originY = size.height - 120

        for (i, info) in slice.enumerated() {
            let col = i % cols
            let row = i / cols
            let node = SKNode()
            node.position = CGPoint(
                x: originX + CGFloat(col) * (cardW + gapX) + cardW / 2,
                y: originY - CGFloat(row) * (cardH + gapY) - cardH / 2
            )
            node.name = "card-\(info.id)"

            let bg = SKShapeNode(rectOf: CGSize(width: cardW, height: cardH), cornerRadius: 6)
            bg.fillColor = NSColor(calibratedRed: 0.12, green: 0.16, blue: 0.26, alpha: 1)
            bg.strokeColor = NSColor(calibratedRed: 0.2, green: 0.28, blue: 0.42, alpha: 1)
            bg.lineWidth = 2
            bg.name = "bg"
            node.addChild(bg)

            let num = SKLabelNode(fontNamed: "Menlo-Bold")
            num.text = String(format: "#%02d", info.id)
            num.fontSize = 10
            num.fontColor = NSColor(calibratedRed: 0.24, green: 0.84, blue: 0.78, alpha: 1)
            num.position = CGPoint(x: 0, y: 18)
            node.addChild(num)

            let name = SKLabelNode(fontNamed: "Menlo-Bold")
            name.text = info.title
            name.fontSize = 12
            name.fontColor = .white
            name.position = CGPoint(x: 0, y: 0)
            node.addChild(name)

            let genre = SKLabelNode(fontNamed: "Menlo")
            genre.text = info.genre.rawValue.uppercased()
            genre.fontSize = 9
            genre.fontColor = NSColor(calibratedRed: 0.94, green: 0.64, blue: 0.35, alpha: 1)
            genre.position = CGPoint(x: 0, y: -18)
            node.addChild(genre)

            addChild(node)
            cards.append(node)
        }

        let pageLabel = childNode(withName: "pageLabel") as? SKLabelNode ?? {
            let l = SKLabelNode(fontNamed: "Menlo")
            l.name = "pageLabel"
            l.fontSize = 12
            l.fontColor = .white
            l.position = CGPoint(x: size.width / 2, y: 36)
            addChild(l)
            return l
        }()
        let pages = (GameCatalog.all.count + pageSize - 1) / pageSize
        pageLabel.text = "Page \(page + 1)/\(pages)  ·  [ / ] change page"
        refreshSelection()
    }

    private func refreshSelection() {
        for (i, card) in cards.enumerated() {
            if let bg = card.childNode(withName: "bg") as? SKShapeNode {
                bg.strokeColor = i == selected
                    ? NSColor(calibratedRed: 0.24, green: 0.84, blue: 0.78, alpha: 1)
                    : NSColor(calibratedRed: 0.2, green: 0.28, blue: 0.42, alpha: 1)
                bg.lineWidth = i == selected ? 3 : 2
            }
        }
    }

    private func launchSelected() {
        let start = page * pageSize
        guard start + selected < GameCatalog.all.count else { return }
        let info = GameCatalog.all[start + selected]
        let scene = GameCatalog.scene(for: info.sceneKey, size: size)
        scene.scaleMode = .aspectFit
        view?.presentScene(scene, transition: .doorsCloseHorizontal(withDuration: 0.3))
    }

    override func tick(_ currentTime: TimeInterval) {
        let cols = 3
        if keys.justPressed(KeyState.left) || keys.justPressed(KeyState.a) {
            selected = max(0, selected - 1)
            refreshSelection()
        }
        if keys.justPressed(KeyState.right) || keys.justPressed(KeyState.d) {
            selected = min(cards.count - 1, selected + 1)
            refreshSelection()
        }
        if keys.justPressed(KeyState.up) || keys.justPressed(KeyState.w) {
            selected = max(0, selected - cols)
            refreshSelection()
        }
        if keys.justPressed(KeyState.down) || keys.justPressed(KeyState.s) {
            selected = min(cards.count - 1, selected + cols)
            refreshSelection()
        }
        // [ and ] for paging — keycodes 33 and 30
        if keys.justPressed(33) {
            let pages = (GameCatalog.all.count + pageSize - 1) / pageSize
            page = (page - 1 + pages) % pages
            selected = 0
            rebuildPage()
        }
        if keys.justPressed(30) {
            let pages = (GameCatalog.all.count + pageSize - 1) / pageSize
            page = (page + 1) % pages
            selected = 0
            rebuildPage()
        }
        if keys.confirmJust {
            launchSelected()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Menu: Esc does nothing special (don't bounce)
        tick(currentTime)
        keys.endFrame()
    }
}
