# Pixel Vault 36

Original retro games for Mac — **native `.app`**, not a web pack.

All titles, characters (**Pip**, **Nyx**, **Star Moth**), and art are original. This is **not** a ROM dump of Mario, Contra, or any commercial NES game, and we do not scrape copyrighted sprites from Google.

## Play on Mac

```bash
cd native
chmod +x build.sh
./build.sh
open ../dist/PixelVault.app
```

Or double-click `dist/PixelVault.app` after building.

### Controls

| Key | Action |
|-----|--------|
| Arrow keys / WASD | Move / navigate menu |
| Z or Space | Jump / shoot / confirm |
| Enter | Start selected game |
| `[` `]` | Menu page |
| Esc | Back to vault menu |

## What’s inside

36 original catalog entries:

1. **Sprout Jump** — platformer (Pip)
2. **Neon Brigade** — run-and-gun (Nyx)
3. **Star Moth** — space shooter
4. **Tile Tide** — sliding puzzle
5. **Pulse Paddle** / **River Raft** — arcade
6–36. Unique-themed arcade templates (colors, speed, titles per game)

Signature games are handcrafted; later slots use a playable arcade shell so the full vault is selectable today. We can deepen any title next.

## Requirements

- macOS 13+
- Xcode Command Line Tools (`swiftc`, SpriteKit)

## License

MIT — see `LICENSE`.
