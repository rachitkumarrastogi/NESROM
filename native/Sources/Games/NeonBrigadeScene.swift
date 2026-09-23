import Cocoa
import SpriteKit

/// Original run-and-gun starring Nyx.
final class NeonBrigadeScene: GameSceneBase {
    private var player: SKSpriteNode!
    private var score = 0
    private var hp = 3
    private var wave = 1
    private var lastTime: TimeInterval?
    private var invuln: CGFloat = 0
    private var spawnCooldown: CGFloat = 0

    override func setup() {
        backgroundColor = NSColor(calibratedRed: 0.05, green: 0.08, blue: 0.15, alpha: 1)
        let ground = SKSpriteNode(color: NSColor(calibratedRed: 0.06, green: 0.18, blue: 0.1, alpha: 1), size: CGSize(width: size.width, height: 40))
        ground.position = CGPoint(x: size.width / 2, y: 20)
        addChild(ground)

        player = SKSpriteNode(texture: PixelArt.nyx())
        player.size = CGSize(width: 28, height: 32)
        player.position = CGPoint(x: 60, y: size.height / 2)
        addChild(player)
        spawnWave()
        setHUD("Neon Brigade  SCR 0  HP 3  W1")
    }

    private func spawnWave() {
        let n = 3 + wave
        for i in 0..<n {
            let e = SKSpriteNode(texture: PixelArt.crawler())
            e.size = CGSize(width: 22, height: 18)
            e.position = CGPoint(x: size.width + CGFloat(i * 30), y: 60 + CGFloat(i % 5) * 40)
            e.name = "enemy"
            e.userData = ["hp": 1 + (wave > 3 ? 1 : 0), "shoot": CGFloat.random(in: 0.8...2.0)]
            addChild(e)
        }
    }

    override func tick(_ currentTime: TimeInterval) {
        let dt: CGFloat
        if let last = lastTime { dt = CGFloat(min(0.05, currentTime - last)) } else { dt = 1 / 60 }
        lastTime = currentTime
        if invuln > 0 { invuln -= dt }

        var dy: CGFloat = 0
        if keys.upHeld { dy += 1 }
        if keys.downHeld { dy -= 1 }
        player.position.y += dy * 160 * dt
        player.position.y = min(max(40, player.position.y), size.height - 40)

        if keys.actionJust {
            let b = SKSpriteNode(color: PixelColor.coin, size: CGSize(width: 8, height: 4))
            b.position = CGPoint(x: player.position.x + 18, y: player.position.y)
            b.name = "friendBullet"
            b.userData = ["vx": CGFloat(260)]
            addChild(b)
        }

        enumerateChildNodes(withName: "friendBullet") { node, _ in
            let vx = (node.userData?["vx"] as? CGFloat) ?? 200
            node.position.x += vx * dt
            if node.position.x > self.size.width + 20 { node.removeFromParent() }
        }
        enumerateChildNodes(withName: "enemyBullet") { node, _ in
            let vx = (node.userData?["vx"] as? CGFloat) ?? -160
            node.position.x += vx * dt
            if node.position.x < -20 { node.removeFromParent() }
            if self.invuln <= 0 && node.frame.intersects(self.player.frame) {
                node.removeFromParent()
                self.damage()
            }
        }

        var enemyCount = 0
        enumerateChildNodes(withName: "enemy") { node, _ in
            enemyCount += 1
            node.position.x -= (40 + CGFloat(self.wave) * 4) * dt
            node.position.y += sin(node.position.x * 0.05) * 18 * dt
            var shoot = (node.userData?["shoot"] as? CGFloat) ?? 1
            shoot -= dt
            if shoot <= 0 {
                shoot = 1.5
                let b = SKSpriteNode(color: PixelColor.danger, size: CGSize(width: 6, height: 3))
                b.position = node.position
                b.name = "enemyBullet"
                b.userData = ["vx": CGFloat(-150)]
                self.addChild(b)
            }
            node.userData?["shoot"] = shoot

            self.enumerateChildNodes(withName: "friendBullet") { bullet, _ in
                if bullet.frame.intersects(node.frame) {
                    bullet.removeFromParent()
                    var hp = (node.userData?["hp"] as? Int) ?? 1
                    hp -= 1
                    if hp <= 0 {
                        node.removeFromParent()
                        self.score += 20
                    } else {
                        node.userData?["hp"] = hp
                    }
                }
            }

            if self.invuln <= 0 && node.frame.intersects(self.player.frame) {
                node.removeFromParent()
                self.damage()
            }
        }

        if enemyCount == 0 {
            wave += 1
            spawnWave()
        }

        setHUD("Neon Brigade  SCR \(score)  HP \(hp)  W\(wave)  · Esc menu")
    }

    private func damage() {
        hp -= 1
        invuln = 1.0
        player.alpha = 0.4
        player.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in self?.player.alpha = 1 },
        ]))
        if hp <= 0 {
            setHUD("DOWNED  SCR \(score)  · Esc menu")
            isPaused = true
        }
    }
}
