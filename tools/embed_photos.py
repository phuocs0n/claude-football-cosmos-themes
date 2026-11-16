"""Embed the reference pictures into the themes.

For each theme it writes:
  - the full-window background picture into <id>.css, replacing the data:image/jpeg URL (or the PHOTO placeholder)
  - a small copy of the picture as the theme's tile (`deco` in <id>.json)

Usage: python tools/embed_photos.py <folder with the pictures> [themes folder]
"""
import base64, io, json, re, sys
from pathlib import Path
from PIL import Image

# id -> (picture, crop box in the picture's pixels or None for the whole picture)
PAINTING = (440, 146, 2314, 1398)  # the canvas inside the frame, for the 2752x1536 framed paintings
SOURCES = {
    "albiceleste": ("messi.png", PAINTING),
    "crimson-seventeen": ("ro.png", PAINTING),
    "canary-samba": ("neymar.png", PAINTING),
    "cosmic-cliffs": ("vutru.png", None),
    "spartan-sunset": ("hylap.png", None),
}
CSS_LIMIT = 200_000   # the mod refuses a stylesheet longer than this
DECO_LIMIT = 40_000   # and a tile drawing longer than this
PHOTO = re.compile(r"data:image/jpeg;base64,[A-Za-z0-9+/=]*|(?<=base64,)PHOTO")


def jpeg(img: Image.Image, quality: int) -> str:
    buf = io.BytesIO()
    img.save(buf, "JPEG", quality=quality, optimize=True, progressive=True)
    return base64.b64encode(buf.getvalue()).decode()


def fit(img: Image.Image, budget: int, start: int = 82) -> str:
    for q in range(start, 30, -4):
        data = jpeg(img, q)
        if len(data) <= budget:
            return data
    raise SystemExit("picture too large even at low quality")


def cover(img: Image.Image, w: int, h: int) -> Image.Image:
    k = max(w / img.width, h / img.height)
    img = img.resize((round(img.width * k), round(img.height * k)), Image.LANCZOS)
    x, y = (img.width - w) // 2, (img.height - h) // 2
    return img.crop((x, y, x + w, y + h))


def main() -> None:
    pics = Path(sys.argv[1])
    themes = Path(sys.argv[2]) if len(sys.argv) > 2 else Path(__file__).resolve().parent.parent / "themes"
    for tid, (name, box) in SOURCES.items():
        img = Image.open(pics / name).convert("RGB")
        if box:
            img = img.crop(box)

        css_path = themes / f"{tid}.css"
        css = css_path.read_text(encoding="utf-8")
        rest = len(PHOTO.sub("", css))
        # the picture fills the window, so keep it as wide as fits the mod's limit: width first, then quality
        # (the mod adds its own _base.css, about 1,100 characters, before it checks the limit)
        budget, photo = CSS_LIMIT - rest - 5_000, None
        for width in (1600, 1440, 1280, 1152, 1024, 900):
            big = img.resize((width, round(width * img.height / img.width)), Image.LANCZOS)
            for q in (72, 64, 56, 50):
                data = jpeg(big, q)
                if len(data) <= budget:
                    photo = data
                    break
            if photo:
                print(f"{tid}: picture {width}px q{q}")
                break
        if not photo:
            raise SystemExit(f"{tid}: picture does not fit")
        css = PHOTO.sub(lambda m: "data:image/jpeg;base64," + photo if m.group(0).startswith("data:") else photo, css, count=1)
        css_path.write_text(css, encoding="utf-8")

        json_path = themes / f"{tid}.json"
        theme = json.loads(json_path.read_text(encoding="utf-8"))
        tile = fit(cover(img, 360, 210), DECO_LIMIT - 400, 78)
        theme["deco"] = (f'<image href="data:image/jpeg;base64,{tile}" width="240" height="140" '
                         'preserveAspectRatio="xMidYMid slice"/>')
        json_path.write_text(json.dumps(theme, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"{tid}: css {len(css):,} chars, tile {len(theme['deco']):,} chars")


if __name__ == "__main__":
    main()
