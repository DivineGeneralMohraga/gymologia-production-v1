"""Website images from the brand masters and the app's gallery screenshots.

    python website-src/make-images.py      (then: node website-src/build.mjs)

Reads marketing/brand/ (the logo) and apps/gymologia/build/gallery/ (run
the gallery harness first) and writes into website/.
"""
import os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
BRAND = os.path.join(ROOT, 'marketing', 'brand')
GALLERY = os.path.join(ROOT, 'apps', 'gymologia', 'build', 'gallery')
FONTS = os.path.join(ROOT, 'apps', 'gymologia', 'assets', 'fonts')
OUT = os.path.join(ROOT, 'website')

INK = (11, 11, 12); VOLT = (198, 255, 0); CHALK = (244, 244, 238); DUST = (163, 165, 154)

icon = Image.open(os.path.join(BRAND, 'gymologia-icon-1024.png')).convert('RGB')
mark = Image.open(os.path.join(BRAND, 'mark-tight.png')).convert('RGBA')

# The mask the site colours with CSS.
mark.save(os.path.join(OUT, 'brand-mark.png'), optimize=True)

# Favicons and the home-screen icon for iPhones.
for name, size in [('favicon.png', 64), ('favicon-192.png', 192), ('apple-touch-icon.png', 180)]:
    icon.resize((size, size), Image.LANCZOS).save(os.path.join(OUT, name), optimize=True)
old = os.path.join(OUT, 'favicon.svg')
if os.path.exists(old):
    os.remove(old)

def tinted(img, color):
    layer = Image.new('RGBA', img.size, color + (255,))
    layer.putalpha(img.getchannel('A'))
    return layer

# Share image (WhatsApp, Instagram, X): 1200x630.
W, H = 1200, 630
og = Image.new('RGB', (W, H), INK)
glow = Image.new('RGB', (W, H), INK)
ImageDraw.Draw(glow).ellipse((700, -300, 1500, 500), fill=(60, 78, 0))
og = Image.blend(og, glow.filter(ImageFilter.GaussianBlur(160)), .9).convert('RGBA')
big = tinted(mark.resize((760, int(mark.height * 760 / mark.width)), Image.LANCZOS), VOLT)
big.putalpha(big.getchannel('A').point(lambda v: int(v * .09)))
og.alpha_composite(big.rotate(-14, expand=True, resample=Image.BICUBIC), (560, 120))
d = ImageDraw.Draw(og)
tile = Image.new('RGBA', (72, 72), (0, 0, 0, 0))
ImageDraw.Draw(tile).rounded_rectangle((0, 0, 71, 71), radius=18, fill=VOLT)
small = tinted(mark.resize((58, int(mark.height * 58 / mark.width)), Image.LANCZOS), INK)
tile.alpha_composite(small, ((72 - small.width) // 2, (72 - small.height) // 2))
og.alpha_composite(tile, (70, 62))
f = lambda n, s: ImageFont.truetype(os.path.join(FONTS, f'BarlowCondensed-{n}.ttf'), s)
d.text((162, 66), 'GYMOLOGIA', font=f('BlackItalic', 52), fill=CHALK)
d.text((1130, 84), 'GYM APP FOR INDIA', font=f('Bold', 34), fill=DUST, anchor='ra')
for k, (txt, fill, stroke) in enumerate([('TRAIN.', CHALK, 0), ('TRACK.', INK, 3), ('TRANSFORM.', VOLT, 0)]):
    d.text((66, 170 + k * 128), txt, font=f('BlackItalic', 150), fill=fill, stroke_width=stroke, stroke_fill=CHALK)
og.convert('RGB').save(os.path.join(OUT, 'og.png'), optimize=True)

# App screens shown on the page.
os.makedirs(os.path.join(OUT, 'screens'), exist_ok=True)
for name, shot in [('login', '01_login'), ('browser', '03_browser'), ('home', '02_home'),
                   ('events', '05_events'), ('crm', '08_crm'), ('map', '15_location_picker')]:
    Image.open(os.path.join(GALLERY, f'{shot}_dark.png')).convert('RGB') \
        .save(os.path.join(OUT, 'screens', f'{name}.webp'), 'WEBP', quality=82, method=6)
print('website images written')
