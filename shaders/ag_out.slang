#version 450
// Real CRT Phosphor v1.4 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 7: phosphor afterglow output. Puts the remembered glow, scaled by the strength, under the current picture.
// max(now, strength x memory): still pictures stay exactly as they were.
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
layout(set = 0, binding = 2) uniform sampler2D Source;   // afterglow memory (pass 6)
layout(set = 0, binding = 3) uniform sampler2D SigRaw;   // linear signal without afterglow (pass 5)
void main()
{
    vec4 cur = texture(SigRaw, vTexCoord);
    float s = global.AFTERGLOW;
    if (s < 0.001) { FragColor = cur; return; }
    FragColor = max(cur, texture(Source, vTexCoord) * s);
}
