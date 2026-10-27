#version 450
// Real CRT Phosphor v1.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 5: vertical softness - blends neighbouring scanlines' picture (linear light) before the beams are drawn
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
    float vb = global.VERT_BLUR;
    if (vb < 0.01) { FragColor = texture(Source, vTexCoord); return; }
    float N  = gk_box(params.SourceSize.y);
    vec2 stp = vec2(0.0, N * params.SourceSize.w);
    float ge = 2.2 * global.GAMMA_IN;
    int r = min(int(ceil(3.0 * vb)), 6);
    vec4 acc = vec4(0.0); float ws = 0.0;
    for (int j = -6; j <= 6; j++) {
        if (j < -r) continue;
        if (j > r) break;
        float t = float(j);
        float w = exp(-0.5 * t * t / (vb * vb));
        acc += w * pow(clamp(texture(Source, vTexCoord + t * stp), 0.0, 1.0), vec4(ge));
        ws += w;
    }
    FragColor = pow(acc / ws, vec4(1.0 / ge));
}
