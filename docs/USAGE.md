# Usage

## Loading and unloading

```
/plugins load TimeToLevel
/plugins unload TimeToLevel
```

## Chat commands

| Command | Description |
|---------|-------------|
| `/ttl` | Print current stats to chat |
| `/ttl show` | Show the main window |
| `/ttl hide` | Hide the main window |
| `/ttl toggle` | Toggle main window visibility |
| `/ttl reset` | Reset session stats for the current level |
| `/ttl sync <cur> [need]` | Match your in-level XP bar (current progress and optional XP required) |
| `/ttl debug` | Toggle logging of XP-related chat lines |
| `/ttl button show` | Show the TTL launcher button |
| `/ttl button hide` | Hide the TTL launcher button |
| `/ttl button toggle` | Toggle TTL launcher button visibility |

### Sync examples

If your XP bar shows **12,770 / 19,845** at level 22:

```
/ttl sync 12770 19845
```

If the required amount is already correct from the XP table, you can omit it:

```
/ttl sync 12770
```

## Main window

- **Drag** the title bar to move the window (position is saved).
- **Resize** using the grip in the bottom-right corner.
- **Background alpha** slider adjusts window transparency.
- **Cur / Need** fields plus **Sync to XP bar** let you align with your XP bar without waiting for chat.

The window shows:

- Current level and target level
- XP progress and percentage
- Time spent on this level and ETA
- XP per minute and XP per hour

## TTL launcher button

- **Click** — open or close the main window
- **Drag** — move the button anywhere on screen

Hide it with `/ttl button hide` if you prefer using chat commands only.

## How XP tracking works

LOTRO does not expose character XP directly to plugins. TimeToLevel reads XP from chat when you earn it:

```
You've earned 115 xp for a total of 122,903 XP.
```

The **total** in chat is lifetime/cumulative XP, not in-level bar progress. The plugin tracks in-level progress by summing gains during the session and optional sync.

Lines from Legendary items, Reward Track, and crafting XP are ignored.

## Settings persistence

| Setting | Scope |
|---------|--------|
| Window position, size, opacity, visibility | Account |
| TTL button position and visibility | Account |
| XP session progress for current level | Character |

## Tips

- On first use mid-level, sync once so the bar matches your UI.
- After a level-up, tracking resets automatically for the new level.
- Compare level XP costs with CalcStat: `/calcstat lvlexpcost,<level>`
