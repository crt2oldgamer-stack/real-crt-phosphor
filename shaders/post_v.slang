#version 450
// Real CRT Phosphor v1.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// Real CRT Phosphor Opt Test 2: unchanged discrete Gaussian, weights computed per vertex.
// Requires filter_linear=true for this pass; no mipmaps.
// Kernel weights and offsets depend only on uniforms: compute per vertex.
layout(push_constant) uniform Push { vec4 SourceSize; vec4 OriginalSize; vec4 OutputSize; uint FrameCount; } params;
#include "params.inc"
#include "ubo.inc"
#include "common.inc"
#pragma stage vertex
layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;
layout(location = 1) flat out vec2 vBlurMeta;
layout(location = 2) flat out vec4 vBlurPairs[6]; // two (weight, offset) pairs per vec4
void main()
{
    gl_Position = global.MVP * Position;
    vTexCoord = TexCoord;
    for (int i = 0; i < 6; i++) vBlurPairs[i] = vec4(0.0);
    float Tq = gk_triad(params.OutputSize.y);
    float s0 = global.RGB_BLUR_Y * Tq / 6.0;
    float sf = global.FINAL_BLUR * Tq / 6.0;
    float s = sqrt(s0 * s0 + sf * sf);
    float ws = 1.0;
    int count = 0;
    if (s > 0.05) {
        int r = min(int(ceil(3.0 * s)), 24);
        for (int i = 0; i < 12; i++) {
            int j = 2 * i + 1;
            if (j > r) break;
            float wa = exp(-0.5 * float(j * j) / (s * s));
            float wb = 0.0;
            if (j + 1 <= r) wb = exp(-0.5 * float((j + 1) * (j + 1)) / (s * s));
            float pairWeight = wa + wb;
            // With s > 0.05, the retained range normally gives positive weights.
            // Guard underflow near zero softness without introducing a NaN offset.
            if (pairWeight <= 0.0) continue;
            float offset = float(j) + wb / pairWeight;
            int slot = count / 2;
            if ((count % 2) == 0) vBlurPairs[slot].xy = vec2(pairWeight, offset);
            else vBlurPairs[slot].zw = vec2(pairWeight, offset);
            ws += 2.0 * pairWeight;
            count++;
        }
    }
    vBlurMeta = vec2(1.0 / ws, float(count));
}
#pragma stage fragment
layout(location = 0) in vec2 vTexCoord;
layout(location = 1) flat in vec2 vBlurMeta;
layout(location = 2) flat in vec4 vBlurPairs[6];
layout(location = 0) out vec4 FragColor;
layout(set = 0, binding = 2) uniform sampler2D Source;
void main()
{
    vec3 acc = textureLod(Source, vTexCoord, 0.0).rgb;
    vec2 stepUV = vec2(0.0, params.SourceSize.w);
    int count = int(vBlurMeta.y + 0.5);
    for (int i = 0; i < 12; i++) {
        if (i >= count) break;
        vec4 packedPair = vBlurPairs[i / 2];
        vec2 pairData = ((i % 2) == 0) ? packedPair.xy : packedPair.zw;
        vec2 offsetUV = pairData.y * stepUV;
        acc += pairData.x * (textureLod(Source, vTexCoord + offsetUV, 0.0).rgb
                          + textureLod(Source, vTexCoord - offsetUV, 0.0).rgb);
    }
    acc *= vBlurMeta.x;

    acc *= global.BRIGHT;
    float kn = clamp(global.KNEE, 0.5, 0.999);
    vec3 over = max(acc - kn, vec3(0.0));
    acc = min(acc, vec3(kn)) + (1.0 - kn) * (1.0 - exp(-over / (1.0 - kn)));
    FragColor = vec4(pow(clamp(acc, 0.0, 1.0), vec3(1.0 / 2.2)), 1.0);
}
