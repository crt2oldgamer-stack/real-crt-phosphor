// Real CRT Phosphor v1.4.3 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
#pragma parameter GK_TITLE "=== Real CRT Phosphor v1.4.3 ===" 0.0 0.0 0.0 1.0
#pragma parameter GK_INFO "    AI-assisted by Claude / ChatGPT - see LICENSE.txt" 0.0 0.0 0.0 1.0
#pragma parameter GK_SP1 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_IN "[ INPUT ]  (0 = auto)" 0.0 0.0 0.0 1.0
#pragma parameter RASTER_LINES "    Scanlines in picture (PSP 272)" 0.0 0.0 600.0 1.0
#pragma parameter CONTENT_SCALE "    Internal-res average factor" 0.0 0.0 8.0 1.0
#pragma parameter PRESCALE "    Pre-shrunk by (set by -upNx presets)" 0.0 0.0 8.0 1.0
#pragma parameter GK_SP2 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_SIG "[ SIGNAL ]" 0.0 0.0 0.0 1.0
#pragma parameter DITHER "    Dither blending (Mega Drive)" 0.0 0.0 1.0 0.05
#pragma parameter SOFT_ALL "    Soft blur, all directions" 0.0 0.0 1.0 0.05
#pragma parameter LUMA_BLUR "    Horizontal softness (before RGB split)" 0.15 0.0 3.0 0.05
#pragma parameter LUMA_TAIL "    Smear to the right (luma)" 0.3 0.0 5.0 0.05
#pragma parameter PEAKING "    TV sharpness / edge ringing" 0.15 0.0 2.0 0.05
#pragma parameter CHROMA_BLUR "    Color bleed width" 0.3 0.0 4.0 0.05
#pragma parameter CHROMA_TAIL "    Color smear to the right" 0.6 0.0 8.0 0.05
#pragma parameter SATURATION "    Saturation" 1.3 0.0 2.0 0.01
#pragma parameter HUE "    Hue (tint knob, degrees)" 0.0 -30.0 30.0 1.0
#pragma parameter GK_SP3 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_GRADE "[ COLOR GRADE ]" 0.0 0.0 0.0 1.0
#pragma parameter LV_BLACK "    Levels black point" 0.0 0.0 0.40 0.01
#pragma parameter LV_WHITE "    Levels white point" 0.96 0.60 1.00 0.01
#pragma parameter S_LOW "    S-curve shadows" 0.55 0.0 1.0 0.05
#pragma parameter S_HIGH "    S-curve highlights" 0.3 0.0 1.0 0.05
#pragma parameter GAMMA_IN "    CRT gamma (x2.2)" 1.0 0.8 1.6 0.01
#pragma parameter WP_R "    White balance R" 0.79 0.5 1.2 0.01
#pragma parameter WP_G "    White balance G" 0.83 0.5 1.2 0.01
#pragma parameter WP_B "    White balance B" 0.91 0.5 1.2 0.01
#pragma parameter GK_SP4 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_BEAM "[ SCANLINES ]" 0.0 0.0 0.0 1.0
#pragma parameter VERT_BLUR "    Vertical softness (blend lines)" 0.0 0.0 2.0 0.05
#pragma parameter BEAM_DARK "    Beam width, dark colors" 0.18 0.08 0.50 0.01
#pragma parameter BEAM_BRIGHT "    Beam width, bright colors" 0.32 0.08 0.60 0.01
#pragma parameter GK_SP5 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_GLOW "[ GLOW ]" 0.0 0.0 0.0 1.0
#pragma parameter GLOW "    Glow strength" 0.12 0.0 1.0 0.01
#pragma parameter GLOW_R "    Glow radius" 0.8 0.3 4.0 0.1
#pragma parameter GK_SP6 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_RGB "[ RGB PHOSPHOR STRIPES ]" 0.0 0.0 0.0 1.0
#pragma parameter MASK_PITCH "    RGB triad pitch px (0 = auto)" 0.0 0.0 16.0 0.5
#pragma parameter MASK_SIZE "    Triad size for auto pitch (x)" 1.0 0.5 3.0 0.05
#pragma parameter ST_DARK "    Stripe width, dark colors" 0.45 0.1 2.0 0.05
#pragma parameter ST_BRIGHT "    Stripe width, bright colors" 2.2 0.5 5.0 0.05
#pragma parameter ST_EDGE "    Stripe edge softness" 0.7 0.05 1.0 0.05
#pragma parameter MELT_START "    Highlights melt: starts at" 0.3 0.0 1.0 0.05
#pragma parameter MELT_END "    Highlights melt: full at" 0.7 0.1 1.5 0.05
#pragma parameter MELT_DARK "    Melt amount, dark" 0.03 0.0 1.0 0.01
#pragma parameter MELT_BRIGHT "    Melt amount, bright" 0.6 0.0 1.0 0.05
#pragma parameter MELT_BLOB "    Melt glow size per triad" 0.38 0.15 1.0 0.01
#pragma parameter CONVERGE "    Convergence error (R left, B right)" 0.0 0.0 1.0 0.05
#pragma parameter GK_SP7 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_POST "[ BLUR AFTER RGB SPLIT ]" 0.0 0.0 0.0 1.0
#pragma parameter RGB_BLUR_X "    RGB blur horizontal" 0.6 0.0 3.0 0.05
#pragma parameter RGB_BLUR_Y "    RGB blur vertical" 0.45 0.0 3.0 0.05
#pragma parameter KNEE "    Highlight roll-off starts at" 0.8 0.5 1.0 0.01
#pragma parameter FINAL_BLUR "    Final whole-screen soft blur" 0.0 0.0 3.0 0.05
#pragma parameter BRIGHT "    Brightness" 1.3 0.5 3.0 0.01
#pragma parameter GK_SP8 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_SLOT "[ MASK TYPE / SLOT MASK ]" 0.0 0.0 0.0 1.0
#pragma parameter MASK_TYPE "    Mask type: 0 Grille / 1 Slot" 0.0 0.0 1.0 1.0
#pragma parameter SLOT_LOCK "    Slot follows scanlines: 0 off / 1 on" 1.0 0.0 1.0 1.0
#pragma parameter SLOT_LINES "    Slot height in scanlines (when following)" 2.0 2.0 4.0 1.0
#pragma parameter SLOT_VADJ "    Slot vertical pitch adjust (1 = on scanlines)" 1.0 0.5 2.0 0.01
#pragma parameter SLOT_SHAPE "    Slot straight sides (when following)" 1.0 0.0 1.0 1.0
#pragma parameter SLOT_HEIGHT "    Slot vertical pitch, free mode (x RGB triad)" 1.5 0.75 4.0 0.05
#pragma parameter SLOT_GAP "    Slot gap fraction" 0.22 0.0 0.6 0.01
#pragma parameter SLOT_DEPTH "    Slot gap depth (1 = fully dark)" 0.6 0.0 1.0 0.05
#pragma parameter SLOT_EDGE "    Slot gap edge softness" 0.35 0.05 1.0 0.05
#pragma parameter SLOT_MELT "    Slot gap fill in highlight glow" 0.65 0.0 1.0 0.05
#pragma parameter GK_SP9 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_AG "[ PHOSPHOR AFTERGLOW ]  (motion trail, 0 = off)" 0.0 0.0 0.0 1.0
#pragma parameter AFTERGLOW "    Afterglow strength (0 = off)" 0.0 0.0 1.0 0.05
#pragma parameter AG_TIME "    Afterglow time until it looks 10% (ms, 60 fps)" 20.0 5.0 600.0 5.0
#pragma parameter AG_RED "    Red phosphor lasts longer (x)" 1.2 1.0 4.0 0.1
#pragma parameter GK_SP10 " " 0.0 0.0 0.0 1.0
#pragma parameter GK_CURVE "[ SCREEN CURVATURE ]  (0 = flat)" 0.0 0.0 0.0 1.0
#pragma parameter CURVATURE "    Tube curvature (0 = flat)" 0.0 0.0 0.5 0.01
#pragma parameter CORNER "    Rounded corners (with curvature)" 0.03 0.0 0.15 0.005
#pragma parameter VIGNETTE "    Edge darkening (with curvature)" 0.25 0.0 1.0 0.05
#pragma parameter MASK_CURVE "    Mask follows curvature (moire at 1080p)" 0.0 0.0 1.0 1.0
