Real CRT Phosphor v1.4 — CRT shader for RetroArch (slang)
by gunkun (concept, direction, testing, tuning)
AI-generated work: most of the code was written by AI (Claude, ChatGPT). See LICENSE.txt

The picture is emitted ONLY by R, G, B phosphor stripes (no base image under a mask).
Stripes of bright colors get wider, dark ones thinner; very bright areas melt into glow;
total light is preserved so widening never dims or muddies the image.

Install: copy the real-crt-phosphor folder into RetroArch/shaders/shaders_slang/,
load real-crt-phosphor.slangp, or a tuned preset from presets/4K or presets/Ally.
Per-game tweaks: adjust parameters, then Save Game Preset.
Tip: view screenshots at 100% — downscaling destroys the stripe pattern.

v1.4: upscale presets for 3D games (lighter, same picture).
  Use them when the emulator renders at 2x, 3x or 4x internal resolution (PS1, PSP, N64, PS2...).
  - real-crt-phosphor-up2x / up3x / up4x.slangp: upscale chains
  - presets/4K-upscale, presets/Ally-upscale: base, ps1, psp, ps2 (+slot) at 2x / 3x / 4x
    e.g. PS1 at 3x on a ROG Ally -> presets/Ally-upscale/ally-ps1-up3x.slangp
  The first pass averages N x N and shrinks the picture back to its original size, so the rest of
  the shader and its buffers are as light as at 1x. Fewer frame drops at 3x/4x, and much shorter
  hitches (audio crackle) when a game switches resolution, e.g. entering a battle.
  The result is pixel-identical to the 1x picture. 2D systems: keep using the normal presets.
  Suggested for 3D games: 2x internal resolution + up2x. The internal resolution and the preset
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
