#version 450
// Real CRT Phosphor v1.4.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 9: glow, vertical blur (in scanline units)
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
    float N  = gk_box(params.SourceSize.y);
    vec2 stp = vec2(0.0, N * params.SourceSize.w);
    float s = max(global.GLOW_R * 0.6, 0.1);
    int r = min(int(ceil(3.0 * s)), 16);
    vec3 acc = vec3(0.0); float ws = 0.0;
    for (int j = -16; j <= 16; j++) {
        if (j < -r) continue;
        if (j > r) break;
        float t = float(j);
        float w = exp(-0.5 * t * t / (s * s));
        acc += w * texture(Source, vTexCoord + t * stp).rgb;
        ws += w;
    }
    FragColor = vec4(acc / ws, 1.0);
}
