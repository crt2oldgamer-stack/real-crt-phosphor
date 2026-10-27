#version 450
// Real CRT Phosphor v1.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 0: supersample down to the console's native grid (3D games rendered at 2x/4x get averaged = smooth polygons)
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
    float N = gk_box(params.SourceSize.y);
    if (N < 1.5) { FragColor = vec4(texture(Source, vTexCoord).rgb, 1.0); return; }
    vec2 tex = floor(vTexCoord * params.SourceSize.xy);
    vec2 blk = floor(tex / N) * N;
    vec3 acc = vec3(0.0);
    float cnt = 0.0;
    for (int y = 0; y < 8; y++) {
        if (float(y) >= N) break;
        for (int x = 0; x < 8; x++) {
            if (float(x) >= N) break;
            vec3 c = texture(Source, (blk + vec2(float(x), float(y)) + 0.5) * params.SourceSize.zw).rgb;
            acc += c * c;           // average in (approx) linear light
            cnt += 1.0;
        }
    }
    FragColor = vec4(sqrt(acc / cnt), 1.0);
}
