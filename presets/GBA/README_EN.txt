Real CRT Phosphor bonus: GBA color fix (GBA Comfort Color)

Tones down the strong, neon-like colors of GBA games, so they are easy on the eyes on a modern screen.
GBA screens were dark, so many games were drawn with very strong, bright colors. On a bright modern screen,
space looks bright blue and greens look neon. This calms those strong colors down.
(It is not an exact copy of the real GBA screen. It is a color fix for comfortable play.)
Checked with: Super Robot Wars A / R / OG / D, Sword of Mana, Final Fantasy VI Advance.

Six presets (this folder):
  Color only (1 pass, light for handhelds)   Color + CRT (Real CRT Phosphor, 15 passes)
  gba-light.slangp                           gba-crt-light.slangp
  gba-medium.slangp                          gba-crt-medium.slangp
  gba-strong.slangp                          gba-crt-strong.slangp

Which strength?
- LIGHT: only the very strongest colors are toned down; the rest stays as the game drew it.
- MEDIUM: neon colors almost gone, picture a little calmer. Fine for most games (even Super Robot Wars A).
- STRONG: for games full of neon colors (e.g. Super Robot Wars A). Calmer and darker.
- Not sure? Start with MEDIUM.

How to use: load one of these presets in a GBA game (Quick Menu > Shaders > Load >
shaders_slang/real-crt-phosphor/presets/GBA/), then Save Core Preset or Save Game Preset.
Turn off mGBA's own color correction core option. The CRT presets keep the smear low, like an LCD
(tuned on 4K, MASK_PITCH 5.5 on every screen). Use these presets rather than "Prepend", which can apply the color twice.
The shader is shaders/gba-comfort-color.slang; all its parameters start with GBA_.
