#version 450
// GBA Comfort Color v1.0 - by gunkun, AI-assisted (Claude). Non-commercial use free.
// Color only, no CRT effects: one light pass for handhelds.
// Many GBA games use very bright, neon-like colors (strong blue, neon green), because the old LCD screens were dark.
// On a modern screen they can be hard on the eyes. This tones those strong colors down for comfortable play.

layout(push_constant) uniform Push { vec4 SourceSize; vec4 OriginalSize; vec4 OutputSize; uint FrameCount; } params;

#pragma parameter RGC_TITLE "=== GBA Comfort Color v1.0 ===" 0.0 0.0 0.0 1.0
#pragma parameter RGC_SP1 " " 0.0 0.0 0.0 1.0
#pragma parameter RGC_H1 "[ GBA COMFORT COLOR ]" 0.0 0.0 0.0 1.0
#pragma parameter GBA_ON "    GBA Comfort Color: 0 off / 1 on" 1.0 0.0 1.0 1.0
#pragma parameter GBA_LCD_BRIGHT "    LCD brightness" 1.0 0.3 1.5 0.01
#pragma parameter GBA_LCD_SAT "    LCD saturation" 1.0 0.0 1.5 0.01
#pragma parameter GBA_VIOLET "    Violet toward blue (degrees)" 15.0 0.0 30.0 1.0
#pragma parameter GBA_YELLOW "    Yellow skin toward red" 0.25 0.0 0.5 0.01
#pragma parameter GBA_PRIM "    Desaturate near-primary colors" 0.5 0.0 1.0 0.01
#pragma parameter GBA_PRIM_LIFT "    Keep their brightness (0 luma, 1 brightest)" 0.5 0.0 1.0 0.01
#pragma parameter GBA_START "    Limit starts at (brightness)" 0.30 0.02 0.95 0.01
#pragma parameter GBA_KEEP "    Keep above the limit" 0.20 0.0 1.0 0.01
#pragma parameter GBA_PURE "    Only pure colors (higher = purer only)" 1.2 0.2 3.0 0.05
#pragma parameter GBA_DIM "    Other channels dim along" 0.80 0.0 1.0 0.01
#pragma parameter GBA_WASH "    Wash strong colors toward grey" 0.36 0.0 1.0 0.01
#pragma parameter GBA_B "    Strength on blue" 0.42 0.0 1.0 0.01
#pragma parameter GBA_G "    Strength on green" 0.45 0.0 1.0 0.01
#pragma parameter GBA_R "    Strength on red" 0.41 0.0 1.0 0.01
#pragma parameter GBA_DEEP "    Extra dark for deep blue (no white in it)" 0.16 0.0 1.0 0.01
#pragma parameter GBA_SECOND "    Strength on yellow / lime / cyan / magenta" 0.0 0.0 1.0 0.01
#pragma parameter RGC_SP2 " " 0.0 0.0 0.0 1.0
#pragma parameter RGC_H2 "[ COLOR GRADE ]" 0.0 0.0 0.0 1.0
#pragma parameter GBA_SATURATION "    Saturation" 0.81 0.0 2.0 0.01
#pragma parameter GBA_HUE "    Hue (tint, degrees)" 5.0 -30.0 30.0 1.0
#pragma parameter GBA_LV_BLACK "    Levels black point" 0.12 0.0 0.40 0.01
#pragma parameter GBA_LV_WHITE "    Levels white point" 0.87 0.60 1.00 0.01
#pragma parameter GBA_S_LOW "    S-curve shadows" 0.50 0.0 1.0 0.05
#pragma parameter GBA_S_HIGH "    S-curve highlights" 0.15 0.0 1.0 0.05
#pragma parameter GBA_GAMMA "    Gamma (x2.2)" 1.09 0.8 1.6 0.01
#pragma parameter GBA_WP_R "    White balance R" 0.68 0.5 1.2 0.01
#pragma parameter GBA_WP_G "    White balance G" 0.69 0.5 1.2 0.01
#pragma parameter GBA_WP_B "    White balance B" 0.68 0.5 1.2 0.01
#pragma parameter GBA_KNEE "    Highlight roll-off starts at" 0.80 0.5 1.0 0.01
#pragma parameter GBA_BRIGHTNESS "    Brightness" 0.85 0.5 3.0 0.01

layout(std140, set = 0, binding = 0) uniform UBO {
    mat4 MVP;
    float RGC_TITLE, RGC_SP1, RGC_H1, GBA_ON, GBA_LCD_BRIGHT, GBA_LCD_SAT, GBA_VIOLET, GBA_YELLOW, GBA_PRIM, GBA_PRIM_LIFT, GBA_START, GBA_KEEP, GBA_PURE, GBA_DIM, GBA_WASH, GBA_B, GBA_G, GBA_R, GBA_DEEP, GBA_SECOND;
    float RGC_SP2, RGC_H2, GBA_SATURATION, GBA_HUE, GBA_LV_BLACK, GBA_LV_WHITE, GBA_S_LOW, GBA_S_HIGH, GBA_GAMMA, GBA_WP_R, GBA_WP_G, GBA_WP_B, GBA_KNEE, GBA_BRIGHTNESS;
} global;

#pragma stage vertex
layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;
void main() { gl_Position = global.MVP * Position; vTexCoord = TexCoord; }

#pragma stage fragment
layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 FragColor;
layout(set = 0, binding = 2) uniform sampler2D Source;

// The leading channel above GBA_START is squeezed (soft knee, slope GBA_KEEP), more for purer colors, with a strength
// per channel; the others dim along (GBA_DIM) and strong colors wash toward grey (GBA_WASH). White, greys and pale
// colors stay as they are; the brightness order never flips.
vec3 limitGBA(vec3 c)
{
    int k = c.r > c.g ? 0 : 1; if (c.b > c[k]) k = 2;
    float x = c[k], o = max(c[(k + 1) % 3], c[(k + 2) % 3]), e = x - o;
    float st = k == 0 ? global.GBA_R : (k == 1 ? global.GBA_G : global.GBA_B);
    if (e <= 0.0 || x <= 0.0 || st <= 0.0) return c;
    float W = 0.08, d = x - global.GBA_START;
    float g = d <= -W ? 0.0 : (d >= W ? d : (d + W) * (d + W) / (4.0 * W));
    float s = st * pow(smoothstep(0.0, 1.0, e / x), global.GBA_PURE);
    float xx = x - s * (1.0 - global.GBA_KEEP) * g;
    float sc = 1.0 + (xx / x - 1.0) * global.GBA_DIM;
    vec3 r = c * sc; r[k] = xx;
    r = mix(r, vec3(dot(r, vec3(0.299, 0.587, 0.114))), global.GBA_WASH * s);
    // deep blues with no white in them (space, sea) sink further; fades in as blue clearly leads (none at teal)
    if (k == 2) r *= 1.0 - global.GBA_DEEP * smoothstep(0.0, 0.6, e / x) * pow(1.0 - min(c.r, c.g) / x, 6.0);
    return r;
}
// Two-channel strong colors (yellow, lime, cyan, magenta): limitGBA only squeezes ONE leading channel, so colors where
// two channels are high together (neon lime fields, yellow) stayed bright. Here such colors are scaled down by ONE
// factor for the whole color family: neighbouring shades of the same color (dithered grass) are scaled alike, so their
// brightness and hue differences stay (a soft knee would squeeze the brighter shade more and flatten the texture).
// The factor only depends on "is it a two-channel color" (saturates early) and fades out for dark colors.
// The third channel dims along (GBA_DIM), a little wash toward grey (GBA_WASH). Primaries, greys, pale colors: untouched.
vec3 limitSecond(vec3 c)
{
    if (global.GBA_SECOND <= 0.0) return c;
    int j = c.r < c.g ? 0 : 1; if (c.b < c[j]) j = 2;               // the low channel
    float x = max(c.r, max(c.g, c.b)), m = c[j], y = c.r + c.g + c.b - x - m;
    if (x <= 0.0 || y <= m) return c;
    float pair = smoothstep(0.25, 0.6, (y - m) / x) * smoothstep(0.35, 0.75, y / x);   // two channels high, third low
    float L = dot(c, vec3(0.299, 0.587, 0.114));
    float a = global.GBA_SECOND * pair * smoothstep(0.15, global.GBA_START + 0.25, L);  // same for all bright shades
    float f = 1.0 - 0.5 * a;
    vec3 r = c * f; r[j] = m * (1.0 + (f - 1.0) * global.GBA_DIM);
    return mix(r, vec3(dot(r, vec3(0.299, 0.587, 0.114))), global.GBA_WASH * 0.5 * a);
}
// Violet toward blue: GBA artists often painted blue mechs violet (hue 255-285) so they stood out from blue
// backgrounds on the weak-blue LCD. This turns only that violet band toward blue (luma kept, YIQ rotation);
// pure blue (240), magenta (300) and greys are not touched.
vec3 violetToBlue(vec3 c, float deg)
{
    float mx = max(c.r, max(c.g, c.b)), mn = min(c.r, min(c.g, c.b)), d = mx - mn;
    if (deg <= 0.0 || d <= 1e-5) return c;
    float h = mx == c.r ? mod((c.g - c.b) / d, 6.0) : (mx == c.g ? (c.b - c.r) / d + 2.0 : (c.r - c.g) / d + 4.0);
    h *= 60.0; if (h < 0.0) h += 360.0;
    float w = smoothstep(240.0, 262.0, h) * (1.0 - smoothstep(282.0, 300.0, h)) * smoothstep(0.15, 0.4, d / mx);
    float a = radians(deg * w);
    vec3 y = vec3(dot(c, vec3(0.299, 0.587, 0.114)), dot(c, vec3(0.596, -0.274, -0.322)), dot(c, vec3(0.211, -0.523, 0.312)));
    vec2 iq = vec2(y.y * cos(a) - y.z * sin(a), y.y * sin(a) + y.z * cos(a));
    return clamp(vec3(y.x + 0.956 * iq.x + 0.621 * iq.y, y.x - 0.272 * iq.x - 0.647 * iq.y, y.x - 1.106 * iq.x + 1.703 * iq.y), 0.0, 1.0);
}
// Yellow skin toward red: some faces were drawn yellower than their artwork (Kyosuke in SRW OG is 7-8 degrees
// yellower). In the yellow-skin band (full 33-46, fading out by 28 and 54) green is lowered toward the smallest
// channel, so the hue drops in proportion with no pink cast. Peach skin, orange hair, reds and pure yellow stay.
vec3 yellowToRed(vec3 c, float amt)
{
    float mx = max(c.r, max(c.g, c.b)), mn = min(c.r, min(c.g, c.b)), d = mx - mn;
    if (amt <= 0.0 || d <= 1e-5 || mx != c.r || c.g < c.b) return c;
    float h = 60.0 * (c.g - c.b) / d;
    float w = smoothstep(28.0, 33.0, h) * (1.0 - smoothstep(46.0, 54.0, h)) * smoothstep(0.08, 0.25, d / mx);
    c.g -= amt * w * (c.g - mn);
    return c;
}
vec3 realGBA(vec3 c)
{
    if (global.GBA_ON < 0.5) return c;
    vec3 r = limitSecond(limitGBA(yellowToRed(violetToBlue(c, global.GBA_VIOLET), global.GBA_YELLOW)));
    // LCD panel brightness and saturation, before everything else, on every color
    r = mix(vec3(dot(r, vec3(0.299, 0.587, 0.114))), r, global.GBA_LCD_SAT) * global.GBA_LCD_BRIGHT;
    return clamp(r, 0.0, 1.0);
}

vec3 toYIQ(vec3 c)   { return vec3(dot(c, vec3(0.299, 0.587, 0.114)), dot(c, vec3(0.596, -0.274, -0.322)), dot(c, vec3(0.211, -0.523, 0.312))); }
vec3 fromYIQ(vec3 c) { return vec3(c.x + 0.956 * c.y + 0.621 * c.z, c.x - 0.272 * c.y - 0.647 * c.z, c.x - 1.106 * c.y + 1.703 * c.z); }

void main()
{
    vec3 rgb = realGBA(texture(Source, vTexCoord).rgb);

    // hue and saturation (YIQ), levels, S-curve: same order as Real CRT Phosphor
    vec3 yiq = toYIQ(rgb);
    float h = radians(global.GBA_HUE);
    vec2 c = vec2(yiq.y * cos(h) - yiq.z * sin(h), yiq.y * sin(h) + yiq.z * cos(h)) * global.GBA_SATURATION;
    rgb = clamp(fromYIQ(vec3(yiq.x, c)), 0.0, 1.0);
    rgb = clamp((rgb - global.GBA_LV_BLACK) / max(global.GBA_LV_WHITE - global.GBA_LV_BLACK, 0.01), 0.0, 1.0);
    vec3 sm = rgb * rgb * (3.0 - 2.0 * rgb);
    vec3 kk = mix(vec3(global.GBA_S_HIGH), vec3(global.GBA_S_LOW), step(rgb, vec3(0.5)));
    rgb = rgb + kk * (sm - rgb);
    // near-primary colors toward grey, after the levels (the black point would otherwise re-saturate dark colors).
    // Saturation above 0.5 is squeezed on a soft knee with slope (1 - GBA_PRIM): a color that was more saturated
    // stays more saturated, so a deep blue background never meets a grey-blue line drawn on it (SRW A map grid).
    if (global.GBA_ON > 0.5 && global.GBA_PRIM > 0.0) {
        float mx = max(rgb.r, max(rgb.g, rgb.b)), mn = min(rgb.r, min(rgb.g, rgb.b));
        float sat = mx > 1e-5 ? (mx - mn) / mx : 0.0;
        float W = 0.1, d = sat - 0.5;
        float g = d <= -W ? 0.0 : (d >= W ? d : (d + W) * (d + W) / (4.0 * W));
        float t = sat > 1e-5 ? global.GBA_PRIM * g / sat : 0.0;    // share of the way to grey that gives sat - PRIM * knee
        rgb = mix(rgb, vec3(mix(dot(rgb, vec3(0.299, 0.587, 0.114)), mx, global.GBA_PRIM_LIFT)), t);   // grey target: luma, or up to the brightest channel
    }

    // gamma and white balance in linear light, brightness with a soft highlight roll-off, back to the screen
    vec3 lin = pow(rgb, vec3(2.2 * global.GBA_GAMMA)) * vec3(global.GBA_WP_R, global.GBA_WP_G, global.GBA_WP_B) * global.GBA_BRIGHTNESS;
    float kn = clamp(global.GBA_KNEE, 0.5, 0.999);
    vec3 over = max(lin - kn, vec3(0.0));
    lin = min(lin, vec3(kn)) + (1.0 - kn) * (1.0 - exp(-over / (1.0 - kn)));
    FragColor = vec4(pow(clamp(lin, 0.0, 1.0), vec3(1.0 / 2.2)), 1.0);
}
