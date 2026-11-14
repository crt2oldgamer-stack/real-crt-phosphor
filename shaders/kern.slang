#version 450
// Real CRT Phosphor v1.4.3 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 3: lookup row of the horizontal filter weights (only the first row / first 128 texels are used).
// The weights are the same for every pixel, so they are computed once here instead of per pixel in the signal pass.
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
layout(set = 0, binding = 2) uniform sampler2D Source;
void main()
{
    vec2 tx = floor(vTexCoord * params.OutputSize.xy);
    if (tx.y > 0.5 || tx.x > 127.5) { FragColor = vec4(0.0); return; }   // only row 0, texels 0..127 are needed
    float N  = gk_box(params.SourceSize.y);
    float nW = params.SourceSize.x / N;
    float t  = tx.x - 32.0;                                  // tap offset -32 .. +95
    if (gk_wide(nW, params.SourceSize.y)) {
        // v1.4.1: wide modes use the 256 filter, stretched by nW/256 with linear interpolation between its taps
        float u  = t * 256.0 / nW;
        float u0 = floor(u), f = u - u0;
        float sY  = global.LUMA_BLUR;
        float tY  = global.LUMA_TAIL;
        float sY2 = sqrt(sY * sY + 1.44);
        float sC  = global.CHROMA_BLUR;
        float tC  = global.CHROMA_TAIL;
        vec3 a = vec3(gk_exgauss(u0, sY, tY), gk_exgauss(u0, sY2, tY), gk_exgauss(u0, sC, tC));
        vec3 b = vec3(gk_exgauss(u0 + 1.0, sY, tY), gk_exgauss(u0 + 1.0, sY2, tY), gk_exgauss(u0 + 1.0, sC, tC));
        // between two 256 taps the weight is lowered to 70 %, so the stretched filter is not wider than needed
        FragColor = vec4(mix(a, b, f) * (1.0 - 0.3 * 4.0 * f * (1.0 - f)), 1.0);
        return;
    }
    float k  = gk_k(nW);
    float sY  = global.LUMA_BLUR * k;
    float tY  = global.LUMA_TAIL * k;
    float sY2 = sqrt(sY * sY + 1.44 * k * k);
    float sC  = global.CHROMA_BLUR * k;
    float tC  = global.CHROMA_TAIL * k;
    FragColor = vec4(gk_exgauss(t, sY, tY), gk_exgauss(t, sY2, tY), gk_exgauss(t, sC, tC), 1.0);
}
