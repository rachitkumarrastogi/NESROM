import Cocoa
import SpriteKit

/// Original platformer starring Pip (not based on any commercial character art).
final class SproutJumpScene: GameSceneBase {
    private var player: SKSpriteNode!
    private var cameraNode: SKCameraNode!
    private var velocity = CGVector.zero
    private var onGround = false
    private var score = 0
    private var lives = 3
    private var solids: [SKNode] = []
    private let tile: CGFloat = 16
    private var lastTime: TimeInterval?

    override func setup() {
        backgroundColor = PixelColor.sky
        cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode

        buildLevel()
        player = SKSpriteNode(texture: PixelArt.pip())
        player.size = CGSize(width: 24, height: 30)
        player.position = CGPoint(x: 48, y: 180)
        player.zPosition = 10
        addChild(player)
        setHUD("Sprout Jump  SCR 0  LV 3  · Esc menu")
    }

    private func addSolid(rect: CGRect, texture: SKTexture) {
        let node = SKSpriteNode(texture: texture)
        node.size = rect.size
        node.position = CGPoint(x: rect.midX, y: rect.midY)
        node.name = "solid"
        addChild(node)
        solids.append(node)
    }

    private func buildLevel() {
        func floor(_ x0: CGFloat, _ x1: CGFloat, y: CGFloat = 48) {
            var x = x0
            while x < x1 {
                addSolid(rect: CGRect(x: x, y: y - tile, width: tile, height: tile), texture: PixelArt.blockGrass())
                x += tile
            }
        }
        floor(0, 28 * tile)
        floor(30 * tile, 48 * tile)
        floor(50 * tile, 72 * tile)
        floor(74 * tile, 100 * tile)

        let plats: [(CGFloat, CGFloat)] = [
            (8, 10), (14, 9), (20, 8), (34, 10), (40, 8),
            (54, 9), (60, 7), (66, 10), (78, 8), (84, 6), (90, 9),
        ]
        for (tx, ty) in plats {
            addSolid(
                rect: CGRect(x: tx * tile, y: ty * tile, width: tile * 3, height: tile),
                texture: PixelArt.blockBrick()
            )
        }

        for i in 0..<20 {
            let coin = SKSpriteNode(texture: PixelArt.coin())
            coin.size = CGSize(width: 12, height: 12)
            coin.position = CGPoint(x: CGFloat(6 + i * 4) * tile, y: CGFloat(6 + i % 3) * tile)
            coin.name = "coin"
            addChild(coin)
        }

        for i in 0..<4 {
            let foe = SKSpriteNode(texture: PixelArt.crawler())
            foe.size = CGSize(width: 20, height: 16)
            foe.position = CGPoint(x: CGFloat(16 + i * 18) * tile, y: 48 + 8)
            foe.name = "foe"
            foe.userData = ["vx": CGFloat(i % 2 == 0 ? -50 : 50)]
            addChild(foe)
        }

        let flag = SKSpriteNode(color: PixelColor.danger, size: CGSize(width: 14, height: 40))
        flag.position = CGPoint(x: 96 * tile, y: 48 + 20)
        flag.name = "flag"
        addChild(flag)
    }

    private func playerRect() -> CGRect {
        CGRect(
            x: player.position.x - player.size.width * 0.35,
            y: player.position.y - player.size.height * 0.45,
            width: player.size.width * 0.7,
            height: player.size.height * 0.9
        )
    }

    private func nodeRect(_ node: SKNode) -> CGRect {
        let s: CGSize
        if let sp = node as? SKSpriteNode {
            s = sp.size
        } else {
            s = CGSize(width: 16, height: 16)
        }
        return CGRect(
            x: node.position.x - s.width / 2,
            y: node.position.y - s.height / 2,
            width: s.width,
            height: s.height
        )
    }

    override func tick(_ currentTime: TimeInterval) {
        let dt: CGFloat
        if let last = lastTime {
            dt = CGFloat(min(0.05, currentTime - last))
        } else {
            dt = 1.0 / 60.0
        }
        lastTime = currentTime

        velocity.dx = 0
        if keys.leftHeld { velocity.dx = -120 }
        if keys.rightHeld { velocity.dx = 120 }
        if keys.actionJust && onGround {
            velocity.dy = 280
            onGround = false
        }
        velocity.dy -= 900 * dt

        player.position.x += velocity.dx * dt
        resolve(axis: .x)
        player.position.y += velocity.dy * dt
        onGround = false
        resolve(axis: .y)

        cameraNode.position = CGPoint(x: max(size.width / 2, player.position.x), y: size.height / 2)
        hudLabel.position = CGPoint(x: cameraNode.position.x - size.width / 2 + 8, y: size.height - 8)

        enumerateChildNodes(withName: "coin") { node, _ in
            if self.playerRect().intersects(self.nodeRect(node)) {
                node.removeFromParent()
                self.score += 10
            }
        }

        enumerateChildNodes(withName: "foe") { node, _ in
            let vx = (node.userData?["vx"] as? CGFloat) ?? -40
            node.position.x += vx * dt
            if self.playerRect().intersects(self.nodeRect(node)) {
                if self.velocity.dy < -20 {
                    node.removeFromParent()
                    self.velocity.dy = 200
                    self.score += 50
                } else {
                    self.hurt()
                }
            }
        }

        if let flag = childNode(withName: "flag"), playerRect().intersects(nodeRect(flag)) {
            setHUD("STAGE CLEAR! SCR \(score)  · Esc menu")
            velocity = .zero
        }

        if player.position.y < -40 {
            hurt()
        }

        setHUD("Sprout Jump  SCR \(score)  LV \(lives)  · Esc menu")
    }

    private enum Axis { case x, y }

    private func resolve(axis: Axis) {
        var prect = playerRect()
        for solid in solids {
            let srect = nodeRect(solid)
            guard prect.intersects(srect) else { continue }
            if axis == .x {
                if velocity.dx > 0 {
                    player.position.x = srect.minX - player.size.width * 0.35
                } else if velocity.dx < 0 {
                    player.position.x = srect.maxX + player.size.width * 0.35
                }
                velocity.dx = 0
            } else {
                if velocity.dy > 0 {
                    player.position.y = srect.minY - player.size.height * 0.45
                    velocity.dy = 0
                } else if velocity.dy < 0 {
                    player.position.y = srect.maxY + player.size.height * 0.45
                    velocity.dy = 0
                    onGround = true
                }
            }
            prect = playerRect()
        }
    }

    private func hurt() {
        lives -= 1
        player.position = CGPoint(x: 48, y: 180)
        velocity = .zero
        if lives <= 0 {
            setHUD("GAME OVER  SCR \(score)  · Esc menu")
            isPaused = true
        }
    }
}
