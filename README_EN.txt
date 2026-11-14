Real CRT Phosphor v1.4.3 — CRT shader for RetroArch (slang)
by gunkun (concept, direction, testing, tuning)
AI-generated work: most of the code was written by AI (Claude, ChatGPT). See LICENSE.txt

The picture is emitted ONLY by R, G, B phosphor stripes (no base image under a mask).
Stripes of bright colors get wider, dark ones thinner; very bright areas melt into glow;
total light is preserved so widening never dims or muddies the image.

Install: copy the real-crt-phosphor folder into RetroArch/shaders/shaders_slang/,
load real-crt-phosphor.slangp, or a tuned preset from presets/4K or presets/Ally.
Per-game tweaks: adjust parameters, then Save Game Preset.
Tip: view screenshots at 100% — downscaling destroys the stripe pattern.

Bonus: GBA color fix (GBA Comfort Color) - presets/GBA/
  Many GBA games use very strong, neon-like colors. On a modern screen space looks bright blue and
  greens look neon, which is hard on the eyes. The GBA bonus presets tone them down for comfortable play.
  - Three strengths: LIGHT / MEDIUM (not sure? use this) / STRONG (games full of neon colors, e.g. Super Robot Wars A)
  - Color only (1 pass, for handhelds): presets/GBA/gba-light, gba-medium, gba-strong.slangp
  - Color + CRT (15 passes): presets/GBA/gba-crt-light, gba-crt-medium, gba-crt-strong.slangp
  - Nothing extra to install: it is inside the real-crt-phosphor folder. See presets/GBA/README_EN.txt

v1.4.3: fixes + GBA bonus
  1) High-resolution pictures are sharp again (PS2, PS1 640x480, ShaderGlass captures).
     v1.4.1 made every picture wider than 320 px as soft as a 256 picture. That was right for SNES 512 modes
     (a 256 picture drawn twice as wide), but real hi-res pictures like PS2 640x448 became so soft that text
     was hard to read. Now only pictures up to 288 lines (240p class) and 321-599 px wide (SNES 512, PS1 368-512)
     use the v1.4.1 behaviour; bigger pictures (480-line, 600+ px wide, small ShaderGlass window captures like
     400x300) use the v1.4 filter again.
     - Up to 320 wide: same as v1.4 and v1.4.1.  SNES 512 (e.g. Seiken Densetsu 3 dialog boxes): same as v1.4.1.
     - PS2, PS1 640x480 / 368x480 menus, ShaderGlass captures: pixel-identical to v1.4.
     Thanks to the Reddit user who reported it (PCSX2 + ShaderGlass on a ROG Ally).
  2) PSP at 4x internal resolution (1088 lines) now gets the right number of scanlines (272, was 218).
     Heights that are an exact multiple of 272 (1088, 1360, 1632) are read as PSP lines. PSP 1x-3x: unchanged.
  3) Bonus: GBA color presets (see above).

v1.4.1: fix - the picture no longer turns sharper or shifts right when a game switches to a wider mode.
  Some games change the screen width while you play. Seiken Densetsu 3 (SNES), for example, switches
  from 256 to 512 pixels wide whenever a dialog box opens. Before, the glow and the horizontal softness
  were measured in game pixels and capped, so in the 512 mode they shrank to about 60 % on screen:
  the picture suddenly looked sharper and the glow seemed to disappear. The smear to the right was also
  built on the game-pixel grid, so it came out a little longer on the finer 512 grid and the picture
  seemed to jump right.
  Now:
  - The glow keeps the same size on screen whatever the input width.
  - In wide modes (over 320) the signal filter (softness, colour bleed, smear to the right) is the 256
    filter stretched to the wider grid, so it has the same size and position on screen as in the 256 picture.
  On a real CRT all of this comes from the glass and the analog signal, so it doesn't change with the
  game's resolution either.
  - Games up to 320 wide (most SNES, Mega Drive, arcade, PS1 games): pixel-identical to v1.4.
  - Wider screens (PS1 368/384/512/640, SNES 512): softer, close to the 256 picture.
  - Text in 512-wide screens gets softer, like the rest of the picture, but stays readable.
  - Very fine details (1-2 px) can't match the 256 picture exactly, because the 256 and 512 pixel
    grids don't line up; the difference stays within a few percent (tested at 4K and on the ROG Ally).
  Just overwrite the folder; your presets and game presets keep working.

v1.4: upscale presets for 3D games (lighter, same picture).
  Use them when the emulator renders at 2x, 3x or 4x internal resolution (PS1, PSP, N64, PS2...).
  - presets/4K/4k-up2x, 4k-up3x, 4k-up4x: for 4K monitors
  - presets/Ally/ally-up2x, ally-up3x, ally-up4x: for the ROG Ally and 1080p
    e.g. PS1 at 2x on a ROG Ally -> presets/Ally/ally-up2x.slangp
  - For a system-specific look (ps1, psp...), tune it in the web preview and save as "upscale".
  - (The real-crt-phosphor-up2x / up3x / up4x.slangp files are the chains these presets point to.)
  The first pass averages N x N and shrinks the picture back to its original size, so the rest of
  the shader and its buffers are as light as at 1x. Fewer frame drops at 3x/4x, and much shorter
  hitches (audio crackle) when a game switches resolution, e.g. entering a battle.
  The result is pixel-identical to the 1x picture. 2D systems: keep using the normal presets.
  Suggested for 3D games: 2x internal resolution + up2x. On handhelds like the ROG Ally, the emulator
  itself uses most of the GPU from 3x on, so frames may drop there.
  Save it as a Game Preset for the games you upscale, so it never lands on a 1x game. The internal resolution and the preset
  must match (3x picture -> up3x). In the web preview, Save .slangp picks the upscale chain for 3x/4x.

v1.3: new optional screen curvature, off by default.
  Menu: [ SCREEN CURVATURE ] at the bottom.
  - Tube curvature: 0 = flat (default). 0.05 subtle / 0.15 normal / 0.3 strong
  - Rounded corners, Edge darkening: only with curvature on
  - Mask follows curvature: 1 = the RGB stripes bend too (default 0). Closer to a real tube,
    but shows moire at 1080p; much less at 4K
  The picture is bent BEFORE the scanlines and RGB stripes are drawn, so there is none of the moire
  you get from appending a separate curvature shader. By default the RGB stripes stay straight on the screen;
  the picture and scanlines curve. Curvature 0 gives exactly the v1.2 picture.
  With the slot mask, Slot lock can drift slightly from the scanlines at strong curvature.

v1.2: new optional phosphor afterglow (motion trail), off by default.
  Menu: [ PHOSPHOR AFTERGLOW ] at the bottom.
  - Afterglow strength: 0 = off
  - Afterglow time: ms until the trail LOOKS 10 % as bright (default 20). Longer = longer trail
  - Red lasts longer: how many times longer red phosphor glows (default 1.2). Larger = redder trail
  Suggested: strength 0.4, time 20, red 1.2 (close to a real CRT: a faint reddish smear)
             strength 0.8, time 200, red 2 (the exaggerated trail some of us remember)
  A still picture is not changed at all; only where something moved away keeps a fading glow,
  always dimmer than the original. Computed at game resolution, so it costs almost nothing.
  Times assume 60 fps. Real consumer CRT phosphors fade much faster; this is a taste setting.
  The web preview shows a still image, so tune it in RetroArch while things move.

v1.1.1: speed-up for phone and tablet GPUs, same picture.
  - Gamma decoding (pow) moved from the screen-size pass to the game-resolution pass:
    32 pow() per screen pixel -> 0 (the Signal pass now keeps linear light in a float buffer).
  - Highlight melt blobs use one exp plus a correction term instead of two erfc (blobs >= 1.2 px).
  - About 1/4 of the special-function work (pow, exp...) left in the screen-size passes.
  - Difference from v1.1: at most 2/255 per pixel (not visible).
  Existing presets and game presets keep working: just overwrite the folder.

v1.1: new "Mask type" parameter — 0 Aperture Grille (default), 1 Slot Mask.
Recommended pitch: Grille 4.5, Slot 3 (larger slot pitch makes the slot gaps look harsh).
presets/*/*-ps2-2d: pitch 1.5 acts as a fine colour blend that smooths 2D sprite edges.

Terms: free for non-commercial use, modification and redistribution with credit; commercial use needs permission.
No warranty. Files from unofficial sources may be altered - see LICENSE.txt.
