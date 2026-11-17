#!/usr/bin/env bash
# term-test.sh — preview fonts, glyphs, and ANSI colors to evaluate terminal profiles.
# Usage: ./term-test.sh [section...]
# Sections: styles basic 256 truecolor fonts unicode boxes nerd ligatures sample  (default: all)

ESC=$'\033'
R="${ESC}[0m"

header() {
  printf '\n%s━━ %s %s%s\n\n' "${ESC}[1;38;5;81m" "$1" \
    "$(printf '━%.0s' $(seq 1 $((60 - ${#1}))))" "$R"
}

section_styles() {
  header "Text Styles"
  printf '  %-22s %s\n' "Normal"            "The quick brown fox jumps over the lazy dog"
  printf '  %-22s %s\n' "Bold"              "${ESC}[1mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Dim / Faint"       "${ESC}[2mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Italic"            "${ESC}[3mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Bold Italic"       "${ESC}[1;3mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Underline"         "${ESC}[4mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Double underline"  "${ESC}[21mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Curly underline"   "${ESC}[4:3mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Colored underline" "${ESC}[4:3;58;2;255;80;80mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Blink"             "${ESC}[5mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Reverse"           "${ESC}[7mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Hidden"            "${ESC}[8mThe quick brown fox jumps over the lazy dog${R} (hidden)"
  printf '  %-22s %s\n' "Strikethrough"     "${ESC}[9mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Overline"          "${ESC}[53mThe quick brown fox jumps over the lazy dog${R}"
  printf '  %-22s %s\n' "Hyperlink (OSC 8)" "${ESC}]8;;https://example.com${ESC}\\Click me → example.com${ESC}]8;;${ESC}\\"
}

section_basic() {
  header "16 ANSI Colors (fg on default / bg)"
  local names=(Black Red Green Yellow Blue Magenta Cyan White)
  local i
  printf '  %-9s %-14s %-14s %-12s %-12s\n' "" "normal" "bright" "bg" "bright bg"
  for i in 0 1 2 3 4 5 6 7; do
    printf '  %-9s %s%-14s%s %s%-14s%s %s%-12s%s %s%-12s%s\n' "${names[$i]}" \
      "${ESC}[3${i}m"  " ${names[$i]}" "$R" \
      "${ESC}[9${i}m"  " ${names[$i]}" "$R" \
      "${ESC}[4${i}m"  ""             "$R" \
      "${ESC}[10${i}m" ""             "$R"
  done
  echo
  printf '  Bold vs bright:  '
  for i in 0 1 2 3 4 5 6 7; do printf '%s■%s%s■%s ' "${ESC}[3${i}m" "$R" "${ESC}[1;3${i}m" "$R"; done
  printf '\n  Default fg/bg:   %sforeground%s  %s reverse %s\n' "${ESC}[39m" "$R" "${ESC}[7m" "$R"
}

section_256() {
  header "256-Color Palette"
  local i row col c
  printf '  '
  for i in $(seq 0 15); do printf '%s %3d %s' "${ESC}[48;5;${i}m${ESC}[38;5;$(( i < 8 && i != 7 ? 15 : 0 ))m" "$i" "$R"; done
  echo; echo
  for row in $(seq 0 5); do
    printf '  '
    for col in $(seq 0 35); do
      c=$((16 + row * 36 + col))
      printf '%s  %s' "${ESC}[48;5;${c}m" "$R"
    done
    echo
  done
  echo
  printf '  '
  for i in $(seq 232 255); do printf '%s   %s' "${ESC}[48;5;${i}m" "$R"; done
  echo
}

section_truecolor() {
  header "24-bit Truecolor"
  local cols=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
  local w=$(( cols > 84 ? 76 : cols - 8 )) i r g b
  for ch in red green blue; do
    printf '  %-6s' "$ch"
    for i in $(seq 0 $((w - 1))); do
      v=$(( i * 255 / (w - 1) ))
      case $ch in red) r=$v g=0 b=0;; green) r=0 g=$v b=0;; blue) r=0 g=0 b=$v;; esac
      printf '%s %s' "${ESC}[48;2;${r};${g};${b}m" "$R"
    done
    echo
  done
  printf '  %-6s' "hue"
  for i in $(seq 0 $((w - 1))); do
    h=$(( i * 1530 / w )); s=$(( h / 255 )); f=$(( h % 255 ))
    case $s in
      0) r=255 g=$f b=0;; 1) r=$((255-f)) g=255 b=0;; 2) r=0 g=255 b=$f;;
      3) r=0 g=$((255-f)) b=255;; 4) r=$f g=0 b=255;; *) r=255 g=0 b=$((255-f));;
    esac
    printf '%s▀%s' "${ESC}[38;2;${r};${g};${b}m${ESC}[48;2;$((r/2));$((g/2));$((b/2))m" "$R"
  done
  echo
  printf '\n  COLORTERM=%s   TERM=%s   TERM_PROGRAM=%s\n' "${COLORTERM:-unset}" "${TERM:-unset}" "${TERM_PROGRAM:-unset}"
}

section_fonts() {
  header "Font Legibility"
  echo "  ABCDEFGHIJKLMNOPQRSTUVWXYZ   abcdefghijklmnopqrstuvwxyz"
  echo "  0123456789   !@#\$%^&*()_+-=[]{}|;':\",./<>?\`~\\"
  echo
  echo "  Confusables:  0O o  1lI| i!  5S 2Z 8B  rn m  cl d  vv w  {} () []  ,. ;:  '\"\`"
  echo "  Zero/oh:      0O0O0O   Ohm 0hm   10l1Il"
  echo
  echo "  Alignment (monospace check):"
  echo "    |iiiiiiiiii|"
  echo "    |WWWWWWWWWW|"
  echo "    |0123456789|"
  echo "    |αβγδεζηθικ|"
  echo "    |日本語テキスト|  ← CJK should be exactly 2 cells each (14 cells)"
}

section_unicode() {
  header "Unicode & Emoji"
  echo "  Greek:      Αα Ββ Γγ Δδ Εε Λλ Μμ Ππ Σσς Ωω   Καλημέρα κόσμε"
  echo "  Accents:    àáâãäå çèéêë ñ øœ ß ÿ  Ångström naïve façade"
  echo "  Cyrillic:   Привет мир    Hebrew: שלום    Arabic: مرحبا"
  echo "  CJK:        你好世界  こんにちは  안녕하세요"
  echo "  Math:       ∀∃∄ ∈∉ ∑∏∫∮ √∞ ≈≠≤≥ ±×÷ ∂∇ ⊂⊃⊆⊇ ∧∨¬ ⇒⇔ ℝℕℤℚℂ"
  echo "  Arrows:     ← ↑ → ↓ ↔ ↕ ⇐ ⇑ ⇒ ⇓ ⟵ ⟶ ↩ ↪ ⤴ ⤵"
  echo "  Symbols:    ✓ ✗ ✔ ✘ ★ ☆ ♠ ♣ ♥ ♦ ⚠ ⚡ ☀ ☁ ☂ ♪ ♫ © ® ™ § ¶ € £ ¥ ₿"
  echo "  Blocks:     ░▒▓█ ▁▂▃▄▅▆▇█ ▏▎▍▌▋▊▉ ▖▗▘▙▚▛▜▝▞▟"
  echo "  Braille:    ⠁⠃⠇⡇⣇⣧⣷⣿  ⣾⣽⣻⢿⡿⣟⣯⣷ (spinner)"
  echo "  Emoji:      😀 🚀 🔥 ✅ ❌ 📦 🐍 🦀 🐳 ☕ 🎉 👍🏽 👨‍👩‍👧 🇬🇷"
  echo "  Emoji width:|😀|🚀|🔥|  ← each emoji should take 2 cells"
}

section_boxes() {
  header "Box Drawing & Powerline"
  echo "  ┌──────┬──────┐  ╔══════╦══════╗  ╭──────┬──────╮  ┏━━━━━━┳━━━━━━┓"
  echo "  │ thin │ box  │  ║ dbl  ║ box  ║  │round │ box  │  ┃ bold ┃ box  ┃"
  echo "  ├──────┼──────┤  ╠══════╬══════╣  ├──────┼──────┤  ┣━━━━━━╋━━━━━━┫"
  echo "  │      │      │  ║      ║      ║  │      │      │  ┃      ┃      ┃"
  echo "  └──────┴──────┘  ╚══════╩══════╝  ╰──────┴──────╯  ┗━━━━━━┻━━━━━━┛"
  echo "  Dashed: ┄┄┄ ┅┅┅ ┈┈┈ ┉┉┉ ╌╌ ╍╍  ┆ ┇ ┊ ┋   Diagonals: ╱╲╳"
  echo
  local PL=$'\xee\x82\xb0' PLt=$'\xee\x82\xb1' PR=$'\xee\x82\xb2' PRt=$'\xee\x82\xb3' BR=$'\xee\x82\xa0'
  local RD=$'\xee\x82\xb4' LD=$'\xee\x82\xb6'
  local a="${ESC}[38;5;235;48;5;39m" b="${ESC}[38;5;39;48;5;141m" c="${ESC}[38;5;235;48;5;141m"
  local d="${ESC}[38;5;141;48;5;214m" e="${ESC}[38;5;235;48;5;214m" f="${ESC}[38;5;214m"
  printf '  Powerline: %s user %s%s%s ~/projects %s%s%s %s main %s%s%s\n' \
    "$a" "$b" "$PL" "$c" "$d" "$PL" "$e" "$BR" "$R$f" "$PL" "$R"
  printf '  Glyphs:    %s %s %s %s %s %s %s   (E0B0 E0B1 E0B2 E0B3 E0B4 E0B6 E0A0)\n' \
    "$PL" "$PLt" "$PR" "$PRt" "$RD" "$LD" "$BR"
}

section_nerd() {
  header "Nerd Font Icons (need a patched font)"
  printf '  Files:  %s folder  %s file  %s git  %s github  %s docker  %s npm\n' \
    $'\xef\x81\xbb' $'\xef\x85\x9b' $'\xef\x87\x93' $'\xef\x82\x9b' $'\xef\x8c\x88' $'\xee\x9c\x9e'
  printf '  Langs:  %s python  %s js  %s ts  %s rust  %s go  %s ruby  %s java  %s swift\n' \
    $'\xee\x9c\xbc' $'\xee\x9d\x8e' $'\xee\x98\xa8' $'\xee\x9e\xa8' $'\xee\x98\xa6' $'\xee\x9c\xb9' $'\xee\x9c\xb8' $'\xee\x9d\x95'
  printf '  OS:     %s apple  %s linux  %s windows  %s ubuntu  %s arch\n' \
    $'\xef\x85\xb9' $'\xef\x85\xbc' $'\xef\x85\xba' $'\xef\x8c\x9b' $'\xef\x8c\x83'
  printf '  UI:     %s check  %s close  %s warn  %s info  %s clock  %s gear  %s search  %s lock\n' \
    $'\xef\x80\x8c' $'\xef\x80\x8d' $'\xef\x81\xb1' $'\xef\x81\x9a' $'\xef\x80\x97' $'\xef\x80\x93' $'\xef\x80\x82' $'\xef\x80\xa3'
  echo "  If you see boxes/? above, your font is not a Nerd Font."
}

section_ligatures() {
  header "Ligatures (Fira Code, JetBrains Mono, Cascadia…)"
  echo "  -> => <- <= >= != == === !== <=> |> <| :: ::: ... .. ?. ?? && || //"
  echo "  /* */ <!-- --> www ++ -- ** ~> <~ >>= =<< |= ^= #{ #[ ]# 0x1F"
}

section_sample() {
  header "Sample CLI Output"
  local g="${ESC}[32m" y="${ESC}[33m" rd="${ESC}[31m" bl="${ESC}[34m" m="${ESC}[35m" cy="${ESC}[36m"
  local bd="${ESC}[1m" dm="${ESC}[2m"
  printf '  %s❯%s %sgit%s status\n' "$g" "$R" "$bd" "$R"
  printf '  On branch %s%smain%s\n' "$bd" "$cy" "$R"
  printf '  Changes to be committed:\n'
  printf '      %smodified:   src/app.ts%s\n' "$g" "$R"
  printf '      %snew file:   src/utils.ts%s\n' "$g" "$R"
  printf '  Changes not staged:\n'
  printf '      %smodified:   README.md%s\n' "$rd" "$R"
  echo
  printf '  %s❯%s %snpm%s test\n' "$g" "$R" "$bd" "$R"
  printf '   %s PASS %s src/app.test.ts %s(42 ms)%s\n' "${ESC}[42;30;1m" "$R" "$dm" "$R"
  printf '   %s FAIL %s src/utils.test.ts\n' "${ESC}[41;97;1m" "$R"
  printf '     %s● parse › handles empty input%s\n' "$rd$bd" "$R"
  printf '       Expected: %s"ok"%s\n' "$g" "$R"
  printf '       Received: %s"error"%s\n' "$rd" "$R"
  echo
  printf '  %s[INFO]%s  Server started on %shttp://localhost:3000%s\n' "$bl$bd" "$R" "${ESC}[4m$cy" "$R"
  printf '  %s[WARN]%s  Deprecated config key %s"legacyMode"%s\n' "$y$bd" "$R" "$m" "$R"
  printf '  %s[ERROR]%s Connection refused %s(retry 3/5)%s\n' "$rd$bd" "$R" "$dm" "$R"
  echo
  printf '  %s-%s const x = %s1%s;\n' "$rd" "$R" "$m" "$R"
  printf '  %s+%s const x = %s2%s; %s// updated%s\n' "$g" "$R" "$m" "$R" "$dm${ESC}[3m" "$R"
  echo
  printf '  Progress: %s████████████████%s░░░░░░░░ %s67%%%s  ⠹ building…\n' "$g" "$dm" "$R$bd" "$R"
}

ALL="styles basic 256 truecolor fonts unicode boxes nerd ligatures sample"
for s in ${@:-$ALL}; do
  if type "section_$s" >/dev/null 2>&1; then "section_$s"
  else echo "Unknown section: $s (available: $ALL)" >&2; fi
done
printf '\n%s\n' "${R}"
