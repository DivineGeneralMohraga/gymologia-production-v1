"""Gymologia promo video: 1080x1920, 30 fps, ~26 s, with a generated soundtrack.

    python marketing/promo-video/render.py [out.mp4]

Frames are drawn with Pillow and piped straight into ffmpeg; the music is
synthesised with numpy (kick, hats, bass, impacts, plate clanks), so there is
nothing licensed in it. App screens come from the gallery harness:

    GALLERY=1 flutter test test/visual/gallery_test.dart   (in apps/gymologia)
"""
import math, os, random, subprocess, sys, wave
import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
FONTS = os.path.join(ROOT, 'apps/gymologia/assets/fonts')
GALLERY = os.path.join(ROOT, 'apps/gymologia/build/gallery')
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '..', 'gymologia-releases', 'promo', 'gymologia-promo-vertical.mp4')

W, H, FPS = 1080, 1920, 30
DUR = 26.0
N = int(DUR * FPS)

INK = (11, 11, 12)
IRON = (29, 30, 32)
CHALK = (244, 244, 238)
DUST = (163, 165, 154)
VOLT = (198, 255, 0)
LINE = (42, 43, 46)

def font(name, size):
    return ImageFont.truetype(os.path.join(FONTS, f'BarlowCondensed-{name}.ttf'), size)

# ── easing ──
def clamp(x, a=0.0, b=1.0): return max(a, min(b, x))
def prog(t, start, dur): return clamp((t - start) / dur)
def out_cubic(x): return 1 - (1 - x) ** 3
def out_expo(x): return 1 if x >= 1 else 1 - 2 ** (-10 * x)
def out_back(x, s=1.9): x -= 1; return x * x * ((s + 1) * x + s) + 1
def in_cubic(x): return x ** 3
def lerp(a, b, x): return a + (b - a) * x

# ── cached text sprites ──
_cache = {}
def text_sprite(text, size, weight='BlackItalic', fill=CHALK, stroke=0, stroke_fill=None, tracking=0):
    key = (text, size, weight, fill, stroke, stroke_fill, tracking)
    if key in _cache: return _cache[key]
    f = font(weight, size)
    if tracking:
        widths = [f.getbbox(c)[2] - f.getbbox(c)[0] for c in text]
        w = int(sum(widths) + tracking * (len(text) - 1) + size)
    else:
        b = f.getbbox(text, stroke_width=stroke)
        w = b[2] - b[0] + size
    h = int(size * 1.5)
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if tracking:
        x = size // 2
        for c in text:
            d.text((x, size * .2), c, font=f, fill=fill, stroke_width=stroke, stroke_fill=stroke_fill)
            x += f.getbbox(c)[2] - f.getbbox(c)[0] + tracking
    elif '₹' in text:
        # Barlow has no rupee sign; draw it from Arial Bold, matched to the
        # cap height, and the rest in Barlow.
        rupee = ImageFont.truetype('C:/Windows/Fonts/arialbd.ttf', int(size * .74))
        x, y = size // 2, size * .2
        for k, seg in enumerate(text.split('₹')):
            if k:
                d.text((x, y + size * .27), '₹', font=rupee, fill=fill)
                x += rupee.getlength('₹') + size * .04
            d.text((x, y), seg, font=f, fill=fill)
            x += f.getlength(seg)
    else:
        d.text((size // 2, size * .2), text, font=f, fill=fill if not stroke or fill else (0, 0, 0, 0),
               stroke_width=stroke, stroke_fill=stroke_fill)
    img = img.crop(img.getbbox())
    _cache[key] = img
    return img

def place(canvas, sprite, cx, cy, scale=1.0, alpha=1.0, rot=0.0):
    if alpha <= 0.01 or scale <= 0.01: return
    s = sprite
    if abs(scale - 1) > 1e-3:
        s = s.resize((max(1, int(s.width * scale)), max(1, int(s.height * scale))), Image.BICUBIC)
    if rot:
        s = s.rotate(rot, resample=Image.BICUBIC, expand=True)
    if alpha < 0.999:
        a = s.getchannel('A').point(lambda v: int(v * alpha))
        s = s.copy(); s.putalpha(a)
    canvas.alpha_composite(s, (int(cx - s.width / 2), int(cy - s.height / 2)))

def slam(canvas, sprite, cx, cy, t, at, rot=0.0):
    """Arrives big and lands with a bounce."""
    p = prog(t, at, 0.28)
    if p <= 0: return
    scale = lerp(1.9, 1.0, out_back(p, 1.4)) if p < 1 else 1.0
    place(canvas, sprite, cx, cy, scale, clamp(p * 3), rot)

# ── brand pieces ──
def dumbbell_tile(size):
    tile = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(tile)
    d.rounded_rectangle((0, 0, size - 1, size - 1), radius=int(size * .25), fill=VOLT)
    lay = Image.new('RGBA', (size, size), (0, 0, 0, 0)); dl = ImageDraw.Draw(lay)
    k = size / 64
    for x, y, w, h in [(9, 22, 7, 20), (16, 16, 8, 32), (40, 16, 8, 32), (48, 22, 7, 20), (23, 29, 18, 6)]:
        dl.rounded_rectangle((x * k, y * k, (x + w) * k, (y + h) * k), radius=3 * k, fill=INK)
    lay = lay.rotate(12, resample=Image.BICUBIC)
    tile.alpha_composite(lay)
    return tile

TILE_BIG = dumbbell_tile(260)
TILE_SMALL = dumbbell_tile(150)

# ── phone mock ──
PHONE_W = 600
SCREEN_W = PHONE_W - 28
SCREEN_H = int(SCREEN_W * 1278 / 590)
PHONE_H = SCREEN_H + 28
def rounded_mask(w, h, r):
    m = Image.new('L', (w, h), 0); ImageDraw.Draw(m).rounded_rectangle((0, 0, w - 1, h - 1), radius=r, fill=255); return m
SCREEN_MASK = rounded_mask(SCREEN_W, SCREEN_H, 58)
BEZEL = Image.new('RGBA', (PHONE_W, PHONE_H), (0, 0, 0, 0))
ImageDraw.Draw(BEZEL).rounded_rectangle((0, 0, PHONE_W - 1, PHONE_H - 1), radius=72, fill=IRON, outline=(60, 62, 66), width=3)
def load_screen(name):
    im = Image.open(os.path.join(GALLERY, f'{name}_dark.png')).convert('RGB')
    return im.resize((SCREEN_W, int(im.height * SCREEN_W / im.width)), Image.LANCZOS)
SCREENS = {k: load_screen(v) for k, v in [('browser', '03_browser'), ('home', '02_home'), ('events', '05_events'), ('crm', '08_crm')]}
NOTCH = Image.new('RGBA', (130, 34), (0, 0, 0, 0)); ImageDraw.Draw(NOTCH).rounded_rectangle((0, 0, 129, 33), radius=17, fill=(0, 0, 0))

def phone(screen, scroll=0.0):
    """scroll: 0..1 of the screenshot's extra height."""
    ph = BEZEL.copy()
    extra = max(0, screen.height - SCREEN_H)
    y = int(extra * scroll)
    view = screen.crop((0, y, SCREEN_W, y + SCREEN_H)).convert('RGBA')
    view.putalpha(SCREEN_MASK)
    ph.alpha_composite(view, (14, 14))
    ph.alpha_composite(NOTCH, ((PHONE_W - 130) // 2, 34))
    return ph

# ── backgrounds ──
def make_glow(cx, cy, r, color, strength):
    g = Image.new('RGB', (W, H), INK)
    ImageDraw.Draw(g).ellipse((cx - r, cy - r, cx + r, cy + r), fill=tuple(int(lerp(INK[i], color[i], strength)) for i in range(3)))
    return g.filter(ImageFilter.GaussianBlur(r * .45))
BG_TOP = make_glow(W * .85, H * .1, 700, VOLT, .30).convert('RGBA')
BG_MID = make_glow(W * .5, H * .62, 720, VOLT, .22).convert('RGBA')
rng = np.random.default_rng(7)
GRAIN = []
for _ in range(4):
    n = rng.integers(0, 255, (H // 2, W // 2), dtype=np.uint8)
    g = Image.fromarray(n).resize((W, H), Image.NEAREST)
    a = Image.new('L', (W, H), 14)
    GRAIN.append(Image.merge('RGBA', (g, g, g, a)))

def heartbeat(canvas, t, start, y, alpha=1.0):
    """A volt ECG trace drawing left to right, a beat every 0.75 s."""
    pts = []
    for x in range(0, W + 1, 6):
        u = x / W
        phase = (u * 2.2) % 1
        if 0.40 < phase < 0.46: v = -110 * math.sin((phase - .40) / .06 * math.pi)
        elif 0.46 < phase < 0.52: v = 150 * math.sin((phase - .46) / .06 * math.pi)
        elif 0.52 < phase < 0.56: v = -40 * math.sin((phase - .52) / .04 * math.pi)
        else: v = 0
        pts.append((x, y + v))
    p = prog(t, start, 1.0)
    upto = int(len(pts) * out_cubic(p))
    if upto < 2: return
    lay = Image.new('RGBA', (W, H), (0, 0, 0, 0)); d = ImageDraw.Draw(lay)
    d.line(pts[:upto], fill=VOLT + (int(255 * alpha),), width=7, joint='curve')
    glow = lay.filter(ImageFilter.GaussianBlur(10))
    canvas.alpha_composite(glow); canvas.alpha_composite(lay)

def pill(text, size=46, fill=VOLT, color=INK):
    t = text_sprite(text, size, 'ExtraBold', color)
    w, h = t.width + 70, t.height + 44
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    ImageDraw.Draw(img).rounded_rectangle((0, 0, w - 1, h - 1), radius=h // 2, fill=fill)
    img.alpha_composite(t, ((w - t.width) // 2, (h - t.height) // 2))
    return img

def caption(canvas, t, at, lines, y=250, size=150):
    """Section title: lines slam in one after another."""
    for i, (txt, col, outline) in enumerate(lines):
        if outline:
            spr = text_sprite(txt, size, fill=None, stroke=4, stroke_fill=CHALK)
        else:
            spr = text_sprite(txt, size, fill=col)
        slam(canvas, spr, W / 2, y + i * size * .92, t, at + i * .25)

# ── plates for the "load the bar" scene ──
PLATES = [(25, 'ATTENDANCE', True, 80, 520), (20, 'MEMBERS', False, 70, 470), (15, 'ROLES', True, 62, 410),
          (10, 'LEAVE', False, 54, 345), (5, 'EVENTS', True, 46, 270), (2.5, 'RANKING', False, 40, 200)]
def plate_img(kg, volt, w, h):
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0)); d = ImageDraw.Draw(img)
    base = VOLT if volt else (52, 55, 59)
    d.rounded_rectangle((0, 0, w - 1, h - 1), radius=14, fill=base)
    hl = tuple(min(255, c + 40) for c in base)
    d.rounded_rectangle((w * .3, 6, w * .55, h - 7), radius=8, fill=hl)
    label = text_sprite(f'{kg:g}', 34, 'BlackItalic', INK if volt else CHALK).rotate(90, expand=True)
    img.alpha_composite(label, ((w - label.width) // 2, int(h * .12)))
    return img
PLATE_IMGS = [plate_img(kg, v, w, h) for kg, _, v, w, h in PLATES]

# ── timeline ──
T_LOGO, T_WORDS, T_FIND, T_TRACK, T_COMPETE, T_GYM, T_FREE, T_END = 1.0, 2.0, 4.0, 8.0, 11.5, 14.5, 19.5, 22.0
PLATE_AT = [15.0, 15.5, 16.0, 16.5, 17.0, 17.5]
IMPACTS = [T_LOGO, 2.0, 2.5, 3.0, T_FIND, T_TRACK, T_COMPETE, T_GYM, *PLATE_AT, T_FREE, T_END]

def shake(t):
    dx = dy = 0.0
    for at in IMPACTS:
        k = t - at
        if 0 <= k < 0.25:
            amp = 18 * (1 - k / .25) ** 2
            dx += amp * math.sin(k * 90); dy += amp * math.cos(k * 77)
    return int(dx), int(dy)

def draw(i):
    t = i / FPS
    canvas = (BG_TOP if t < T_FIND or t >= T_END else BG_MID).copy()

    # 0 ─ heartbeat, then the logo lands on the beat
    if t < T_FIND:
        heartbeat(canvas, t, 0.0, 1500, alpha=clamp(1 - prog(t, 3.4, .6)))
    if t < T_FIND:
        p = prog(t, T_LOGO, .3)
        up = out_cubic(prog(t, 1.7, .4))
        cy = lerp(780, 380, up)
        if p > 0:
            place(canvas, TILE_BIG, W / 2, cy - 30, lerp(2.4, 1, out_back(p, 1.6)) * lerp(1, .62, up), clamp(p * 3), lerp(-25, 0, out_cubic(p)))
            word = text_sprite('GYMOLOGIA', 130, tracking=6)
            q = prog(t, 1.35, .35)
            place(canvas, word, W / 2, cy + lerp(210, 120, up), lerp(1.3, 1, out_cubic(q)) * lerp(1, .8, up), q)
        # TRAIN. TRACK. TRANSFORM.
        for k, (txt, col, outline) in enumerate([('TRAIN.', CHALK, False), ('TRACK.', None, True), ('TRANSFORM.', VOLT, False)]):
            spr = text_sprite(txt, 210, fill=None, stroke=5, stroke_fill=CHALK) if outline else text_sprite(txt, 210, fill=col)
            slam(canvas, spr, W / 2, 760 + k * 200, t, T_WORDS + k * .5)
        if t > 3.6:
            # wipe out to the left
            pass

    # 1 ─ find a gym
    if T_FIND <= t < T_TRACK + .4:
        caption(canvas, t, T_FIND, [('FIND A GYM', CHALK, False), ('NEAR YOU', VOLT, False)], y=230)
        rise = out_expo(prog(t, T_FIND + .15, .6))
        leave = in_cubic(prog(t, T_TRACK - .1, .45))
        ph = phone(SCREENS['browser'], out_cubic(prog(t, 5.0, 2.6)) * .55)
        place(canvas, ph, W / 2 - leave * 1100, lerp(H + 700, 1180, rise), .95, 1, lerp(8, -3, rise))
        if t > 5.4:
            place(canvas, pill('NEARBY FIRST · RATED BY MEMBERS', 40), W / 2 - leave * 1100, 1790, lerp(.6, 1, out_back(prog(t, 5.4, .3))), prog(t, 5.4, .15))

    # 2 ─ track
    if T_TRACK - .1 <= t < T_COMPETE + .4:
        caption(canvas, t, T_TRACK, [('TRACK EVERY', CHALK, False), ('SINGLE DAY', VOLT, False)], y=230)
        enter = out_expo(prog(t, T_TRACK, .55))
        leave = in_cubic(prog(t, T_COMPETE - .1, .45))
        ph = phone(SCREENS['home'], out_cubic(prog(t, 9.6, 1.8)) * .5)
        place(canvas, ph, lerp(W + 700, W / 2, enter) - leave * 1100, 1180, .95, 1, lerp(-10, 2, enter))
        if t > 9.0:
            st = pill('23 DAYS LEFT', 64)
            place(canvas, st, 300 - leave * 1100, 860, lerp(1.8, 1, out_back(prog(t, 9.0, .3))), prog(t, 9.0, .12), 8)
        if t > 9.8:
            st = pill('LEAVE LEFT 4/6', 44, fill=CHALK)
            place(canvas, st, 800 - leave * 1100, 1500, lerp(1.8, 1, out_back(prog(t, 9.8, .3))), prog(t, 9.8, .12), -6)

    # 3 ─ compete
    if T_COMPETE - .1 <= t < T_GYM + .4:
        caption(canvas, t, T_COMPETE, [('COMPETE.', VOLT, False)], y=260, size=190)
        enter = out_expo(prog(t, T_COMPETE, .55))
        leave = in_cubic(prog(t, T_GYM - .1, .45))
        ph = phone(SCREENS['events'], out_cubic(prog(t, 12.6, 1.7)) * .35)
        place(canvas, ph, lerp(W + 700, W / 2, enter) - leave * 1100, 1170, .95, 1, lerp(10, -2, enter))
        if t > 12.4:
            place(canvas, pill('JOIN IN ONE TAP', 52), W / 2 - leave * 1100, 1790, lerp(1.6, 1, out_back(prog(t, 12.4, .3))), prog(t, 12.4, .12))

    # 4 ─ run your gym: load the bar
    if T_GYM - .1 <= t < T_FREE + .3:
        out = in_cubic(prog(t, T_FREE - .15, .4))
        caption(canvas, t, T_GYM, [('RUN YOUR GYM', CHALK, False), ('LOAD THE BAR', None, True)], y=240, size=140)
        lay = Image.new('RGBA', (W, H), (0, 0, 0, 0)); d = ImageDraw.Draw(lay)
        bar_y = 1000
        d.rounded_rectangle((-20, bar_y - 11, W + 20, bar_y + 11), radius=6, fill=(205, 208, 212))
        d.rectangle((-20, bar_y + 2, W + 20, bar_y + 11), fill=(140, 143, 148))
        d.rounded_rectangle((250, bar_y - 46, 282, bar_y + 46), radius=6, fill=(225, 228, 232))
        x = 292
        total = 0.0
        active = -1
        for k, (img, at) in enumerate(zip(PLATE_IMGS, PLATE_AT)):
            p = prog(t, at, .32)
            if p > 0:
                xx = lerp(W + 100, x, out_back(p, 1.2))
                lay.alpha_composite(img, (int(xx), int(bar_y - img.height / 2)))
                total += PLATES[k][0] * out_cubic(p)
                active = k
            x += img.width + 6
        canvas.alpha_composite(lay, (int(-out * 1100), 0))
        # weight counter
        place(canvas, text_sprite('TOTAL LOAD', 44, 'Bold', DUST, tracking=6), W / 2 - out * 1100, 1340, 1, prog(t, 14.9, .2))
        num = text_sprite(f'{total:.1f} KG' if total % 1 else f'{int(total)} KG', 190, fill=VOLT)
        place(canvas, num, W / 2 - out * 1100, 1470, 1, prog(t, 14.9, .2))
        if active >= 0:
            name = PLATES[active][1]
            q = prog(t, PLATE_AT[active], .25)
            place(canvas, text_sprite(name, 120), W / 2 - out * 1100, 1680, lerp(1.5, 1, out_back(q, 1.4)), clamp(q * 3))

    # 5 ─ free trial
    if T_FREE - .1 <= t < T_END + .3:
        out = in_cubic(prog(t, T_END - .15, .4))
        a = 1 - out
        slam(canvas, text_sprite('7 DAYS', 300, fill=VOLT), W / 2, 760, t, T_FREE)
        slam(canvas, text_sprite('FREE', 330, fill=None, stroke=6, stroke_fill=CHALK), W / 2, 1040, t, T_FREE + .3)
        if t > 20.4:
            place(canvas, text_sprite('FOR GYM OWNERS', 90, 'ExtraBold', CHALK, tracking=4), W / 2, 1290, 1, prog(t, 20.4, .25) * a)
        if t > 20.8:
            place(canvas, text_sprite('Basic ₹599  ·  Pro ₹1,199 / month', 64, 'Bold', DUST), W / 2, 1410, 1, prog(t, 20.8, .25) * a)

    # 6 ─ end card
    if t >= T_END:
        p = prog(t, T_END, .35)
        place(canvas, TILE_SMALL, W / 2, 560, lerp(2.2, 1, out_back(p, 1.5)), clamp(p * 3), lerp(-20, 0, out_cubic(p)))
        q = prog(t, T_END + .2, .3)
        place(canvas, text_sprite('GYMOLOGIA', 170, tracking=8), W / 2, 760, lerp(1.25, 1, out_cubic(q)), q)
        for k, (txt, col) in enumerate([('TRAIN.', CHALK), ('TRACK.', None), ('TRANSFORM.', VOLT)]):
            spr = text_sprite(txt, 96, fill=None, stroke=3, stroke_fill=CHALK) if col is None else text_sprite(txt, 96, fill=col)
            r = prog(t, T_END + .5 + k * .12, .3)
            place(canvas, spr, W / 2, 930 + k * 92, 1, r)
        g = prog(t, T_END + 1.0, .3)
        place(canvas, pill('GET IT ON GOOGLE PLAY', 58), W / 2, 1330, lerp(.7, 1, out_back(g)), g)
        h = prog(t, T_END + 1.3, .3)
        place(canvas, text_sprite('gymologia.com', 64, 'Bold', CHALK), W / 2, 1480, 1, h)
        place(canvas, text_sprite('Made by Ganda Group Technologies', 44, 'SemiBold', DUST), W / 2, 1760, 1, h)

    canvas.alpha_composite(GRAIN[i % 4])
    frame = Image.new('RGB', (W, H), INK)
    dx, dy = shake(t)
    frame.paste(canvas.convert('RGB'), (dx, dy))
    # quick flashes on the biggest hits
    for at, peak in [(T_LOGO, .55), (T_FREE, .35), (T_END, .25)]:
        k = t - at
        if 0 <= k < .12:
            frame = Image.blend(frame, Image.new('RGB', (W, H), VOLT), peak * (1 - k / .12))
    # fade in / out
    fade = clamp(t / .25) * clamp((DUR - t) / .6)
    if fade < 1:
        frame = Image.blend(Image.new('RGB', (W, H), INK), frame, fade)
    return frame

# ── soundtrack ──
SR = 44100
def soundtrack():
    n = int(DUR * SR)
    mix = np.zeros(n)
    tt = np.arange(n) / SR
    def add(sig, at, gain=1.0):
        s = int(at * SR); e = min(n, s + len(sig))
        if s < n: mix[s:e] += sig[:e - s] * gain
    def env(length, decay):
        x = np.arange(int(length * SR)) / SR
        return np.exp(-x / decay)
    def kick():
        x = np.arange(int(.35 * SR)) / SR
        f = 45 + 95 * np.exp(-x / .03)
        return np.sin(2 * np.pi * np.cumsum(f) / SR) * env(.35, .09)
    def hat():
        z = np.random.default_rng(1).standard_normal(int(.06 * SR))
        z = z - np.convolve(z, np.ones(6) / 6, 'same')
        return z * env(.06, .012) * .5
    def boom():
        x = np.arange(int(1.2 * SR)) / SR
        low = np.sin(2 * np.pi * 42 * x) * np.exp(-x / .45)
        z = np.random.default_rng(2).standard_normal(len(x))
        z = np.convolve(z, np.ones(40) / 40, 'same') * np.exp(-x / .08) * 2
        return np.pad(kick(), (0, len(x) - len(kick()))) + low * .9 + z
    def clank():
        x = np.arange(int(.8 * SR)) / SR
        s = sum(np.sin(2 * np.pi * f * x) * a for f, a in [(523, .5), (1187, .35), (1913, .25), (2741, .15)])
        return s * np.exp(-x / .18) * .6 + np.pad(kick(), (0, len(x) - len(kick()))) * .8
    def heart():
        x = np.arange(int(.18 * SR)) / SR
        return np.sin(2 * np.pi * 55 * x) * np.exp(-x / .05)
    def riser(length):
        x = np.arange(int(length * SR)) / SR
        z = np.random.default_rng(3).standard_normal(len(x))
        z = np.convolve(z, np.ones(8) / 8, 'same')
        return z * (x / length) ** 2.5 * .5

    # intro heartbeat
    for at in (.15, .38, .9 - .15):
        add(heart(), at, .9)
    add(riser(.8), T_LOGO - .8, .6)
    for at in IMPACTS:
        if at in PLATE_AT: add(clank(), at, .9)
        else: add(boom(), at, 1.0)
    # beat: kick on every half second, hats between, from the words to the end card
    b = 2.0
    while b < T_END + 3.0:
        if b not in IMPACTS: add(kick(), b, .8)
        if T_FIND <= b < T_END: add(hat(), b + .25, .6)
        b = round(b + .5, 3)
    # bass: driving eighths on E, up to A for the gym section
    def bass_note(freq, length=.24):
        x = np.arange(int(length * SR)) / SR
        saw = 2 * (x * freq % 1) - 1
        y = np.zeros_like(saw); a = .06
        for k in range(1, len(saw)): y[k] = y[k - 1] + a * (saw[k] - y[k - 1])
        return y * np.minimum(1, (length - x) / .03) * 1.4
    E, A, G = 41.2, 55.0, 49.0
    note_cache = {}
    t0 = T_FIND
    while t0 < T_END:
        f = A if T_GYM <= t0 < T_FREE else (G if T_COMPETE <= t0 < T_GYM else E)
        if f not in note_cache: note_cache[f] = bass_note(f)
        add(note_cache[f], t0, .7)
        t0 = round(t0 + .25, 3)
    add(riser(1.0), T_FREE - 1.0, .7)
    add(riser(.6), T_END - .6, .5)
    # tail
    fade = np.clip((DUR - tt) / .8, 0, 1)
    mix *= fade
    mix /= max(1e-9, np.abs(mix).max()) / .89
    stereo = np.stack([mix, mix], axis=1)
    return (stereo * 32767).astype(np.int16)

def main():
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    wav = OUT.replace('.mp4', '.wav')
    pcm = soundtrack()
    with wave.open(wav, 'wb') as w:
        w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR); w.writeframes(pcm.tobytes())
    cmd = ['ffmpeg', '-y', '-loglevel', 'error',
           '-f', 'rawvideo', '-pix_fmt', 'rgb24', '-s', f'{W}x{H}', '-r', str(FPS), '-i', '-',
           '-i', wav, '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '18', '-preset', 'medium',
           '-c:a', 'aac', '-b:a', '192k', '-shortest', '-movflags', '+faststart', OUT]
    proc = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    for i in range(N):
        proc.stdin.write(draw(i).tobytes())
        if i % 60 == 0: print(f'frame {i}/{N}', flush=True)
    proc.stdin.close(); proc.wait()
    os.remove(wav)
    if '--stills' in sys.argv:
        pass
    print('wrote', OUT)

if __name__ == '__main__':
    if len(sys.argv) > 2 and sys.argv[2] == '--frame':
        draw(int(float(sys.argv[3]) * FPS)).save(sys.argv[1]); print('saved', sys.argv[1])
    else:
        main()
