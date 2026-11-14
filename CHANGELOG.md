# Changelog

## v1.4.3 (2026-11-14)
- **High-res pictures are sharp again** (PS2, PS1 640x480, ShaderGlass captures). v1.4.1 made every picture
  wider than 320 px as soft as a 256 picture. Now only pictures up to 288 lines and 321-599 px wide
  (SNES 512, PS1 368-512) keep the v1.4.1 behaviour; everything bigger, including small ShaderGlass window
  captures, uses the v1.4 filter again (pixel-identical to v1.4). Reported on Reddit (PCSX2 + ShaderGlass, ROG Ally).
- **PSP at 4x internal resolution** (1088 lines): 272 scanlines again (was read as 5x and drawn with 218).
- **Bonus: GBA color fix** (`presets/GBA/`, `shaders/gba-comfort-color.slang`): tones down the neon colors of
  GBA games. Light / medium / strong, color only (1 pass) or with Real CRT Phosphor (15 passes).

## v1.4.1 (2026-11-12)
- The picture no longer turns sharper or shifts right when a game switches to a wider mode
  (e.g. Seiken Densetsu 3 dialog boxes, SNES 256 -> 512). Glow keeps its size on screen; wide modes use the
  256 signal filter stretched to the wider grid.

## v1.4 (2026-11-06)
- Upscale presets for 3D games (`-up2x / -up3x / -up4x` in `presets/4K` and `presets/Ally`): the first pass
  averages N x N back to the original size, so the rest of the shader is as light as at 1x. Same picture.

## v1.3
- Optional screen curvature (off by default), bent before the scanlines and stripes are drawn.

## v1.2 (2026-11-05)
- Optional phosphor afterglow (motion trail), off by default.

## v1.1.1 (2026-11-04)
- Faster on phone and tablet GPUs (gamma decoding moved to the game-resolution pass), same picture.

## v1.1 (2026-10-27)
- **Slot Mask** added (`Mask type: 0 Grille / 1 Slot`).
  - Slots follow the scanlines (no beating between the two rhythms), straight slot sides,
    gap depth control so the slot pattern does not read as dithering.
  - New parameters: Slot follows scanlines, Slot height in scanlines, Slot vertical pitch adjust,
    Slot straight sides, Slot gap depth (plus gap fraction / edge softness / highlight fill).
- Faster: post-blur weights computed once per vertex instead of per pixel.
- Presets: Aperture Grille pitch 4.5 for 4K and ROG Ally, `-slot` presets (pitch 3), `-ps2-2d` (pitch 1.5).
- Cleaner parameter menu: section headers and indented items.
- Terms of use and AI-generated work notice added (LICENSE.txt / LICENSE_KR.txt).

## v1.0 (2026-10-27)
- First public release (formerly the private "gunkun-rgb" shader).
- Light comes only from R, G, B phosphor stripes; stripe width follows brightness;
  highlights melt into glow; total light preserved.
- Presets for 32" 4K monitor and ROG Ally (SFC, PS1, PS2, PSP).
