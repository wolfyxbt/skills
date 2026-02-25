# 示例

## 彩色 Logo（默认参数）

```bash
bash scripts/color_trace_to_svg.sh logo.png --out out/logo.svg
```

## 高精度颜色还原

```bash
bash scripts/color_trace_to_svg.sh illustration.png --out out/illustration.svg --color_precision 8 --filter_speckle 2
```

## 小文件体积优先

```bash
bash scripts/color_trace_to_svg.sh icon.png --out out/icon.svg --color_precision 4 --filter_speckle 8 --segment_length 8
```

## 平滑曲线风格

```bash
bash scripts/color_trace_to_svg.sh artwork.png --out out/artwork.svg --mode spline
```

## 复杂插画（最大细节）

```bash
bash scripts/color_trace_to_svg.sh complex.png --out out/complex.svg --color_precision 8 --filter_speckle 2 --corner_threshold 90
```
