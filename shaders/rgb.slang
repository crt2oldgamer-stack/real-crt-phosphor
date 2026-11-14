#version 450
// Real CRT Phosphor v1.4.3 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 11: the picture is emitted ONLY by red, green and blue phosphor stripes (no base layer underneath).
// Each stripe shows its own colour of the light falling on it; bright stripes bloom wider and overlap
// (bright areas melt toward white), dark stripes stay thin (colours split at edges, like a real tube).
layout(push_constant) uniform Push { vec4 SourceSize; vec4 OriginalSize; vec4 OutputSize; uint FrameCount; } params;
#include "params.inc"
#include "ubo.inc"
#include "common.inc"
#pragma stage vertex
layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;
void main() { gl_Position = global.MVP * Position; vTexCoord = TexCoord; }
#pragma stage fragment
layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 FragColor;
layout(set = 0, binding = 2) uniform sampler2D Source;   // beam image (linear, screen size)
// Pixel-area average of a periodic horizontal bridge (dark gap).
// P >= 2, gap width <= 0.6*P: the nearest bridge and its two neighbours
// cover every bridge that can intersect this output pixel.
// Divide by the open-area mean, so constant illumination retains its mean
// linear energy over a continuous vertical period. The beam itself is not
// averaged vertically, preserving source detail and existing scanlines.
float slotEmission(float py, float phase, float P)
{
    float gap = clamp(global.SLOT_GAP, 0.0, 0.6);
    if (gap <= 0.0) return 1.0;
    float edge = clamp(global.SLOT_EDGE, 0.05, 1.0);
    float width = gap * P;
    float d = mod(py - phase + 0.5 * P, P) - 0.5 * P;
    float area = 0.0;
    // The nearest gap alone is sufficient if the open span is >= 1px.
    // Keep the original 3-gap path at the extreme small-period / wide-gap settings.
    if (P * (1.0 - gap) >= 1.00001) {
        area = gk_stripePrimitive(d + 0.5, width, edge)
             - gk_stripePrimitive(d - 0.5, width, edge);
    } else {
        for (int j = -1; j <= 1; j++) {
            float q = d - float(j) * P;
            area += gk_stripePrimitive(q + 0.5, width, edge)
                  - gk_stripePrimitive(q - 0.5, width, edge);
        }
    }
    // v1.1: gap depth. 1 = the gap goes fully dark, lower values leave some light in it
    // (phosphor glow / glass scatter on a real tube). The open area is rescaled so the average
    // light stays the same, as before.
    float depth = clamp(global.SLOT_DEPTH, 0.0, 1.0);
    return (1.0 - depth * clamp(area, 0.0, 1.0)) / (1.0 - depth * gap * (1.0 - 0.5 * edge));
}

void main()
{
    float T  = gk_triad(params.OutputSize.y);
    float px = vTexCoord.x * params.OutputSize.x;            // screen position (px)
    // v1.3 option: the mask follows the curved tube too. px becomes the position on the curved mask and the
    // beam is read back at the matching screen position. Real tubes do this, but thin slanted stripes beat
    // against the monitor's pixel grid (moire), clearly at 1080p, much less at 4K. Off by default.
    float pxs = px, sxs = 1.0;
    if (global.MASK_CURVE > 0.5 && global.CURVATURE > 0.0005) {
        vec2 wu  = gk_warp(vTexCoord, params.OutputSize.xy);
        vec2 wu2 = gk_warp(vTexCoord + vec2(params.OutputSize.z, 0.0), params.OutputSize.xy);
        sxs = max((wu2.x - wu.x) * params.OutputSize.x, 0.2);
        px = wu.x * params.OutputSize.x;
    }
    float y  = vTexCoord.y;
    vec2 OS = params.OriginalSize.xy / gk_pre();            // v1.4: the picture size the passes really work on
    float gpx = params.OutputSize.x / max(OS.x / gk_box(OS.y), 1.0);   // one game pixel in screen px
    float e  = clamp(global.ST_EDGE, 0.05, 1.0);
    float tri = floor(px / T);
    vec3 outc = vec3(0.0);
    bool slot = global.MASK_TYPE > 0.5;
    vec2 gates = vec2(1.0);
    float yW = y;                                             // row that sets the stripe WIDTH
    if (slot) {
        float py = vTexCoord.y * params.OutputSize.y;
        float P, ph;
        if (global.SLOT_LOCK > 0.5) {
            // v1.1: slots follow the scanlines. One slot = SLOT_LINES scanlines, its gap sits in the dark
            // seam between two lines, and the neighbouring column is shifted by whole lines (brick pattern).
            // No beating between the slot rhythm and the scanline rhythm.
            float lines  = (OS.y / gk_box(OS.y)) / gk_rows(OS.y);
            float linePx = params.OutputSize.y / max(lines, 1.0);
            float nl = floor(clamp(global.SLOT_LINES, 2.0, 4.0) + 0.5);
            float va = clamp(global.SLOT_VADJ, 0.5, 2.0);        // vertical pitch fine-tune (1 = exactly on the scanlines)
            P  = max(2.0, linePx * nl * va);
            ph = floor(nl * 0.5 + 0.5) * linePx * va;
            // straight slot sides: take the stripe width from this scanline's brightest row, so the width
            // does not pinch toward the seams (that pinch is what made slots look like bones / hexagons)
            if (global.SLOT_SHAPE > 0.5) yW = (floor(py / linePx) + 0.5) * linePx * params.OutputSize.w;
        } else {
            // free slot rhythm (Test 1): independent of the scanlines
            P  = max(2.0, T * clamp(global.SLOT_HEIGHT, 0.75, 4.0));
            ph = 0.5 * P;
        }
        gates = vec2(slotEmission(py, 0.0, P), slotEmission(py, ph, P));
    }
    // v0.4: only the stripes that can actually reach this pixel are evaluated.
    // A stripe adds exactly zero once it is farther than (half its widest width + half a pixel),
    // so skipping the rest gives the SAME picture with about half the reads.
    float reach = 0.5 * (T / 3.0) * max(global.ST_BRIGHT, global.ST_DARK) + 0.5;
    for (int c = 0; c < 3; c++) {
        float conv = (float(c) - 1.0) * global.CONVERGE * gpx;   // R sampled a little left, B a little right
        float off = (float(c) + 0.5) / 3.0;
        float n0 = max(floor((px - reach) / T - off) + 1.0, tri - 3.0);   // first stripe of colour c in reach
        float n1 = min(ceil((px + reach) / T - off) - 1.0, tri + 3.0);    // last one
        for (int i = 0; i < 4; i++) {
            float n = n0 + float(i);
            if (n > n1) break;
            float xc = (n + off) * T;                                // centre of a stripe of colour c
            float sxp = pxs + (xc + conv - px) / sxs;           // screen position of this stripe (same as xc+conv when flat)
            float V  = max(texture(Source, vec2(sxp * params.OutputSize.z, y))[c], 0.0);
            float Vw = V;
            if (yW != y) Vw = max(texture(Source, vec2(sxp * params.OutputSize.z, yW))[c], 0.0);
            float s  = global.ST_DARK + (global.ST_BRIGHT - global.ST_DARK) * sqrt(clamp(Vw, 0.0, 1.0));
            float w  = (T / 3.0) * s;
            float d  = px - xc;
            // light of this stripe that falls inside THIS screen pixel (area, not a point sample)
            float prof = gk_stripePrimitive(d + 0.5, w, e) - gk_stripePrimitive(d - 0.5, w, e);
            float gain = T / (w * (1.0 - 0.5 * e));           // the stripe carries its colour for the whole triad
            if (slot) {
                float gate = mod(n, 2.0) < 1.0 ? gates.x : gates.y;
                outc[c] += V * prof * gain * gate;
            } else {
                outc[c] += V * prof * gain;
            }
        }
    }
    // highlights melt into ONE SOFT GLOWING BLOB PER TRIAD (a blurred mask cell in the pixel's colour),
    // so bright areas keep the mask rhythm instead of turning into a flat fill
    float sig = max(global.MELT_BLOB, 0.05) * T;
    vec3 blobs = vec3(0.0);
    int rb = int(ceil((4.0 * sig + 0.5) / T)) + 1;
    // v1.1.1: a blob wider than ~1.2 px gets its one-pixel area from the midpoint value plus the
    // 2nd-order correction (one exp instead of two erfc). Same picture, much cheaper on phone/tablet GPUs.
    bool cheap = sig >= 1.2;
    float isg2 = 1.0 / (sig * sig);
    float nrm = T * 0.39894228 / sig;
    for (int di = -5; di <= 5; di++) {
        if (abs(di) > rb) continue;
        float tc = (tri + float(di) + 0.5) * T;
        vec3 C = max(texture(Source, vec2((pxs + (tc - px) / sxs) * params.OutputSize.z, y)).rgb, vec3(0.0));
        float g;
        if (cheap) {
            float q = (px - tc) * (px - tc) * isg2;
            g = nrm * exp(-0.5 * q) * (1.0 + (q - 1.0) * isg2 * (1.0 / 24.0));
        } else {
            g = T * gk_normalInterval((px - 0.5 - tc) / (1.41421356 * sig), (px + 0.5 - tc) / (1.41421356 * sig));
        }
        if (slot) {
            float gate = mod(tri + float(di), 2.0) < 1.0 ? gates.x : gates.y;
            // Low-cost glow approximation: keep the column phase, soften
            // the gaps in the melt component. No extra texture fetches.
            gate = mix(gate, 1.0, clamp(global.SLOT_MELT, 0.0, 1.0));
            blobs += C * g * gate;
        } else {
            blobs += C * g;
        }
    }
    vec3 h0 = texture(Source, vTexCoord).rgb;
    float L = max(h0.r, max(h0.g, h0.b));
    float k = clamp((L - global.MELT_START) / max(global.MELT_END - global.MELT_START, 0.01), 0.0, 1.0);
    k = k * k * (3.0 - 2.0 * k);
    float dif = global.MELT_DARK + (global.MELT_BRIGHT - global.MELT_DARK) * k;
    FragColor = vec4(mix(outc, blobs, dif), 1.0);
}
