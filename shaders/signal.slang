#version 450
// Real CRT Phosphor v1.4.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 4: analog signal path - luma/chroma low-pass with rightward smear, TV peaking, hue/saturation, levels + S-curve
layout(push_constant) uniform Push { vec4 SourceSize; vec4 OriginalSize; vec4 OutputSize; uint FrameCount; vec4 DitherSize; vec4 KernSize; } params;
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
layout(set = 0, binding = 2) uniform sampler2D Dither;   // picture (native grid)
layout(set = 0, binding = 3) uniform sampler2D Kern;     // filter weights
void main()
{
    vec4 DS = params.DitherSize;
    float N  = gk_box(DS.y);
    float nW = DS.x / N;
    float k  = gk_ks(nW);                            // v1.4.1: reach of the filter (wide modes: stretched 256 filter)
    vec2 stp = vec2(N * DS.z, 0.0);                  // one native pixel

    float sY  = global.LUMA_BLUR * k;
    float tY  = global.LUMA_TAIL * k;
    float sY2 = sqrt(sY * sY + 1.44 * k * k);        // wider copy used for peaking
    float sC  = global.CHROMA_BLUR * k;
    float tC  = global.CHROMA_TAIL * k;
    float sMax = max(max(sY2, sC), 0.5);
    int lo = -int(ceil(4.0 * sMax));
    int hi = int(ceil(4.0 * sMax + 6.0 * max(tY, tC)));
    lo = max(lo, -32); hi = min(hi, 64);

    float Y1 = 0.0, W1 = 0.0, Y2 = 0.0, W2 = 0.0, W3 = 0.0;
    vec2 C = vec2(0.0);
    for (int j = -32; j <= 64; j++) {
        if (j < lo) continue;
        if (j > hi) break;
        float t = float(j);
        vec3 yiq = gk_toYIQ(texture(Dither, vTexCoord - t * stp).rgb);
        vec3 wk = texture(Kern, vec2((t + 32.5) * params.KernSize.z, 0.5 * params.KernSize.w)).rgb;
        float w1 = wk.r, w2 = wk.g, w3 = wk.b;
        Y1 += w1 * yiq.x; W1 += w1;
        Y2 += w2 * yiq.x; W2 += w2;
        C  += w3 * yiq.yz; W3 += w3;
    }
    float yl = Y1 / max(W1, 1e-6);
    float Y  = yl + global.PEAKING * (yl - Y2 / max(W2, 1e-6));
    vec2 c = C / max(W3, 1e-6);
    float h = radians(global.HUE);
    c = vec2(c.x * cos(h) - c.y * sin(h), c.x * sin(h) + c.y * cos(h)) * global.SATURATION;

    vec3 rgb = clamp(gk_fromYIQ(vec3(Y, c)), 0.0, 1.0);
    float ungraded = max(rgb.r, max(rgb.g, rgb.b));   // beam width is taken from the signal before grading

    rgb = clamp((rgb - global.LV_BLACK) / max(global.LV_WHITE - global.LV_BLACK, 0.01), 0.0, 1.0);
    vec3 sm = rgb * rgb * (3.0 - 2.0 * rgb);
    vec3 kk = mix(vec3(global.S_HIGH), vec3(global.S_LOW), step(rgb, vec3(0.5)));
    rgb = rgb + kk * (sm - rgb);

    FragColor = vec4(rgb, ungraded);
}
