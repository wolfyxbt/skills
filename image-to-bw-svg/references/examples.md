# 示例

## 干净的 Logo（默认参数）

```bash
bash scripts/trace_to_svg.sh logo.png --out out/logo.svg
```

## Logo 剪影（稍高对比度）

```bash
bash scripts/trace_to_svg.sh logo.png --out out/logo.svg --threshold 0.6 --turdsize 30
```

## 噪点较多的扫描件

```bash
bash scripts/trace_to_svg.sh scan.png --out out/scan.svg --threshold 0.6 --turdsize 50
```

## 像素风格图形（保留锐利边角）

```bash
bash scripts/trace_to_svg.sh pixel_art.png --out out/pixel.svg --alphamax 0.5 --opttolerance 0.1
```

## 极简轮廓（大幅简化）

```bash
bash scripts/trace_to_svg.sh complex.png --out out/simple.svg --threshold 0.7 --turdsize 100 --opttolerance 0.5
```
