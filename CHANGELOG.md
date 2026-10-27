# Changelog

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
