#!/usr/bin/env bash
set -euo pipefail

# 使用 mkbitmap + potrace 将位图转换为黑白 SVG。
# 自动处理 PNG/JPG/WebP 等格式（需要 ImageMagick 或 macOS sips）。
#
# 依赖：potrace + mkbitmap
# 可选：ImageMagick（用于非 PNM/BMP 格式的输入）
#
# 用法：
#   trace_to_svg.sh input.png --out out.svg [--threshold 0.45] [--scale 2] [--turdsize 2] [--alphamax 1.0] [--opttolerance 0.2]

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <input_image> --out <out.svg> [--threshold 0.45] [--scale 2] [--turdsize 2] [--alphamax 1.0] [--opttolerance 0.2]" >&2
  exit 2
fi

IN="$1"; shift
OUT=""
THRESHOLD="0.45"
SCALE="2"
TURDSIZE="2"
ALPHAMAX="1.0"
OPTTOL="0.2"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out) OUT="$2"; shift 2;;
    --threshold) THRESHOLD="$2"; shift 2;;
    --scale) SCALE="$2"; shift 2;;
    --turdsize) TURDSIZE="$2"; shift 2;;
    --alphamax) ALPHAMAX="$2"; shift 2;;
    --opttolerance) OPTTOL="$2"; shift 2;;
    -h|--help)
      echo "Usage: $0 <input_image> --out <out.svg> [--threshold 0.45] [--scale 2] [--turdsize 2] [--alphamax 1.0] [--opttolerance 0.2]"
      exit 0;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2;;
  esac
done

if [[ -z "$OUT" ]]; then
  echo "--out is required" >&2
  exit 2
fi

command -v mkbitmap >/dev/null 2>&1 || { echo "mkbitmap not found. Install: brew install potrace (macOS) / apt install potrace (Linux)" >&2; exit 127; }
command -v potrace  >/dev/null 2>&1 || { echo "potrace not found. Install: brew install potrace (macOS) / apt install potrace (Linux)" >&2; exit 127; }

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

MKBITMAP_IN="$IN"
EXT_LOWER="$(echo "${IN##*.}" | tr '[:upper:]' '[:lower:]')"

if [[ "$EXT_LOWER" != "pbm" && "$EXT_LOWER" != "pgm" && "$EXT_LOWER" != "ppm" && "$EXT_LOWER" != "pnm" && "$EXT_LOWER" != "bmp" ]]; then
  MKBITMAP_IN="$TMPDIR/in.bmp"
  if command -v magick >/dev/null 2>&1; then
    magick "$IN" "$MKBITMAP_IN"
  elif command -v convert >/dev/null 2>&1; then
    convert "$IN" "$MKBITMAP_IN"
  elif command -v sips >/dev/null 2>&1; then
    sips -s format bmp "$IN" --out "$MKBITMAP_IN" >/dev/null 2>&1
  else
    echo "Input .$EXT_LOWER not natively supported. Install ImageMagick: brew install imagemagick" >&2
    exit 2
  fi
fi

PBM="$TMPDIR/in.pbm"

mkbitmap "$MKBITMAP_IN" \
  -o "$PBM" \
  -t "$THRESHOLD" \
  -s "$SCALE"

mkdir -p "$(dirname "$OUT")"

potrace "$PBM" \
  --svg \
  --output "$OUT" \
  --turdsize "$TURDSIZE" \
  --alphamax "$ALPHAMAX" \
  --opttolerance "$OPTTOL"

echo "$OUT"
