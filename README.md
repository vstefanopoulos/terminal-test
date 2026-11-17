# term-test

A single, dependency-free Bash script that prints a visual test sheet for your terminal. Run it once and you can see, at a glance, how a terminal emulator, color scheme, and font handle text styles, ANSI colors, Unicode, Powerline / Nerd Font glyphs, and ligatures.

It's handy for:

- Comparing terminal emulators (iTerm2, Kitty, WezTerm, Alacritty, Ghostty, Windows Terminal, …)
- Choosing or tuning a color scheme
- Checking that a programming font is legible and properly patched
- Debugging "why does my prompt show boxes/question marks?"

## Quick start

```bash
git clone https://github.com/vstefanopoulos/terminal-test.git
cd terminal-test
./term-test.sh
```

Or run it without cloning:

```bash
curl -fsSL https://raw.githubusercontent.com/vstefanopoulos/terminal-test/main/term-test.sh | bash
```

## Usage

```bash
./term-test.sh [section...]
```

With no arguments every section is printed. Pass one or more section names to show only those:

```bash
./term-test.sh truecolor            # just the 24-bit color gradients
./term-test.sh fonts ligatures      # font legibility + ligatures
./term-test.sh nerd boxes           # Nerd Font icons + Powerline glyphs
```

## Sections

| Section     | What it shows |
|-------------|---------------|
| `styles`    | Bold, dim, italic, underline (single, double, curly, colored), blink, reverse, hidden, strikethrough, overline, and OSC 8 hyperlinks |
| `basic`     | The 16 standard ANSI colors as foreground and background, plus a bold-vs-bright comparison |
| `256`       | The full 256-color palette: system colors, the 6×6×6 color cube, and the grayscale ramp |
| `truecolor` | Smooth 24-bit RGB and hue gradients, plus your `COLORTERM`, `TERM`, and `TERM_PROGRAM` values |
| `fonts`     | Full alphabet, digits, punctuation, easily confused characters (`0O`, `1lI`, `rn`/`m`…), and a monospace alignment check including CJK |
| `unicode`   | Greek, accented Latin, Cyrillic, Hebrew, Arabic, CJK, math symbols, arrows, block elements, Braille, and emoji (including ZWJ sequences, skin tones, and flags) |
| `boxes`     | Thin, double, rounded, and heavy box drawing, plus a sample Powerline prompt segment |
| `nerd`      | Nerd Font icons for files, languages, operating systems, and UI elements |
| `ligatures` | Common programming ligatures (`->`, `=>`, `!=`, `===`, `<=>`, …) |
| `sample`    | Realistic CLI output — `git status`, test runner results, log levels, a diff, and a progress bar — to judge a theme in context |

## What to look for

- **Gradients look banded or stepped** in `truecolor` → your terminal (or `tmux`/`screen`) isn't passing through 24-bit color. Check that `COLORTERM=truecolor` is set.
- **Boxes, `?`, or blank spaces** in `nerd` or `boxes` → your font isn't a [Nerd Font](https://www.nerdfonts.com/) or the terminal isn't using it.
- **Misaligned `|` bars** in the `fonts` alignment check → the font isn't truly monospaced, or wide characters (CJK/emoji) aren't rendered at 2 cells.
- **Ligatures appear as separate characters** → your font doesn't support them, or ligatures are disabled in your terminal settings.
- **Styles render as plain text** (e.g. curly underline, overline) → your terminal doesn't support that escape sequence. Not every terminal supports every style; that's expected.

## Requirements

- Bash (3.2+, so the macOS default works)
- `seq` and, optionally, `tput` — both present on macOS and nearly all Linux distributions
- A terminal emulator to test 🙂

No other dependencies.

## Contributing

Issues and pull requests are welcome — e.g. new sections, additional glyphs, or compatibility fixes for other shells and terminals.

## License

[MIT](LICENSE)
