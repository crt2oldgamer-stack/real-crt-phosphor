#version 450
// Real CRT Phosphor v1.4 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Pass 6: phosphor afterglow memory. Keeps, per game pixel and channel, the brighter of "light now" and
// "light from the frames before, decayed". It reads its own previous output (AGMemFeedback).
// A still picture is unchanged; only places something has moved away from keep a fading glow.
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
layout(set = 0, binding = 2) uniform sampler2D Source;          // linear signal (pass 5)
layout(set = 0, binding = 3) uniform sampler2D AGMemFeedback;   // this pass, previous frame
void main()
{
    vec4 cur = texture(Source, vTexCoord);
    if (global.AFTERGLOW < 0.001) { FragColor = cur; return; }
    // per-frame decay so the trail LOOKS 10 % as bright after AG_TIME ms (60 frames a second).
    // The eye sees dim light brighter than it is (about light^(1/2.2)), so "looks 10 %" means
    // 0.1^2.2 = 0.6 % of the light. Red phosphor decays AG_RED times slower; alpha (beam
    // brightness) follows green/blue. (Real consumer CRTs: about 1 ms or less - this is a look.)
    float T  = max(global.AG_TIME, 1.0);
    float d  = pow(0.1, 2.2 * 16.6667 / T);
    float dr = pow(0.1, 2.2 * 16.6667 / (T * max(global.AG_RED, 1.0)));
    vec4 prev = texture(AGMemFeedback, vTexCoord);
    FragColor = max(cur, prev * vec4(dr, d, d, d));
}
