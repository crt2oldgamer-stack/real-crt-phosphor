// Real CRT Phosphor v1.1 - AI-assisted (Claude / ChatGPT), by gunkun. Non-commercial use free. See LICENSE.txt
// ---- shared helpers (included by every pass) ----
// Input height relative to a 240-line TV picture: 1 = 240p/224p, 2 = 480 (hi-res/interlaced OR 2x upscale), 4 = 960 ...
float gk_L(float srcH)   { return max(1.0, floor(srcH / 240.0 + 0.5)); }
// Supersample factor: average 3D upscales down, but never below a 480-class picture, so real hi-res
// screens (PS1 640x480 menus/text, SNES 512 modes) keep their detail.
float gk_box(float srcH) { if (global.CONTENT_SCALE > 0.5) return floor(global.CONTENT_SCALE + 0.5); float L = gk_L(srcH); return (mod(L, 2.0) < 0.5) ? L * 0.5 : L; }
// Content rows drawn inside one scanline: 1 for 240-class, 2 for 480-class pictures
float gk_rows(float srcH){ if (global.RASTER_LINES > 0.5) return max(1.0, (srcH / gk_box(srcH)) / global.RASTER_LINES); return gk_L(srcH) / gk_box(srcH); }
// Blur widths are in content pixels, scaled a little for wider screens (Mega Drive 320 = 1.25), capped so hi-res text stays sharp
float gk_k(float nW)     { return clamp(nW / 256.0, 0.5, 1.25); }
vec3 gk_toYIQ(vec3 c) {
    return vec3(dot(c, vec3(0.299, 0.587, 0.114)),
                dot(c, vec3(0.596, -0.274, -0.322)),
                dot(c, vec3(0.211, -0.523, 0.312)));
}
vec3 gk_fromYIQ(vec3 c) {
    return vec3(c.x + 0.956 * c.y + 0.621 * c.z,
                c.x - 0.272 * c.y - 0.647 * c.z,
                c.x - 1.106 * c.y + 1.703 * c.z);
}
float gk_erfc(float x) {
    float z = abs(x);
    float t = 1.0 / (1.0 + 0.3275911 * z);
    float y = t * (0.254829592 + t * (-0.284496736 + t * (1.421413741 + t * (-1.453152027 + t * 1.061405429)))) * exp(-z * z);
    return (x >= 0.0) ? y : 2.0 - y;
}
// gaussian blur followed by an analog RC low-pass: smear trails to the right (later in the scan line)
float gk_exgauss(float t, float s, float tau) {
    s = max(s, 0.05);
    if (tau < 0.05) return exp(-0.5 * t * t / (s * s));
    float l = 1.0 / tau;
    float e = clamp(l * (0.5 * l * s * s - t), -80.0, 80.0);
    return exp(e) * gk_erfc((l * s * s - t) / (1.41421356 * s));
}

// RGB triad pitch in screen px (4K: 6 px = 2 px per colour stripe)
float gk_triad(float outH) { float T = global.MASK_PITCH; if (T < 0.5) T = max(3.0, floor(outH / 2160.0 * 6.0 * global.MASK_SIZE + 0.5)); return T; }

// Integral of a normalised gaussian over [a,b] (arguments already divided by sigma*sqrt(2)); tail form avoids cancellation
float gk_normalInterval(float a, float b) {
    if (a >= 0.0) return 0.5 * (gk_erfc(a) - gk_erfc(b));
    if (b <= 0.0) return 0.5 * (gk_erfc(-b) - gk_erfc(-a));
    return 1.0 - 0.5 * (gk_erfc(-a) + gk_erfc(b));
}
// Signed area of a smoothstep-edged stripe (full width w, edge fraction e) from its centre to x, in screen px
float gk_stripePrimitive(float x, float w, float e) {
    float h = 0.5 * w;
    float inner = h * (1.0 - e);
    float r = min(abs(x), h);
    float t = clamp((h - r) / max(h * e, 1e-8), 0.0, 1.0);
    float area = (r <= inner) ? r : inner + h * e * (0.5 - t * t * t + 0.5 * t * t * t * t);
    return sign(x) * area;
}
