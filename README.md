# TimeToLevel (TTL)

A Lord of the Rings Online plugin that tracks XP from chat, estimates time to level, and shows your progress in a movable window.

![LOTRO](https://img.shields.io/badge/LOTRO-Plugin-blue)
![Version](https://img.shields.io/badge/version-1.2.3-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## Features

- Tracks character XP from chat messages (`You've earned X xp for a total of Y XP.`)
- Shows XP progress, percent complete, XP/min, XP/hr, and ETA for the current level
- Movable, resizable window with background transparency slider
- Floating **TTL** launcher button (click to open/close, drag to move)
- Sync your in-level XP bar manually when needed
- Persists window position, size, opacity, and per-character progress

## Download

### Option 1: Latest release (recommended)

Download the zip from the [latest release](https://github.com/RMFSonics/lotro-time-to-level/releases/latest), then follow [Installation](docs/INSTALL.md).

### Option 2: Download from GitHub

1. Open [github.com/RMFSonics/lotro-time-to-level](https://github.com/RMFSonics/lotro-time-to-level)
2. Click **Code** → **Download ZIP**
3. Extract and copy the `Plugins/RedMF` folder into your LOTRO plugins directory

See [docs/INSTALL.md](docs/INSTALL.md) for full install steps.

## Quick start

1. Install the plugin (see above)
2. In game: `/plugins load TimeToLevel`
3. Click the **TTL** button or use `/ttl` to view stats
4. Earn XP — the plugin updates automatically from chat

Full command list: [docs/USAGE.md](docs/USAGE.md)

## Requirements

- The Lord of the Rings Online (official client with Lua plugin support)
- No other plugins required

## Project layout

```
Plugins/RedMF/
  TimeToLevel.plugin          ← plugin manifest (required here)
  TimeToLevel/
    Main.lua                    ← entry point, /ttl commands
    Tracker.lua                 ← XP parsing and session tracking
    Window.lua                  ← main UI window
    ToggleButton.lua            ← TTL launcher button
    LevelXpCost.lua             ← XP-to-level table (levels 1–160)
    Settings.lua                ← saved settings
    Util.lua                    ← helpers
    Callbacks.lua               ← event callback utilities
```

## XP data sources

Level XP costs are based on [Lotro-Wiki Character XP Calculation](https://lotro-wiki.com/wiki/Character_XP_Calculation) and the [Level](https://lotro-wiki.com/wiki/Level) table. You can verify in game with the CalcStat plugin: `/calcstat lvlexpcost,<level>`.

## Contributing

Issues and pull requests are welcome. This repo is the public home for the TimeToLevel plugin; more RedMF LOTRO addons may be added as separate projects later.

## License

MIT — see [LICENSE](LICENSE).

## Author

RedMF
