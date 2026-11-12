#version 450
// Real CRT Phosphor v1.4.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 1: composite-style dither blending (static). 1-pixel alternating columns (A B A B) - the Mega Drive
// "fake transparency" trick - are melted together the way a composite TV did, without any moving artifacts.
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
float gk_d(vec3 a, vec3 b) { vec3 e = abs(a - b); return max(e.r, max(e.g, e.b)); }
// is c0 part of a 1-pixel alternating pattern? (neighbours match each other, every second pixel matches c0)
float gk_isdit(vec3 l2, vec3 l1, vec3 c0, vec3 r1, vec3 r2)
{
    float same = max(gk_d(l1, r1), max(gk_d(l2, c0), gk_d(r2, c0)));
    float diff = gk_d(c0, 0.5 * (l1 + r1));
    return (1.0 - smoothstep(0.03, 0.08, same)) * smoothstep(0.04, 0.10, diff);
}
void main()
{
    vec3 c0 = texture(Source, vTexCoord).rgb;
    if (global.DITHER < 0.01) { FragColor = vec4(c0, 1.0); return; }
    float N = gk_box(params.SourceSize.y);
    vec2 s = vec2(N * params.SourceSize.z, 0.0);
    vec3 l1 = texture(Source, vTexCoord - s).rgb,       r1 = texture(Source, vTexCoord + s).rgb;
    vec3 l2 = texture(Source, vTexCoord - 2.0 * s).rgb, r2 = texture(Source, vTexCoord + 2.0 * s).rgb;
    vec3 l3 = texture(Source, vTexCoord - 3.0 * s).rgb, r3 = texture(Source, vTexCoord + 3.0 * s).rgb;
    float w = gk_isdit(l2, l1, c0, r1, r2);
    // also melt the last column at the edge of a dithered area, so no hard stripe is left at its border
    w = max(w, 0.5 * max(gk_isdit(l3, l2, l1, c0, r1), gk_isdit(l1, c0, r1, r2, r3)));
    vec3 blend = 0.5 * c0 + 0.25 * (l1 + r1);
    FragColor = vec4(mix(c0, blend, global.DITHER * w), 1.0);
}
