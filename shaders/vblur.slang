#version 450
// Real CRT Phosphor v1.4.3 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
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
    // v1.1.1: the output stays in LINEAR light (float buffer): rgb already includes the white point,
    // alpha is the linear brightness. The screen-size beam pass then needs no pow() at all
    // (it used to decode gamma 32 times per screen pixel, which is slow on phone/tablet GPUs).
    float vb = global.VERT_BLUR;
    float ge = 2.2 * global.GAMMA_IN;
    vec3 wp = vec3(global.WP_R, global.WP_G, global.WP_B);
    if (vb < 0.01) {
        vec4 c = pow(clamp(texture(Source, vTexCoord), 0.0, 1.0), vec4(ge));
        FragColor = vec4(c.rgb * wp, c.a); return;
    }
    float N  = gk_box(params.SourceSize.y);
    vec2 stp = vec2(0.0, N * params.SourceSize.w);
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
    acc /= ws;
    FragColor = vec4(acc.rgb * wp, acc.a);
}
