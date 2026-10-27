Real CRT Phosphor v1.1 — CRT shader for RetroArch (slang)
by gunkun (concept, direction, testing, tuning)
AI-generated work: most of the code was written by AI (Claude, ChatGPT). See LICENSE.txt

The picture is emitted ONLY by R, G, B phosphor stripes (no base image under a mask).
Stripes of bright colors get wider, dark ones thinner; very bright areas melt into glow;
total light is preserved so widening never dims or muddies the image.

Install: copy the real-crt-phosphor folder into RetroArch/shaders/shaders_slang/,
load real-crt-phosphor.slangp, or a tuned preset from presets/4K or presets/Ally.
Per-game tweaks: adjust parameters, then Save Game Preset.
Tip: view screenshots at 100% — downscaling destroys the stripe pattern.

v1.1: new "Mask type" parameter — 0 Aperture Grille (default), 1 Slot Mask.
Recommended pitch: Grille 4.5, Slot 3 (larger slot pitch makes the slot gaps look harsh).
presets/*/*-ps2-2d: pitch 1.5 acts as a fine colour blend that smooths 2D sprite edges.

Terms: free for non-commercial use, modification and redistribution with credit; commercial use needs permission.
No warranty. Files from unofficial sources may be altered - see LICENSE.txt.
