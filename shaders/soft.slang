#version 450
// Real CRT Phosphor v1.4 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 2: small blur in every direction (up/down/left/right at once), linear light, on the native pixel grid.
// Balances the rightward analog smear so softening does not lean to one side.
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
    float sa = global.SOFT_ALL;
    if (sa < 0.01) { FragColor = vec4(texture(Source, vTexCoord).rgb, 1.0); return; }
    float N = gk_box(params.SourceSize.y);
    vec2 st = N * params.SourceSize.zw;          // one content pixel in each direction
    vec3 acc = vec3(0.0); float ws = 0.0;
    for (int y = -2; y <= 2; y++) {
        for (int x = -2; x <= 2; x++) {
            float w = exp(-0.5 * float(x * x + y * y) / (sa * sa));
            vec3 c = texture(Source, vTexCoord + vec2(float(x), float(y)) * st).rgb;
            acc += w * c * c;                     // approx. linear light (gamma 2)
            ws += w;
        }
    }
    FragColor = vec4(sqrt(acc / ws), 1.0);
}
