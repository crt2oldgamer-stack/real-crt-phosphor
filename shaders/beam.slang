#version 450
// Real CRT Phosphor v1.2 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 10: scanline beams + glow, linear light at screen size (no mask yet)
layout(push_constant) uniform Push { vec4 SourceSize; vec4 OriginalSize; vec4 OutputSize; uint FrameCount; vec4 SignalSize; } params;
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
layout(set = 0, binding = 2) uniform sampler2D Source;   // glow
layout(set = 0, binding = 3) uniform sampler2D Signal;   // graded signal in linear light, alpha = linear ungraded brightness
void main()
{
    vec4 SS = params.SignalSize;
    float N = gk_box(SS.y);
    float R = gk_rows(SS.y);
    float Hc = SS.y / N;
    float lines = Hc / R;
    float nW = SS.x / N;
    float ny = vTexCoord.y * lines;
    float rowHere = floor(vTexCoord.y * Hc);
    float nx = vTexCoord.x * nW - 0.5;
    float x0 = floor(nx);
    float fx = nx - x0;
    float base = floor(ny - 0.5);
    vec3 acc = vec3(0.0);
    for (int k = -1; k <= 2; k++) {
        float li = clamp(base + float(k), 0.0, lines - 1.0);
        float d  = abs(ny - (base + float(k) + 0.5));
        float row = clamp(rowHere, li * R, li * R + R - 1.0);
        float yT = (row + 0.5) * N * SS.w;
        vec4 sA = texture(Signal, vec2((clamp(x0,       0.0, nW - 1.0) + 0.5) * N * SS.z, yT));
        vec4 sB = texture(Signal, vec2((clamp(x0 + 1.0, 0.0, nW - 1.0) + 0.5) * N * SS.z, yT));
        vec3 col = mix(sA.rgb, sB.rgb, fx);          // v1.1.1: Signal is stored linear
        float lu = mix(sA.a, sB.a, fx);
        float w = global.BEAM_DARK + (global.BEAM_BRIGHT - global.BEAM_DARK) * sqrt(clamp(lu, 0.0, 1.0));
        acc += col * exp(-0.5 * (d / w) * (d / w)) / (w * 2.5066);
    }
    acc += global.GLOW * texture(Source, vTexCoord).rgb;
    FragColor = vec4(acc, 1.0);
}
