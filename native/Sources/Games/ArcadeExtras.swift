import Cocoa
import SpriteKit

final class PulsePaddleScene: GameSceneBase {
    private var paddle: SKSpriteNode!
    private var ball: SKSpriteNode!
    private var velocity = CGVector(dx: 120, dy: 160)
    private var score = 0
    private var lastTime: TimeInterval?

    override func setup() {
        backgroundColor = NSColor(calibratedRed: 0.08, green: 0.1, blue: 0.18, alpha: 1)
        paddle = SKSpriteNode(color: PixelColor.nyx, size: CGSize(width: 64, height: 10))
        paddle.position = CGPoint(x: size.width / 2, y: 40)
        addChild(paddle)

        ball = SKSpriteNode(color: PixelColor.coin, size: CGSize(width: 10, height: 10))
        ball.position = CGPoint(x: size.width / 2, y: 80)
        addChild(ball)

        for row in 0..<4 {
            for col in 0..<8 {
                let brick = SKSpriteNode(
                    color: row % 2 == 0 ? PixelColor.danger : PixelColor.sprout,
                    size: CGSize(width: 52, height: 14)
                )
                brick.position = CGPoint(x: 40 + CGFloat(col) * 56, y: size.height - 60 - CGFloat(row) * 20)
                brick.name = "brick"
                addChild(brick)
            }
        }
        setHUD("Pulse Paddle  SCR 0")
    }

    override func tick(_ currentTime: TimeInterval) {
        let dt: CGFloat
        if let last = lastTime { dt = CGFloat(min(0.05, currentTime - last)) } else { dt = 1 / 60 }
        lastTime = currentTime

        if keys.leftHeld { paddle.position.x -= 200 * dt }
        if keys.rightHeld { paddle.position.x += 200 * dt }
        paddle.position.x = min(max(40, paddle.position.x), size.width - 40)

        ball.position.x += velocity.dx * dt
        ball.position.y += velocity.dy * dt

        if ball.position.x < 8 || ball.position.x > size.width - 8 { velocity.dx *= -1 }
        if ball.position.y > size.height - 8 { velocity.dy *= -1 }
        if ball.frame.intersects(paddle.frame) && velocity.dy < 0 {
            velocity.dy = abs(velocity.dy)
            velocity.dx += (ball.position.x - paddle.position.x) * 2
        }

        enumerateChildNodes(withName: "brick") { node, _ in
            if node.frame.intersects(self.ball.frame) {
                node.removeFromParent()
                self.velocity.dy *= -1
                self.score += 10
            }
        }

        if ball.position.y < 0 {
            setHUD("MISS  SCR \(score)  · Esc menu")
            isPaused = true
            return
        }

        var left = 0
        enumerateChildNodes(withName: "brick") { _, _ in left += 1 }
        if left == 0 {
            setHUD("CLEAR! SCR \(score)  · Esc menu")
            isPaused = true
            return
        }
        setHUD("Pulse Paddle  SCR \(score)  · Esc menu")
    }
}

final class RiverRaftScene: GameSceneBase {
    private var raft: SKSpriteNode!
    private var score = 0
    private var lastTime: TimeInterval?

    override func setup() {
        backgroundColor = NSColor(calibratedRed: 0.15, green: 0.45, blue: 0.7, alpha: 1)
        raft = SKSpriteNode(color: PixelColor.dirt, size: CGSize(width: 36, height: 20))
        raft.position = CGPoint(x: size.width / 2, y: 80)
        addChild(raft)
        setHUD("River Raft  SCR 0")
    }

    override func tick(_ currentTime: TimeInterval) {
        let dt: CGFloat
        if let last = lastTime { dt = CGFloat(min(0.05, currentTime - last)) } else { dt = 1 / 60 }
        lastTime = currentTime

        if keys.leftHeld { raft.position.x -= 150 * dt }
        if keys.rightHeld { raft.position.x += 150 * dt }
        raft.position.x = min(max(30, raft.position.x), size.width - 30)
        score += Int(dt * 20)

        if Int.random(in: 0...25) == 0 {
            let snag = SKSpriteNode(color: PixelColor.sproutDark, size: CGSize(width: CGFloat.random(in: 20...40), height: 16))
            snag.position = CGPoint(x: CGFloat.random(in: 30...size.width - 30), y: size.height + 10)
            snag.name = "snag"
            addChild(snag)
        }

        enumerateChildNodes(withName: "snag") { node, _ in
            node.position.y -= 120 * dt
            if node.position.y < -20 { node.removeFromParent() }
            if node.frame.intersects(self.raft.frame) {
                self.setHUD("CAPSIZED  SCR \(self.score)  · Esc menu")
                self.isPaused = true
            }
        }
        setHUD("River Raft  SCR \(score)  · Esc menu")
    }
}

/// Playable template used by the remaining catalog titles — unique colors/speeds per game.
final class ArcadeTemplateScene: GameSceneBase {
    private let info: GameInfo
    private var hero: SKSpriteNode!
    private var score = 0
    private var lastTime: TimeInterval?
    private var hue: CGFloat

    init(size: CGSize, info: GameInfo) {
        self.info = info
        self.hue = CGFloat(info.id) / 36.0
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        backgroundColor = NSColor(calibratedHue: hue, saturation: 0.35, brightness: 0.18, alpha: 1)
        let title = SKLabelNode(fontNamed: "Menlo-Bold")
        title.text = info.title.uppercased()
        title.fontSize = 16
        title.fontColor = NSColor(calibratedHue: hue, saturation: 0.7, brightness: 0.95, alpha: 1)
        title.position = CGPoint(x: size.width / 2, y: size.height - 36)
        addChild(title)

        let blurb = SKLabelNode(fontNamed: "Menlo")
        blurb.text = info.blurb
        blurb.fontSize = 10
        blurb.fontColor = NSColor(calibratedWhite: 0.75, alpha: 1)
        blurb.position = CGPoint(x: size.width / 2, y: size.height - 56)
        addChild(blurb)

        hero = SKSpriteNode(texture: info.id % 2 == 0 ? PixelArt.pip() : PixelArt.nyx())
        hero.size = CGSize(width: 26, height: 30)
        hero.position = CGPoint(x: size.width / 2, y: 70)
        addChild(hero)
        setHUD("\(info.title)  SCR 0  · Esc menu")
    }

    override func tick(_ currentTime: TimeInterval) {
        let dt: CGFloat
        if let last = lastTime { dt = CGFloat(min(0.05, currentTime - last)) } else { dt = 1 / 60 }
        lastTime = currentTime

        let speed: CGFloat = 100 + CGFloat(info.id) * 3
        if keys.leftHeld { hero.position.x -= speed * dt }
        if keys.rightHeld { hero.position.x += speed * dt }
        if keys.upHeld { hero.position.y += speed * dt }
        if keys.downHeld { hero.position.y -= speed * dt }
        hero.position.x = min(max(20, hero.position.x), size.width - 20)
        hero.position.y = min(max(20, hero.position.y), size.height - 80)

        if keys.actionJust {
            let bolt = SKSpriteNode(
                color: NSColor(calibratedHue: hue, saturation: 0.8, brightness: 1, alpha: 1),
                size: CGSize(width: 6, height: 10)
            )
            bolt.position = CGPoint(x: hero.position.x, y: hero.position.y + 20)
            bolt.name = "bolt"
            addChild(bolt)
        }

        enumerateChildNodes(withName: "bolt") { node, _ in
            node.position.y += 220 * dt
            if node.position.y > self.size.height { node.removeFromParent() }
        }

        let spawnChance = max(8, 28 - info.id / 2)
        if Int.random(in: 0...spawnChance) == 0 {
            let foe = SKSpriteNode(texture: PixelArt.crawler())
            foe.size = CGSize(width: 18, height: 14)
            foe.position = CGPoint(x: CGFloat.random(in: 30...size.width - 30), y: size.height + 10)
            foe.name = "foe"
            foe.userData = ["vy": CGFloat(50 + info.id * 2)]
            addChild(foe)
        }

        enumerateChildNodes(withName: "foe") { node, _ in
            let vy = (node.userData?["vy"] as? CGFloat) ?? 70
            node.position.y -= vy * dt
            if node.position.y < -20 { node.removeFromParent() }
            self.enumerateChildNodes(withName: "bolt") { bolt, _ in
                if bolt.frame.intersects(node.frame) {
                    bolt.removeFromParent()
                    node.removeFromParent()
                    self.score += 10 + self.info.id
                }
            }
            if node.frame.intersects(self.hero.frame) {
                self.setHUD("OUT  SCR \(self.score)  · Esc menu")
                self.isPaused = true
            }
        }

        score += Int(dt * 5)
        setHUD("\(info.title)  SCR \(score)  · Esc menu")
    }
}
