# Original 320x240 test scene (no game assets): sunset, mountains, water, an original robot sprite, HUD text, test strip
from PIL import Image, ImageDraw
import math
W,H=320,240
im=Image.new('RGB',(W,H)); px=im.load()
q=lambda c: tuple((v//8)*8+4 if v<252 else 255 for v in c)       # 15-bit style colours
sky=[(24,16,56),(48,24,88),(88,32,112),(136,48,120),(184,72,112),(224,104,96),(248,144,88),(252,188,104)]
for y in range(150):
    i=min(7,y*8//150); px_row=q(sky[i])
    for x in range(W): px[x,y]=px_row
    # dithered band edge (1px checker) like old hardware gradients
    if y%19 in (17,18) and i<7:
        for x in range(W):
            if (x+y)%2==0: px[x,y]=q(sky[i+1])
d=ImageDraw.Draw(im)
# sun with scanline gaps
for y in range(78,140):
    for x in range(200,262):
        if (x-231)**2+(y-110)**2<=30**2 and not (y>112 and y%4==0): px[x,y]=q((255,232,150))
# stars
for (x,y) in [(14,8),(40,22),(70,12),(110,30),(150,6),(186,18),(290,10),(306,30),(256,24),(128,14)]: px[x,y]=(255,255,255)
# mountains (two layers)
for x in range(W):
    h1=int(96+18*math.sin(x/23)+10*math.sin(x/9+1)); h2=int(122+10*math.sin(x/15+2)+6*math.sin(x/5))
    for y in range(h1,150): px[x,y]=q((56,40,96))
    for y in range(h2,150): px[x,y]=q((28,24,60))
# water with reflection lines
for y in range(150,200):
    for x in range(W):
        px[x,y]=q((16,32,72)) if (y//3)%2 else q((24,48,96))
        if 200<x<262 and y%3==0 and (x+y*7)%11<7 and y<185: px[x,y]=q((248,176,104))
# cliff
d.polygon([(0,150),(0,118),(36,112),(72,120),(96,150)],fill=q((40,28,32)))
d.rectangle([0,150,90,160],fill=q((40,28,32)))
d.line([(0,118),(36,112),(72,120)],fill=q((104,72,64)))
# original robot "Bolt": 20x26 at (40,86)
R=[
".......kk.........",
"......kyyk........",
".......kk.........",
"..kkkkkkkkkkkkk...",
".kwwwwwwwwwwwwwk..",
".kwgggggggggggwk..",
".kwgcckgggkccgwk..",
".kwgcckgggkccgwk..",
".kwgggggggggggwk..",
".kwggrrrrrrrggwk..",
".kwwwwwwwwwwwwwk..",
"..kkkkkkkkkkkkk...",
"....kbbbbbbbk.....",
"..kkbbwwwwwbbkk...",
".kbbkbwrrrwbkbbk..",
".kbbkbwrrrwbkbbk..",
".kwwkbwwwwwbkwwk..",
"..kk.kbbbbbk.kk...",
".....kbk.kbk......",
".....kbk.kbk......",
"....kkkk.kkkk.....",
]
P={'k':(16,16,24),'y':(255,220,64),'w':(220,224,232),'g':(56,72,88),'c':(96,240,255),'r':(232,56,56),'b':(64,104,200)}
for j,row in enumerate(R):
    for i,ch in enumerate(row):
        if ch in P: px[40+i,90+j]=q(P[ch])
# tiny 3x5 font for HUD
F={'S':"111100111001111",'C':"111100100100111",'O':"111101101101111",'R':"110101110101101",'E':"111100110100111",
   '0':"111101101101111",'1':"010110010010111",'2':"111001111100111",'3':"111001111001111",'4':"101101111001001",
   'T':"111010010010010",'I':"111010010010111",'M':"101111111101101",' ':"000000000000000",'5':"111100111001111",'8':"111101111101111"}
def text(s,x,y,c,sc=2):
    for ch in s:
        g=F[ch]
        for k in range(15):
            if g[k]=='1': d.rectangle([x+(k%3)*sc,y+(k//3)*sc,x+(k%3)*sc+sc-1,y+(k//3)*sc+sc-1],fill=c)
        x+=4*sc
text("SCORE 012580",8,6,q((255,255,255)))
text("TIME 318",232,6,q((255,220,64)))
# test strip: colour bars, grey ramp, 1px lines, dither checker, skin tones
bars=[(255,255,255),(255,255,0),(0,255,255),(0,255,0),(255,0,255),(255,0,0),(0,0,255),(0,0,0)]
for i,c in enumerate(bars): d.rectangle([i*40,200,i*40+39,215],fill=c)
for i in range(16):
    v=i*17; d.rectangle([i*10,216,i*10+9,239],fill=(v,v,v))
for x in range(160,200):
    for y in range(216,240): px[x,y]=(255,255,255) if x%2 else (0,0,0)          # 1px vertical lines
for x in range(200,240):
    for y in range(216,240): px[x,y]=q((232,56,56)) if (x+y)%2 else q((64,104,200))  # Mega Drive style dither
skin=[(255,214,180),(232,176,136),(196,132,96),(140,88,60)]
for i,c in enumerate(skin): d.rectangle([240+i*20,216,259+i*20,239],fill=q(c))
im.save('sample_320x240.png')
im.resize((960,720),Image.NEAREST).save('sample_x3_view.png')
print('ok')
