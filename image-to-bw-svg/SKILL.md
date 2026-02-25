---
name: image-to-bw-svg
description: 将位图（PNG/JPG/WebP）转换为黑白 SVG 矢量路径。基于 potrace，适用于将任意图片矢量化为黑白轮廓/剪影风格 SVG。安装简单（brew/apt 一条命令），转换极快。
---

# 图片转黑白 SVG

使用 `mkbitmap` + `potrace` 将任意位图转换为黑白矢量 SVG。输入可以是彩色图片，输出为纯黑白轮廓。

## 触发条件

当用户的需求符合以下任一情况时，使用此 Skill：

- 要求将图片转为**黑白轮廓 / 剪影风格**的 SVG
- 需要将彩色图片提取为黑白矢量轮廓
- 输入图片本身就是黑白的（如 logo、线条画、签名、印章）
- 需要极简、极小的 SVG 文件


## 前置依赖

- **potrace**（含 mkbitmap）
- **ImageMagick**（可选，用于 PNG/JPG/WebP 格式自动转换）

安装方式：

- macOS: `brew install potrace`
- Debian/Ubuntu: `sudo apt install potrace`
- ImageMagick（可选）: `brew install imagemagick` / `sudo apt install imagemagick`

在执行前，运行 `which potrace && which mkbitmap` 检查是否已安装。

## 执行步骤

1. **确认输入文件**：确认用户提供了位图文件路径，且文件存在。支持 PNG、JPG、WebP、BMP、PNM 格式。
2. **确认依赖已安装**：运行 `which potrace && which mkbitmap`，缺失则提示用户安装。
3. **执行转换脚本**：

```bash
bash scripts/trace_to_svg.sh <输入文件> --out <输出文件.svg>
```

4. **验证输出**：确认 SVG 文件已生成且非空。
5. **告知用户结果**：返回输出文件路径。

## 参数说明

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `--threshold` | 0.45 | 二值化阈值（0~1）。值越高，保留的黑色区域越少。logo 建议 0.4~0.6 |
| `--scale` | 2 | mkbitmap 缩放倍率（整数）。放大后再描摹可提升细节，但处理变慢 |
| `--turdsize` | 2 | 忽略小于此面积的噪点斑块。噪点多时可调高到 20~100 |
| `--alphamax` | 1.0 | 拐角平滑度（0=尖锐拐角，1.334=最平滑） |
| `--opttolerance` | 0.2 | 曲线优化容差。值越大曲线越简化，文件越小 |

### 场景调参建议

- **干净的 logo / 图标**：默认参数即可
- **噪点较多的扫描件**：`--threshold 0.6 --turdsize 50`
- **需要锐利边角**（像素风格）：`--alphamax 0.5 --opttolerance 0.1`
- **需要极简轮廓**：`--threshold 0.7 --turdsize 100 --opttolerance 0.5`

## 错误处理

- **`potrace not found` / `mkbitmap not found`**：提示用户执行 `brew install potrace` 或 `sudo apt install potrace`。
- **输入格式不支持**：如果 mkbitmap 报格式错误且没有 ImageMagick，提示用户安装：`brew install imagemagick`。
- **输出 SVG 为空**：阈值不合适，建议调整 `--threshold`。
- **输入文件不存在**：提示用户检查路径。

## 输出说明

- 输出为黑白 SVG，所有路径填充为黑色（`#000000`），背景透明。
- 可直接用于网页、设计工具、激光切割、印刷等场景。
- 文件通常很小（几 KB），非常适合对文件体积敏感的用途。

## 注意事项

- 此工具会将所有颜色压缩为纯黑/纯白，**不保留任何颜色信息**。
- 对于照片或渐变图像，效果取决于阈值设定，通常不是最佳选择。
