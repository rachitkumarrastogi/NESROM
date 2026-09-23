import AppKit
import SpriteKit

enum PixelColor {
    static let clear = NSColor.clear
    static let black = NSColor(calibratedRed: 0.05, green: 0.05, blue: 0.08, alpha: 1)
    static let white = NSColor.white
    static let sprout = NSColor(calibratedRed: 0.22, green: 0.78, blue: 0.45, alpha: 1)
    static let sproutDark = NSColor(calibratedRed: 0.12, green: 0.48, blue: 0.28, alpha: 1)
    static let skin = NSColor(calibratedRed: 0.96, green: 0.80, blue: 0.62, alpha: 1)
    static let nyx = NSColor(calibratedRed: 0.24, green: 0.84, blue: 0.78, alpha: 1)
    static let nyxDark = NSColor(calibratedRed: 0.10, green: 0.40, blue: 0.42, alpha: 1)
    static let moth = NSColor(calibratedRed: 0.75, green: 0.88, blue: 1.0, alpha: 1)
    static let danger = NSColor(calibratedRed: 0.91, green: 0.36, blue: 0.42, alpha: 1)
    static let coin = NSColor(calibratedRed: 1.0, green: 0.83, blue: 0.28, alpha: 1)
    static let dirt = NSColor(calibratedRed: 0.55, green: 0.35, blue: 0.18, alpha: 1)
    static let grass = NSColor(calibratedRed: 0.24, green: 0.55, blue: 0.25, alpha: 1)
    static let sky = NSColor(calibratedRed: 0.43, green: 0.78, blue: 1.0, alpha: 1)
}

/// Original procedural pixel characters — not scraped from commercial games.
enum PixelArt {
    static func texture(pixels: [[NSColor?]], scale: CGFloat = 4) -> SKTexture {
        let h = pixels.count
        let w = pixels.map(\.count).max() ?? 0
        let size = NSSize(width: CGFloat(w) * scale, height: CGFloat(h) * scale)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.clear.setFill()
        NSRect(origin: .zero, size: size).fill()
        for (y, row) in pixels.enumerated() {
            for (x, color) in row.enumerated() {
                guard let color else { continue }
                color.setFill()
                NSRect(
                    x: CGFloat(x) * scale,
                    y: CGFloat(h - 1 - y) * scale,
                    width: scale,
                    height: scale
                ).fill()
            }
        }
        image.unlockFocus()
        let tex = SKTexture(image: image)
        tex.filteringMode = .nearest
        return tex
    }

    /// Pip — original green hopper (platformer hero).
    static func pip() -> SKTexture {
        let _ = PixelColor.clear
        let G = PixelColor.sprout
        let D = PixelColor.sproutDark
        let S = PixelColor.skin
        let B = PixelColor.black
        let N: NSColor? = nil
        return texture(pixels: [
            [N, N, G, G, G, G, N, N],
            [N, G, G, G, G, G, G, N],
            [N, D, S, S, S, S, D, N],
            [N, S, B, S, S, B, S, N],
            [N, S, S, S, S, S, S, N],
            [N, N, G, G, G, G, N, N],
            [N, G, G, D, D, G, G, N],
            [N, D, N, N, N, N, D, N],
            [N, N, G, N, N, G, N, N],
            [N, N, D, N, N, D, N, N],
        ])
    }

    /// Nyx — original cyan operative (run-and-gun hero).
    static func nyx() -> SKTexture {
        let C = PixelColor.nyx
        let D = PixelColor.nyxDark
        let S = PixelColor.skin
        let W = PixelColor.white
        let B = PixelColor.black
        let N: NSColor? = nil
        return texture(pixels: [
            [N, N, D, D, D, D, N, N],
            [N, D, C, C, C, C, D, N],
            [N, D, S, S, S, S, D, N],
            [N, S, B, S, S, B, S, N],
            [C, C, C, C, C, C, C, W],
            [N, D, C, C, C, C, D, N],
            [N, D, C, N, N, C, D, N],
            [N, C, N, N, N, N, C, N],
            [N, D, N, N, N, N, D, N],
        ])
    }

    /// Moth ship — original starfighter.
    static func mothShip() -> SKTexture {
        let M = PixelColor.moth
        let D = PixelColor.nyxDark
        let W = PixelColor.white
        let N: NSColor? = nil
        return texture(pixels: [
            [N, N, N, W, W, N, N, N],
            [N, N, M, M, M, M, N, N],
            [N, M, M, W, W, M, M, N],
            [M, M, D, M, M, D, M, M],
            [N, M, M, M, M, M, M, N],
            [N, N, M, N, N, M, N, N],
        ])
    }

    static func crawler() -> SKTexture {
        let R = PixelColor.danger
        let B = PixelColor.black
        let W = PixelColor.white
        let N: NSColor? = nil
        return texture(pixels: [
            [N, R, R, R, R, N],
            [R, W, R, R, W, R],
            [R, B, R, R, B, R],
            [R, R, R, R, R, R],
            [N, R, N, N, R, N],
        ])
    }

    static func coin() -> SKTexture {
        let C = PixelColor.coin
        let D = NSColor(calibratedRed: 0.75, green: 0.55, blue: 0.1, alpha: 1)
        let N: NSColor? = nil
        return texture(pixels: [
            [N, C, C, N],
            [C, D, C, C],
            [C, C, D, C],
            [N, C, C, N],
        ], scale: 3)
    }

    static func blockGrass() -> SKTexture {
        let G = PixelColor.grass
        let D = PixelColor.dirt
        return texture(pixels: [
            [G, G, G, G],
            [G, G, G, G],
            [D, D, D, D],
            [D, D, D, D],
        ], scale: 4)
    }

    static func blockBrick() -> SKTexture {
        let A = NSColor(calibratedRed: 0.72, green: 0.42, blue: 0.22, alpha: 1)
        let B = NSColor(calibratedRed: 0.55, green: 0.30, blue: 0.15, alpha: 1)
        return texture(pixels: [
            [A, A, B, A],
            [A, B, A, A],
            [B, A, A, B],
            [A, A, B, A],
        ], scale: 4)
    }
}
