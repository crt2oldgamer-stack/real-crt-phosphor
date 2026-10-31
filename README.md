# Real CRT Phosphor — A Slang Shader for RetroArch

I grew up playing games on a CRT, and I wanted to recreate a particular part of that experience on my current displays: the way RGB phosphor stripes become visible up close, change their apparent width with brightness, and blend together in highlights. CRT photos were an important visual reference throughout the project.

This is my attempt to capture that look, rather than an exact simulation of a particular CRT model. I’m enjoying the result and wanted to share it with other players.

### Reference & Target Look

This is the kind of picture I was aiming for:

<img width="1280" height="720" alt="01_reference_crt_vs_lcd" src="https://github.com/user-attachments/assets/b4d97c7a-2817-408e-baa3-eb8d3e2913fa" />
*The goal: a close-up photo of a real CRT (left) next to the same art on an LCD (right). Reference image, not my capture — a widely shared image whose original source I couldn’t find. If you know where it came from, please tell me so I can credit it.*

And this is the same scene through **Real CRT Phosphor**:

<img width="1096" height="476" alt="02_sotn_shader_vs_original" src="https://github.com/user-attachments/assets/7d99757f-0380-42e8-83c0-2d5f652a9d69" />
*Castlevania: Symphony of the Night (PS1) — Real CRT Phosphor on the left, original on the right, laid out like the reference above. 4K capture, shown at 1:1 pixels.*

Another example, *Final Fantasy VI*:

<img width="1616" height="900" alt="03_ff6_comparison" src="https://github.com/user-attachments/assets/85de9709-1933-4b80-86d7-54eac0cb77f9" />
*Final Fantasy VI (SNES) — original on the left, Real CRT Phosphor on the right (4K capture, shown at 1:1 pixels).*

---

## The Main Idea: Procedural RGB Emission

The shader constructs its phosphor pattern procedurally. The picture is formed from the contributions of individual red, green, and blue emission stripes, rather than keeping an unfiltered copy of the picture underneath the stripe pattern.

* **Independent Channel Widths:** Each channel controls its own stripe width. Brighter channel values produce wider emission stripes; darker ones stay thin. In an orange area, for example, the red stripe can be wide while the blue stripe stays very narrow.
* **Highlight Blending:** Highlights gradually blend into a softer glow. As brightness increases, the separate stripes merge more, while retaining some of the rhythm of the RGB groups.
* **Normalized Emission:** Emission is normalized as the stripe width changes. The aim is to control the light distribution as well as the visible stripe shape. The final appearance still depends on gamma, settings, and the display.

The illustration below shows the idea, using a dark-to-bright ramp and an orange example:

<img width="760" height="560" alt="04_lcd_vs_phosphor" src="https://github.com/user-attachments/assets/6b85cabf-3515-4e63-b0bd-eb0121960c33" />
*Illustration of fixed-width RGB stripes versus the shader’s brightness-dependent emission widths. This illustrates the design idea, not a comparison against every other CRT shader.*

---

## Close-up Comparisons

Here are examples from *Final Fantasy VI*, *Metal Gear Solid*, *Vagrant Story*, and *Persona 2: Innocent Sin*. The original image is on the left and the shader result is on the right. These show how the RGB structure changes the appearance of faces, edges, and text.

<img width="1616" height="590" alt="05_zoom_ff6" src="https://github.com/user-attachments/assets/a4140285-b833-4bae-9026-0b870b291509" />
*Final Fantasy VI (SNES) — original / Real CRT Phosphor. Detail from 4K output, shown at 2x.*

<img width="1616" height="590" alt="06_zoom_mgs_codec" src="https://github.com/user-attachments/assets/53178812-4da5-423d-9405-d08651fdfcc4" />
*Metal Gear Solid (PS1) — original / Real CRT Phosphor. Codec portrait, detail from 4K output, shown at 2x.*

<img width="1616" height="590" alt="07_zoom_vagrant_story" src="https://github.com/user-attachments/assets/51f6f558-2bac-4c7d-a87b-3fa8b3de138e" />
*Vagrant Story (PS1) — original / Real CRT Phosphor. Text detail from 4K output, shown at 2x.*

<img width="1616" height="590" alt="08_zoom_persona2" src="https://github.com/user-attachments/assets/aba58795-90ca-45b9-8ab8-47f1531e1f81" />
*Persona 2: Innocent Sin (PS1) — original / Real CRT Phosphor. Detail from 4K output, shown at 2x.*

A closer view of the phosphor pattern:

<img width="800" height="540" alt="09_phosphor_closeup" src="https://github.com/user-attachments/assets/52bf78be-cb73-4f39-b63b-c8566cb9f4cf" />
*4x close-up: brighter regions have wider emission stripes; darker regions have thinner stripes.*

---

## Aperture Grille and Slot Mask

Both mask types are included. **Aperture grille** uses continuous vertical RGB stripes; **slot mask** breaks the pattern into staggered cells. You can switch between them using the `Mask type` parameter.

While developing the slot mask, I ran into interference between the slot spacing and scanlines, as well as pinched-looking cell sides. The current version includes scanline-aligned slots and a straight-sided option to address those visual issues.

For my presets, I settled on a pitch of `4.5` for the grille and `3.0` for the slot mask. Those are starting points, and you can adjust them to suit your display and preferences.

<img width="1300" height="590" alt="10_grille_vs_slot" src="https://github.com/user-attachments/assets/6cd6b1ea-e02e-40dd-917c-fe56b5e86cb6" />
*Pattern illustration: aperture grille (pitch 4.5) / slot mask (pitch 3.0). Different pitches are used in this example.*

---

## Full Gameplay Examples (4K)

Before-and-after examples on a 32-inch 4K monitor, uploaded at full 4K capture resolution. Each unfiltered image is followed by its shader-applied version. **Please open them at full size (1:1)** to see the phosphor structure accurately without scaling moiré.

### Final Fantasy VI
<img width="2821" height="2160" alt="11_ff6_battle_before" src="https://github.com/user-attachments/assets/df5fe60a-c154-41fa-a0c4-ac9056a51edb" />
<img width="2821" height="2160" alt="12_ff6_battle_after" src="https://github.com/user-attachments/assets/fc15cb76-3c3f-4cec-acc3-28ac1f6ecb2f" />

### Final Fantasy VII
<img width="2880" height="2160" alt="13_ff7logo_before" src="https://github.com/user-attachments/assets/a19c3131-971b-47b2-a941-075182a08d12" />
<img width="2880" height="2160" alt="14_ff7logo_after" src="https://github.com/user-attachments/assets/eaa6b788-ebb1-46fc-8ad8-a7fd02c093a8" />
<img width="2880" height="2160" alt="15_ff7_before" src="https://github.com/user-attachments/assets/f9b57dc1-71df-460c-9301-6696012181ca" />
<img width="2880" height="2160" alt="16_ff7_after" src="https://github.com/user-attachments/assets/ccaae324-1970-4de0-9172-d5f90b9d2c9b" />

### Metal Gear Solid
<img width="2880" height="2160" alt="17_mgs_before" src="https://github.com/user-attachments/assets/3e2135e8-2007-494c-a11b-9058311303b1" />
<img width="2880" height="2160" alt="18_mgs_after" src="https://github.com/user-attachments/assets/c3e99c7a-d2ea-4de2-bb16-7b96cf5b2674" />


### RayStorm
<img width="2880" height="2160" alt="19_raystorm_before" src="https://github.com/user-attachments/assets/97299aa4-0906-4bdb-80d0-5f44d2af7e59" />
<img width="2880" height="2160" alt="20_raystorm_after" src="https://github.com/user-attachments/assets/419bbe8a-1a8a-4a6c-bc21-dca72249c343" />


### Raiden II (Arcade - Vertical)
Vertical arcade games work too. RetroArch rotates the picture after the shader runs, so the RGB stripes and scanlines turn with the screen, just like a CRT mounted sideways in an arcade cabinet.

<img width="1620" height="2160" alt="21_raiden2_before" src="https://github.com/user-attachments/assets/9befd73d-78fe-4a86-af88-32a46b93af1e" />
<img width="1620" height="2160" alt="22_raiden2_after" src="https://github.com/user-attachments/assets/e65d26e4-0fa9-471b-8f45-d4fdb1ee268d" />

---

## Test Setup and Presets

I’ve tested the shader on a **32-inch 4K monitor** and an **ASUS ROG Ally at 1080p**, with games from systems including SNES, PS1, PS2, PSP, and arcade (MAME). **Vulkan** is my recommended RetroArch video driver for trying these presets.

* `presets/4K/`: Presets for 4K displays.
* `presets/Ally/`: Presets tuned for a 1080p handheld.
* **System presets without `-slot`:** Aperture grille.
* **Presets with `-slot`:** Slot mask.
* **`-ps2-2d`:** A separate starting point for PS2 2D games.

**Tuning Tips:** `Horizontal softness`, `Vertical softness`, and `Phosphor pitch` are useful adjustments for individual games. I also like adding a little convergence error for a slightly imperfect CRT look. Once you find settings you enjoy, save a **Game Preset**.

> **Note:** Please view screenshots at their original size. Resizing can hide the RGB structure or introduce moiré. The effect also needs enough output pixels to resolve the pattern; a small preview may not show it accurately.

---

## Download and Installation

1. [**Download the shader ZIP from GitHub Releases**](https://github.com/crt2oldgamer-stack/real-crt-phosphor/releases)
2. Extract the `real-crt-phosphor` folder into `RetroArch/shaders/shaders_slang/`.
3. Launch a game, then go to **Quick Menu → Shaders → Load**.
4. Choose a preset from `presets/4K/` or `presets/Ally/`.
5. Save it as a **Core Preset**, or save your game-specific adjustments as a **Game Preset**.

---

## Bonus: PCSX2 through ShaderGlass

After making the RetroArch version, I also tried importing it into **ShaderGlass** and applying it to the standalone PCSX2 emulator. It worked well in my setup and gave me another way to use the same CRT look for PS2 games.

<img width="3840" height="2160" alt="23_ps2_a_before" src="https://github.com/user-attachments/assets/9da878da-a40c-44a0-bc16-918a1e7ab496" />
<img width="3840" height="2160" alt="24_ps2_a_after" src="https://github.com/user-attachments/assets/3fc56578-46bd-48be-852d-a75b85dde47a" />

<img width="3838" height="2158" alt="25_ps2_acecombat5_before" src="https://github.com/user-attachments/assets/e151a2bf-7fa8-493f-ba4c-7f9a2376bc01" />
<img width="3838" height="2158" alt="26_ps2_acecombat5_after" src="https://github.com/user-attachments/assets/14996568-2eec-49fd-82f2-17502891a271" />

**Note on Final Fantasy Pixel Remaster:** It renders on a 320×180 pixel grid, so ShaderGlass’s Pixel Size must be set to `game height ÷ 180` (`x4` at 720p, `x6` at 1080p, `x12` at 4K), and Windows display scaling must be turned off for the capture. With that, the shimmering disappears. The remaining limitation is the UI text: it is drawn at high resolution rather than on the pixel grid, so it gets degraded when the image is reduced to 320×180.

---

## Development Disclosure and Terms

* **Credits & AI Disclosure:** Most of the shader code was written with the assistance of Claude and ChatGPT. I handled the visual direction, CRT reference comparisons, testing, and parameter tuning. AI also helped me prepare this English documentation and translate the explanatory image labels; the game screenshots and shader patterns themselves were preserved.
* **License:** The shader is free for non-commercial use, modification, and redistribution with credit and the included license. Commercial use requires prior permission.

I hope some of you enjoy this look too. If you try it, I’d love to see your results and hear which games and settings work well for you!
