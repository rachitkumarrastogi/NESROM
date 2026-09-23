import Cocoa
import SpriteKit

final class StarMothScene: GameSceneBase {
    private var ship: SKSpriteNode!
    private var score = 0
    private var lastTime: TimeInterval?

    override func setup() {
        backgroundColor = NSColor(calibratedRed: 0.02, green: 0.02, blue: 0.06, alpha: 1)
        ship = SKSpriteNode(texture: PixelArt.mothShip())
        ship.size = CGSize(width: 28, height: 24)
        ship.position = CGPoint(x: size.width / 2, y: 50)
        addChild(ship)
        setHUD("Star Moth  SCR 0")
    }

    override func tick(_ currentTime: TimeInterval) {
        let dt: CGFloat
        if let last = lastTime { dt = CGFloat(min(0.05, currentTime - last)) } else { dt = 1 / 60 }
        lastTime = currentTime

        if keys.leftHeld { ship.position.x -= 140 * dt }
        if keys.rightHeld { ship.position.x += 140 * dt }
        ship.position.x = min(max(20, ship.position.x), size.width - 20)

        if keys.actionJust {
            let s = SKSpriteNode(color: PixelColor.coin, size: CGSize(width: 4, height: 10))
            s.position = CGPoint(x: ship.position.x, y: ship.position.y + 16)
            s.name = "shot"
            addChild(s)
        }

        enumerateChildNodes(withName: "shot") { node, _ in
            node.position.y += 240 * dt
            if node.position.y > self.size.height + 10 { node.removeFromParent() }
        }

        if Int.random(in: 0...20) == 0 {
            let rock = SKSpriteNode(color: NSColor(calibratedRed: 0.5, green: 0.4, blue: 0.35, alpha: 1), size: CGSize(width: CGFloat.random(in: 14...24), height: CGFloat.random(in: 14...24)))
            rock.position = CGPoint(x: CGFloat.random(in: 20...size.width - 20), y: size.height + 20)
            rock.name = "rock"
            rock.userData = ["vy": CGFloat.random(in: 60...120)]
            addChild(rock)
        }

        enumerateChildNodes(withName: "rock") { node, _ in
            let vy = (node.userData?["vy"] as? CGFloat) ?? 80
            node.position.y -= vy * dt
            if node.position.y < -30 { node.removeFromParent() }
            self.enumerateChildNodes(withName: "shot") { shot, _ in
                if shot.frame.intersects(node.frame) {
                    shot.removeFromParent()
                    node.removeFromParent()
                    self.score += 15
                }
            }
            if node.frame.intersects(self.ship.frame) {
                self.setHUD("CRASH  SCR \(self.score)  · Esc menu")
                self.isPaused = true
            }
        }

        setHUD("Star Moth  SCR \(score)  · Esc menu")
    }
}
