#version 450
// Real CRT Phosphor v1.4.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 8: glow, horizontal blur (linear light)
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
    float nW = params.SourceSize.x / N;
    float k  = gk_kg(nW);                        // v1.4.1: same glow size on screen for 256 and 512 modes
    vec2 stp = vec2(N * params.SourceSize.z, 0.0);
    float s = max(global.GLOW_R * 0.875 * k, 0.1);
    int r = min(int(ceil(3.0 * s)), 24);
    vec3 acc = vec3(0.0); float ws = 0.0;
    for (int j = -24; j <= 24; j++) {
        if (j < -r) continue;
        if (j > r) break;
        float t = float(j);
        float w = exp(-0.5 * t * t / (s * s));
        acc += w * texture(Source, vTexCoord + t * stp).rgb;   // v1.1.1: Signal is already linear
        ws += w;
    }
    FragColor = vec4(acc / ws, 1.0);
}
