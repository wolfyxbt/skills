---
name: image-to-color-svg
description: 将位图（PNG/JPG/WebP）转换为彩色 SVG 矢量图。基于 vtracer，支持多色聚类描摹，能保留原图颜色信息。适用于彩色 logo、插画、图标等场景。
---

# 图片转彩色 SVG

使用 `vtracer` 将位图转换为保留颜色的矢量 SVG。

## 触发条件

当用户的需求符合以下任一情况时，使用此 Skill：

- 要求将图片转为 SVG 并**保留颜色**
- 输入是彩色图片（彩色 logo、插画、图标、UI 截图等）
- 用户没有明确说要黑白，且图片本身是彩色的


## 前置依赖

- **vtracer** — Rust 编写的彩色位图矢量化工具

安装方式：

```bash
# 如果已有 Rust 工具链
cargo install vtracer

# 如果没有 Rust，先安装
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
cargo install vtracer
```

安装完成后 vtracer 是一个独立二进制文件，运行时无额外依赖。

在执行前，运行 `which vtracer` 检查是否已安装。如果未找到但 `~/.cargo/bin/vtracer` 存在，需要先执行 `source "$HOME/.cargo/env"` 将其加入 PATH。

## 执行步骤

1. **确认输入文件**：确认用户提供了位图文件路径，且文件存在。原生支持 PNG、JPG、WebP 格式。
2. **确认依赖已安装**：运行 `which vtracer`，缺失则提示用户安装。
3. **执行转换脚本**：

```bash
bash scripts/color_trace_to_svg.sh <输入文件> --out <输出文件.svg>
```

4. **验证输出**：确认 SVG 文件已生成且非空。
5. **告知用户结果**：返回输出文件路径，说明文件大小和包含的路径数量。

## 参数说明

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `--color_precision` | 6 | 颜色精度（1~8）。值越大颜色越精细，路径越多，文件越大 |
| `--filter_speckle` | 4 | 忽略小于此面积（像素）的噪点区域 |
| `--corner_threshold` | 60 | 拐角检测阈值（度数）。值越小越多拐角被保留 |
| `--segment_length` | 4.0 | 每段曲线的最小长度。值越大曲线越简化 |
| `--splice_threshold` | 45 | 路径拼接角度阈值（度数） |
| `--mode` | polygon | 描摹模式：`polygon`（多边形）或 `spline`（曲线，更平滑） |

### 场景调参建议

- **彩色 logo / 扁平图标**：默认参数即可
- **需要更精细的颜色还原**：`--color_precision 8 --filter_speckle 2`
- **需要更小的文件体积**：`--color_precision 4 --filter_speckle 8 --segment_length 8`
- **平滑曲线风格**：`--mode spline`
- **复杂插画 / 渐变图**：`--color_precision 8 --filter_speckle 2 --corner_threshold 90`

## 错误处理

- **`vtracer not found`**：提示用户安装 Rust 工具链和 vtracer（见前置依赖）。
- **`cargo not found`**：需要先安装 Rust：`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`。
- **输出文件过大**（>500KB）：建议降低 `--color_precision` 或增大 `--filter_speckle` 来简化。
- **输入文件不存在**：提示用户检查路径。

## 输出说明

- 输出为彩色 SVG，包含多个带颜色填充的 `<path>` 元素。
- 可直接用于网页、设计工具（Figma / Illustrator）、或其他矢量处理流程。
- 文件大小取决于图片复杂度和参数设置，通常在 10KB ~ 100KB 之间。

## 注意事项

- vtracer 使用颜色聚类算法，不是像素级精确还原，而是"视觉近似"。
- 对于照片级图像，输出文件可能较大且效果有限——这是所有本地矢量化工具的共同局限。
