# Installation

TimeToLevel uses the same folder layout as most LOTRO plugins (Songbook, HugeBag, etc.):

```
Plugins/
  TimeToLevel/
    TimeToLevel.plugin          ← manifest
    TimeToLevel/
      Main.lua                  ← entry point
      Tracker.lua
      ...
```

Package path: `TimeToLevel.TimeToLevel.Main` → `Plugins/TimeToLevel/TimeToLevel/Main.lua`

## Where LOTRO plugins live

Default path (Windows):

```
Documents\The Lord of the Rings Online\Plugins\
```

## Install from a release zip (recommended)

1. Download the latest zip from [Releases](https://github.com/RMFSonics/lotro-time-to-level/releases/latest).
2. Extract the zip.
3. Copy the entire **`TimeToLevel`** folder into your LOTRO **`Plugins`** folder.
4. You should end up with `Plugins\TimeToLevel\TimeToLevel.plugin` and `Plugins\TimeToLevel\TimeToLevel\Main.lua`.
5. In game: `/plugins load TimeToLevel`

**Do not** put `TimeToLevel.plugin` directly in `Plugins\` (root). It belongs inside `Plugins\TimeToLevel\`.

## Install from Download ZIP (main branch)

1. On GitHub, click **Code** → **Download ZIP**.
2. Extract and copy the **`TimeToLevel`** folder into `Plugins\`.

## Verify installation

After loading:

```
TimeToLevel v1.2.6 loaded. Click TTL to toggle, drag to move.
```

## Troubleshooting

| Problem | Fix |
|--------|-----|
| **`Unable to resolve package "TimeToLevel.Main"`** | Old flat install. Use nested layout: `Plugins/TimeToLevel/TimeToLevel/Main.lua` and package `TimeToLevel.TimeToLevel.Main` (v1.2.5+). |
| **`Unable to resolve package "TimeToLevel.TimeToLevel.Main"`** | Missing nested folder. Confirm `Main.lua` is in `Plugins/TimeToLevel/TimeToLevel/`, not `Plugins/TimeToLevel/`. |
| Plugin not in list | Confirm `TimeToLevel.plugin` is in `Plugins/TimeToLevel/`, not inside the inner `TimeToLevel/` code folder. |

## Uninstall

1. `/plugins unload TimeToLevel`
2. Delete the `Plugins/TimeToLevel/` folder.
