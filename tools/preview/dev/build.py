# Builds crt-preview.html from the Real CRT Phosphor slang sources (so shader updates can be re-ported automatically)
# Usage: python build.py <real-crt-phosphor shader folder> [output.html]   (needs only Python 3, no extra packages)
import re, json, os, sys
SH = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'real-crt-phosphor')
OUT = sys.argv[2] if len(sys.argv) > 2 else 'crt-preview.html'
S = lambda p: open(os.path.join(SH, p), encoding='utf-8').read()

params_src = S('shaders/params.inc')
ubo_src = S('shaders/ubo.inc')
common_src = S('shaders/common.inc')

# ---- parameters (labels, defaults, ranges) straight from params.inc
params = []
for m in re.finditer(r'#pragma parameter (\w+) "([^"]*)" ([-\d.]+) ([-\d.]+) ([-\d.]+) ([-\d.]+)', params_src):
    n, lab, d, lo, hi, st = m.groups()
    params.append(dict(name=n, label=lab.strip(), d=float(d), lo=float(lo), hi=float(hi), st=float(st)))
names = re.findall(r'\b([A-Z][A-Z0-9_]+)\b', re.search(r'uniform UBO\s*\{(.*?)\}', ubo_src, re.S).group(1))
names = [n for n in names if n != 'MVP']

uni_decl = 'uniform float ' + ', '.join(names) + ';\n'
to_linear = ubo_src[ubo_src.index('vec3 gk_toLinear'):]
common = re.sub(r'^//.*$', '', common_src, flags=re.M)
HEAD = ('#version 300 es\nprecision highp float;\nprecision highp int;\n'
        'uniform vec4 SourceSize, OriginalSize, OutputSize, DitherSize, KernSize, SignalSize;\nuniform uint FrameCount;\n'
        + uni_decl + (to_linear + '\n' + common).replace('global.', '') + '\n')

def port(src):
    src = src.replace('global.', '').replace('params.', '')
    src = re.sub(r'#version 450\n', '', src)
    src = re.sub(r'layout\(push_constant\)[^\n]*\n', '', src)
    src = re.sub(r'#include "[^"]+"\n', '', src)
    vs, fs = src.split('#pragma stage fragment')
    pre, vs = vs.split('#pragma stage vertex')
    vs = vs.replace('layout(location = 0) in vec4 Position;\nlayout(location = 1) in vec2 TexCoord;\n', 'in vec2 aPos;\n')
    vs = vs.replace('gl_Position = MVP * Position;', 'gl_Position = vec4(aPos, 0.0, 1.0);')
    vs = vs.replace('vTexCoord = TexCoord;', 'vTexCoord = aPos * 0.5 + 0.5;')
    for s in (vs, fs):
        pass
    vs = re.sub(r'layout\(location = \d+\) ', '', vs)
    fs = re.sub(r'layout\(location = \d+\) ', '', fs)
    fs = re.sub(r'layout\(set = 0, binding = \d+\) uniform sampler2D (\w+);', r'uniform sampler2D \1;', fs)
    return HEAD + pre + vs, HEAD + pre + fs

files = ['box','dither','soft','kern','signal','vblur','glow_h','glow_v','beam','rgb','post_h','post_v']
passes = [dict(zip(('vs','fs'), port(S(f'shaders/{f}.slang'))), name=f) for f in files]

# ---- presets: resolve every #reference chain into full value sets
def parse_preset(path, seen=()):
    txt = open(path, encoding='utf-8').read()
    vals = {}
    ref = re.search(r'#reference "([^"]+)"', txt)
    if ref:
        rp = os.path.normpath(os.path.join(os.path.dirname(path), ref.group(1)))
        if os.path.basename(rp) != 'real-crt-phosphor.slangp':
            vals.update(parse_preset(rp))
    for k, v in re.findall(r'^(\w+) = "([-\d.]+)"', txt, re.M):
        vals[k] = float(v)
    return vals
presets = {'real-crt-phosphor.slangp': dict(path='real-crt-phosphor.slangp', vals={}, folder='')}
for folder in ('4K', 'Ally'):
    d = os.path.join(SH, 'presets', folder)
    for f in sorted(os.listdir(d)):
        if f.endswith('.slangp'):
            presets[f] = dict(path=f'presets/{folder}/{f}', vals=parse_preset(os.path.join(d, f)), folder=folder)

ver = re.search(r'Real CRT Phosphor (v[\d.]+)', params_src).group(1)
html = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'template.html'), encoding='utf-8').read()
html = html.replace('__PASSES__', json.dumps(passes)).replace('__PARAMS__', json.dumps(params))
html = html.replace('__PRESETS__', json.dumps(presets)).replace('__VER__', ver)
import base64
smp = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sample_320x240.png')
html = html.replace('__SAMPLE__', 'data:image/png;base64,' + base64.b64encode(open(smp, 'rb').read()).decode() if os.path.exists(smp) else '')
open(OUT, 'w', encoding='utf-8').write(html)
print('built', OUT, len(html), 'bytes;', len(params), 'params;', len(presets), 'presets')
