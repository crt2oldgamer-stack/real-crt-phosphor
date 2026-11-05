Real CRT Phosphor v1.2 — CRT shader for RetroArch (slang)
by gunkun (concept, direction, testing, tuning)
AI-generated work: most of the code was written by AI (Claude, ChatGPT). See LICENSE.txt

The picture is emitted ONLY by R, G, B phosphor stripes (no base image under a mask).
Stripes of bright colors get wider, dark ones thinner; very bright areas melt into glow;
total light is preserved so widening never dims or muddies the image.

Install: copy the real-crt-phosphor folder into RetroArch/shaders/shaders_slang/,
load real-crt-phosphor.slangp, or a tuned preset from presets/4K or presets/Ally.
Per-game tweaks: adjust parameters, then Save Game Preset.
Tip: view screenshots at 100% — downscaling destroys the stripe pattern.

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
