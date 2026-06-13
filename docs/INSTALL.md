# Installation

TimeToLevel installs like any standard LOTRO Lua plugin. The manifest file **must** sit directly in your **`Plugins`** folder, not inside the `TimeToLevel` subfolder.

## Where LOTRO plugins live

Default path (Windows):

```
Documents\The Lord of the Rings Online\Plugins\
```

Your finished layout should look like this:

```
Plugins/
  TimeToLevel.plugin
  TimeToLevel/
    Main.lua
    Callbacks.lua
    Util.lua
    LevelXpCost.lua
    Tracker.lua
    Window.lua
    Settings.lua
    ToggleButton.lua
```

## Install from a release zip (recommended)

1. Download **TimeToLevel-v1.2.4.zip** from [Releases](https://github.com/RMFSonics/lotro-time-to-level/releases/latest).
2. Extract the zip.
3. Copy **`TimeToLevel.plugin`** and the **`TimeToLevel`** folder into your LOTRO **`Plugins`** folder.
4. Launch LOTRO and load the plugin:

```
/plugins load TimeToLevel
```

## Install from Download ZIP (main branch)

1. On GitHub, click **Code** → **Download ZIP**.
2. Extract the archive.
3. Copy **`TimeToLevel.plugin`** and the **`TimeToLevel`** folder from the extracted repo into your LOTRO **`Plugins`** folder.
4. In game: `/plugins load TimeToLevel`

## Install from git

```bash
git clone https://github.com/RMFSonics/lotro-time-to-level.git
```

Copy **`TimeToLevel.plugin`** and the **`TimeToLevel`** folder into your LOTRO **`Plugins`** directory.

## Verify installation

After loading, you should see in chat:

```
TimeToLevel v1.2.4 loaded. Click TTL to toggle, drag to move.
```

You should also see a small **TTL** button on screen.

## Troubleshooting

| Problem | Fix |
|--------|-----|
| Plugin does not appear in list | Confirm `TimeToLevel.plugin` is in `Plugins/`, not `Plugins/TimeToLevel/` |
| Load fails / Lua error | Reload with `/plugins unload TimeToLevel` then `/plugins load TimeToLevel` |
| XP not updating | Make sure XP chat is visible; try `/ttl debug` to log XP lines |
| Progress bar wrong mid-level | Use **Sync to XP bar** in the window or `/ttl sync <current> [required]` |

## Uninstall

1. `/plugins unload TimeToLevel`
2. Delete `Plugins/TimeToLevel.plugin` and `Plugins/TimeToLevel/`

Saved settings are stored in LOTRO plugin data and are removed when you delete the plugin data for the account/character (optional cleanup via plugin manager if available).
