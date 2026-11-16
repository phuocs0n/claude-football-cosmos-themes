# Football & Cosmos — Claude Desktop Themes

Five themes for the [Claude Desktop Themes](https://github.com/0toshigami/claude-desktop-themes) mod (`themes-for-claude`), each made from one painting or photo.
The picture fills the whole window: bright on the **new chat** page, dimmed behind the text inside a conversation.

Năm theme cho mod Claude Desktop Themes, mỗi theme làm từ một bức ảnh. Ảnh phủ kín cả cửa sổ: hiện rõ ở trang **New chat**, và làm tối bớt phía sau chữ khi đang chat.

| Theme | Picture | Colors | Mood |
|---|---|---|---|
| **Albiceleste** | Sky-blue & white stripes, stadium lights | `#0e1a2e` · `#eef4fb` · `#74b9ea` | Floodlights flare on tools, gold stars when done, confetti |
| **Crimson Seventeen** | Crimson shirt, gold 17, green pitch | `#1c0d10` · `#f7ebe6` · `#f2c230` | Red/green confetti, a heartbeat while waiting |
| **Canary Samba** | Canary yellow, green & blue flags | `#fff8db` · `#10301e` · `#1c5fc4` | Light theme, bouncy, Clawd dances |
| **Cosmic Cliffs** | Copper nebula cliffs, eight-point stars | `#0a1024` · `#e8eefc` · `#f2a24e` | Twinkling star field, a star flares on each tool |
| **Spartan Sunset** | Bronze warrior, stormy sunset sea | `#17120f` · `#f2e7d5` · `#e8793e` | Serif font, rising embers, Greek key on the composer |

Every theme also reacts to Claude: a flash while a tool runs, a red edge and a shake on an error,
a slow breath while Claude waits for you. All motion respects *reduce motion*.

## Install / Cài đặt

You need the **themes-for-claude** mod installed in Claude Desktop first.

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/phuocs0n/claude-football-cosmos-themes/main/install.ps1 | iex
```

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/phuocs0n/claude-football-cosmos-themes/main/install.sh | sh
```

Or clone the repo and run `install.ps1` / `install.sh`. They copy `themes/*.json` and `themes/*.css` into
`~/.claude/themes-for-claude/`, and `commands/themes.md` into `~/.claude/commands/`.

Why the command file: the mod registers `/themes` only once a chat has started, so a brand-new chat's slash menu
did not list it. The file makes `/themes` show in every chat; the mod's own hook still answers it and opens the strip.

Then in Claude Desktop run **`/themes`** and pick a theme in the **Yours** tab — no restart needed.

## Layout

```
themes/<id>.json   colors, font, corners, shadows, tile picture
themes/<id>.css    decorations, reactions, the full-window picture (embedded as a data URL)
commands/themes.md   makes /themes show in every chat's slash menu
tools/embed_photos.py   re-embeds the pictures: python tools/embed_photos.py <folder with the pictures>
```

The mod refuses a stylesheet over 200,000 characters, so each picture is a compressed JPEG sized to fit.
