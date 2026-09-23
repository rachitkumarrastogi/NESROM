import Foundation

enum GameGenre: String {
    case action
    case platform
    case puzzle
    case arcade
    case sports
}

struct GameInfo {
    let id: Int
    let title: String
    let blurb: String
    let genre: GameGenre
    let sceneKey: String
}

enum GameCatalog {
    static let all: [GameInfo] = [
        GameInfo(id: 1, title: "Sprout Jump", blurb: "Pip hops platforms for the golden pods.", genre: .platform, sceneKey: "sprout"),
        GameInfo(id: 2, title: "Neon Brigade", blurb: "Nyx blasts through the neon jungle.", genre: .action, sceneKey: "neon"),
        GameInfo(id: 3, title: "Star Moth", blurb: "Dodge rocks, shoot the swarm.", genre: .arcade, sceneKey: "moth"),
        GameInfo(id: 4, title: "Tile Tide", blurb: "Slide tiles back into order.", genre: .puzzle, sceneKey: "tiles"),
        GameInfo(id: 5, title: "Pulse Paddle", blurb: "Bounce the pulse brick by brick.", genre: .arcade, sceneKey: "paddle"),
        GameInfo(id: 6, title: "River Raft", blurb: "Steer clear of the river snags.", genre: .arcade, sceneKey: "raft"),
        GameInfo(id: 7, title: "Hex Nest", blurb: "Stack hexes before the nest fills.", genre: .puzzle, sceneKey: "hex"),
        GameInfo(id: 8, title: "Dash Mole", blurb: "Tunnel left-right, grab gems.", genre: .platform, sceneKey: "mole"),
        GameInfo(id: 9, title: "Sky Hook", blurb: "Swing from cloud to cloud.", genre: .platform, sceneKey: "hook"),
        GameInfo(id: 10, title: "Volt Dual", blurb: "Two lanes, one spark — survive.", genre: .action, sceneKey: "volt"),
        GameInfo(id: 11, title: "Crystal Dig", blurb: "Mine down, watch the cave-ins.", genre: .arcade, sceneKey: "dig"),
        GameInfo(id: 12, title: "Orbit Keep", blurb: "Guard the keep from orbit debris.", genre: .arcade, sceneKey: "orbit"),
        GameInfo(id: 13, title: "Mirror Lab", blurb: "Match the mirrored pattern.", genre: .puzzle, sceneKey: "mirror"),
        GameInfo(id: 14, title: "Bone Bridge", blurb: "Cross crumbling bone planks.", genre: .platform, sceneKey: "bone"),
        GameInfo(id: 15, title: "Frost Bite", blurb: "Slide on ice, collect flakes.", genre: .platform, sceneKey: "frost"),
        GameInfo(id: 16, title: "Cannonade", blurb: "Angle the cannon, pop balloons.", genre: .arcade, sceneKey: "cannon"),
        GameInfo(id: 17, title: "Quiet Grove", blurb: "Sneak past the grove wardens.", genre: .action, sceneKey: "grove"),
        GameInfo(id: 18, title: "Beat Grid", blurb: "Hit pads on the beat.", genre: .arcade, sceneKey: "beat"),
        GameInfo(id: 19, title: "Summit Kick", blurb: "Soccer on a tiny mountain pitch.", genre: .sports, sceneKey: "summit"),
        GameInfo(id: 20, title: "Tide Pool", blurb: "Catch critters before tide rises.", genre: .arcade, sceneKey: "pool"),
        GameInfo(id: 21, title: "Lantern Run", blurb: "Keep the lantern lit in the dark.", genre: .platform, sceneKey: "lantern"),
        GameInfo(id: 22, title: "Gearworks", blurb: "Time jumps through spinning gears.", genre: .platform, sceneKey: "gear"),
        GameInfo(id: 23, title: "Paint Fill", blurb: "Flood-fill the canvas clean.", genre: .puzzle, sceneKey: "paint"),
        GameInfo(id: 24, title: "Sparrow Cup", blurb: "Race tiny sparrows around the track.", genre: .sports, sceneKey: "sparrow"),
        GameInfo(id: 25, title: "Shadow Tag", blurb: "Tag your shadow twin.", genre: .action, sceneKey: "shadow"),
        GameInfo(id: 26, title: "Bubble Lift", blurb: "Ride bubbles up the shaft.", genre: .arcade, sceneKey: "bubble"),
        GameInfo(id: 27, title: "Rune Lock", blurb: "Rotate runes into the seal.", genre: .puzzle, sceneKey: "rune"),
        GameInfo(id: 28, title: "Cliff Trail", blurb: "Hang-glide the cliff thermals.", genre: .arcade, sceneKey: "cliff"),
        GameInfo(id: 29, title: "Pepper Duo", blurb: "Hot-potato pass between pads.", genre: .sports, sceneKey: "pepper"),
        GameInfo(id: 30, title: "Null Field", blurb: "Drain voids before they spread.", genre: .puzzle, sceneKey: "null"),
        GameInfo(id: 31, title: "Copper Cart", blurb: "Minecart jumps and switches.", genre: .platform, sceneKey: "cart"),
        GameInfo(id: 32, title: "Aurora Drift", blurb: "Surf the aurora ribbon.", genre: .arcade, sceneKey: "aurora"),
        GameInfo(id: 33, title: "Scout Badge", blurb: "Collect badges, avoid traps.", genre: .action, sceneKey: "scout"),
        GameInfo(id: 34, title: "Whirl Seed", blurb: "Plant seeds in the whirlwind.", genre: .puzzle, sceneKey: "whirl"),
        GameInfo(id: 35, title: "Iron Relay", blurb: "Pass the baton around the oval.", genre: .sports, sceneKey: "relay"),
        GameInfo(id: 36, title: "Zenith Gate", blurb: "Final gate — survive the gauntlet.", genre: .action, sceneKey: "zenith"),
    ]

    static func scene(for key: String, size: CGSize) -> GameSceneBase {
        switch key {
        case "sprout": return SproutJumpScene(size: size)
        case "neon": return NeonBrigadeScene(size: size)
        case "moth": return StarMothScene(size: size)
        case "tiles": return TileTideScene(size: size)
        case "paddle": return PulsePaddleScene(size: size)
        case "raft": return RiverRaftScene(size: size)
        default:
            return ArcadeTemplateScene(size: size, info: all.first { $0.sceneKey == key }!)
        }
    }
}
