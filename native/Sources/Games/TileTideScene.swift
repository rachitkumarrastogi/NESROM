import Cocoa
import SpriteKit

final class TileTideScene: GameSceneBase {
    private let n = 4
    private var grid: [Int] = []
    private var empty = 15
    private var tiles: [SKLabelNode] = []
    private var moves = 0
    private var won = false

    override func setup() {
        backgroundColor = NSColor(calibratedRed: 0.1, green: 0.14, blue: 0.25, alpha: 1)
        grid = Array(0..<16)
        empty = 15
        for _ in 0..<100 {
            let opts = neighbors(empty)
            let pick = opts.randomElement()!
            swap(empty, pick)
            empty = pick
        }
        moves = 0
        layout()
        setHUD("Tile Tide  MOVES 0  · Arrows slide  Esc menu")
    }

    private func idx(_ r: Int, _ c: Int) -> Int { r * n + c }

    private func neighbors(_ e: Int) -> [Int] {
        let r = e / n
        let c = e % n
        var out: [Int] = []
        if r > 0 { out.append(idx(r - 1, c)) }
        if r < n - 1 { out.append(idx(r + 1, c)) }
        if c > 0 { out.append(idx(r, c - 1)) }
        if c < n - 1 { out.append(idx(r, c + 1)) }
        return out
    }

    private func swap(_ a: Int, _ b: Int) {
        grid.swapAt(a, b)
    }

    private func layout() {
        tiles.forEach { $0.removeFromParent() }
        tiles.removeAll()
        let cell: CGFloat = 56
        let ox = (size.width - CGFloat(n) * cell) / 2 + cell / 2
        let oy = (size.height - CGFloat(n) * cell) / 2 + cell / 2 + 10
        for r in 0..<n {
            for c in 0..<n {
                let v = grid[idx(r, c)]
                if v == 15 { continue }
                let label = SKLabelNode(fontNamed: "Menlo-Bold")
                label.text = "\(v + 1)"
                label.fontSize = 22
                label.fontColor = .white
                label.verticalAlignmentMode = .center
                label.position = CGPoint(x: ox + CGFloat(c) * cell, y: oy + CGFloat(n - 1 - r) * cell)
                let bg = SKShapeNode(rectOf: CGSize(width: cell - 6, height: cell - 6), cornerRadius: 4)
                bg.fillColor = NSColor(calibratedRed: 0.24, green: 0.42, blue: 0.55, alpha: 1)
                bg.strokeColor = .clear
                bg.zPosition = -1
                label.addChild(bg)
                addChild(label)
                tiles.append(label)
            }
        }
    }

    private func tryMove(dr: Int, dc: Int) {
        guard !won else { return }
        let r = empty / n
        let c = empty % n
        // moving tile into empty from opposite direction
        let nr = r - dr
        let nc = c - dc
        guard nr >= 0, nr < n, nc >= 0, nc < n else { return }
        let ni = idx(nr, nc)
        swap(empty, ni)
        empty = ni
        moves += 1
        layout()
        if grid == Array(0..<16) {
            won = true
            setHUD("SOLVED! MOVES \(moves)  · Esc menu")
        } else {
            setHUD("Tile Tide  MOVES \(moves)  · Esc menu")
        }
    }

    override func tick(_ currentTime: TimeInterval) {
        if keys.justPressed(KeyState.up) || keys.justPressed(KeyState.w) { tryMove(dr: 1, dc: 0) }
        if keys.justPressed(KeyState.down) || keys.justPressed(KeyState.s) { tryMove(dr: -1, dc: 0) }
        if keys.justPressed(KeyState.left) || keys.justPressed(KeyState.a) { tryMove(dr: 0, dc: 1) }
        if keys.justPressed(KeyState.right) || keys.justPressed(KeyState.d) { tryMove(dr: 0, dc: -1) }
    }
}
