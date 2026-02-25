#!/usr/bin/env bash
set -euo pipefail

# 使用 vtracer 将位图转换为彩色 SVG。
# 原生支持 PNG/JPG/WebP，无需额外格式转换。
#
# 依赖：vtracer (cargo install vtracer)
#
# 用法：
#   color_trace_to_svg.sh input.png --out out.svg [--color_precision 6] [--filter_speckle 4] [--corner_threshold 60] [--segment_length 4.0] [--splice_threshold 45] [--mode polygon]

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <input_image> --out <out.svg> [--color_precision 6] [--filter_speckle 4] [--corner_threshold 60] [--segment_length 4.0] [--splice_threshold 45] [--mode polygon]" >&2
  exit 2
fi

IN="$1"; shift
OUT=""
COLOR_PRECISION="6"
FILTER_SPECKLE="4"
CORNER_THRESHOLD="60"
SEGMENT_LENGTH="4.0"
SPLICE_THRESHOLD="45"
MODE="polygon"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out) OUT="$2"; shift 2;;
    --color_precision) COLOR_PRECISION="$2"; shift 2;;
    --filter_speckle) FILTER_SPECKLE="$2"; shift 2;;
    --corner_threshold) CORNER_THRESHOLD="$2"; shift 2;;
    --segment_length) SEGMENT_LENGTH="$2"; shift 2;;
    --splice_threshold) SPLICE_THRESHOLD="$2"; shift 2;;
    --mode) MODE="$2"; shift 2;;
    -h|--help)
      echo "Usage: $0 <input_image> --out <out.svg> [--color_precision 6] [--filter_speckle 4] [--corner_threshold 60] [--segment_length 4.0] [--splice_threshold 45] [--mode polygon]"
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

if ! command -v vtracer >/dev/null 2>&1; then
  if [[ -f "$HOME/.cargo/bin/vtracer" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
  else
    echo "vtracer not found. Install: cargo install vtracer (requires Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)" >&2
    exit 127
  fi
fi

if [[ ! -f "$IN" ]]; then
  echo "Input file not found: $IN" >&2
  exit 2
fi

mkdir -p "$(dirname "$OUT")"

vtracer \
  --input "$IN" \
  --output "$OUT" \
  --colormode color \
  --color_precision "$COLOR_PRECISION" \
  --filter_speckle "$FILTER_SPECKLE" \
  --corner_threshold "$CORNER_THRESHOLD" \
  --segment_length "$SEGMENT_LENGTH" \
  --splice_threshold "$SPLICE_THRESHOLD" \
  --mode "$MODE"

echo "$OUT"
