"""Play Store screenshots (1080x1920) and raw app screens for marketing.

    python marketing/store-screenshots/make.py [out_dir]

Uses the promo video's drawing helpers so the stills match the video, and
the gallery harness's screens (run it first, in apps/gymologia):

    GALLERY=1 flutter test test/visual/gallery_test.dart
"""
import importlib.util, os, shutil, sys
from PIL import Image

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
spec = importlib.util.spec_from_file_location('render', os.path.join(ROOT, 'marketing/promo-video/render.py'))
R = importlib.util.module_from_spec(spec)
sys.argv = sys.argv[:1]  # render.py reads its output path from argv at import
spec.loader.exec_module(R)

OUT = os.path.join(ROOT, '..', 'gymologia-releases', 'app-assets')
store = os.path.join(OUT, 'play-store-screenshots')
raw = os.path.join(OUT, 'app-screens')
os.makedirs(store, exist_ok=True); os.makedirs(raw, exist_ok=True)

SHOTS = [
    ('01-find-a-gym', '03_browser', [('FIND A GYM', R.VOLT), ('NEAR YOU', R.CHALK)], 'NEARBY FIRST · RATED BY MEMBERS', .0),
    ('02-gym-profile', '04_profile', [('SEE IT BEFORE', R.CHALK), ('YOU JOIN', R.VOLT)], 'PHOTOS · PERKS · ONE-TAP CALL', .0),
    ('03-track', '02_home', [('TRACK EVERY', R.CHALK), ('SINGLE DAY', R.VOLT)], 'DAYS LEFT · LEAVE · YOUR GOAL', .0),
    ('04-compete', '05_events', [('COMPETE', R.VOLT), ('AT YOUR GYM', R.CHALK)], 'JOIN EVENTS IN ONE TAP', .0),
    ('05-run-your-gym', '08_crm', [('RUN YOUR', R.CHALK), ('WHOLE GYM', R.VOLT)], 'MEMBERS · STAFF · ROLES · PLANS', .0),
    ('06-attendance', '16_attendance', [('ATTENDANCE', R.VOLT), ('IN ONE TAP', R.CHALK)], 'MEMBERS AND STAFF · ANY DAY', .0),
]

for name, shot, lines, pill_text, scroll in SHOTS:
    canvas = R.BG_MID.copy()
    for k, (txt, col) in enumerate(lines):
        R.place(canvas, R.text_sprite(txt, 150, fill=col), R.W / 2, 210 + k * 140)
    screen = R.load_screen(shot)
    ph = R.phone(screen, scroll)
    R.place(canvas, ph, R.W / 2, 1185, .92)
    R.place(canvas, R.pill(pill_text, 40), R.W / 2, 1830)
    canvas.alpha_composite(R.GRAIN[0])
    canvas.convert('RGB').save(os.path.join(store, f'{name}.png'), optimize=True)
    print('wrote', name)

for f in sorted(os.listdir(R.GALLERY)):
    if f.endswith('.png') and f[:2].isdigit():
        shutil.copy(os.path.join(R.GALLERY, f), os.path.join(raw, f))
print('copied raw screens to', raw)
