# 杀破狼的 Skills

我日常在用、自己写的 Agent Skills 合集。每个 skill 是一个文件夹，装进 Claude Code、Codex 等支持 Agent Skills 的 agent 之后，agent 会在合适的时候自动调用，按 skill 里写好的方法和流程去做事。

A collection of my own Agent Skills. Each folder is one skill that works with Claude Code, Codex and other agents that support the Agent Skills format.

## Skills 一览

| Skill | 用途 | 适合什么时候用 |
| --- | --- | --- |
| [good-video-opening](./good-video-opening) | 设计视频开头：前 3 秒、剩余开场、画面构建、标题封面，并输出开场分镜和自检清单 | 做视频、写脚本、剪片子时，想让开头留住观众 |

> 仓库会持续添加新的 skill。

## 安装

推荐用 [skills](https://www.npmjs.com/package/skills) CLI 安装，不需要手动下载文件。

查看仓库里有哪些 skill：

```bash
npx skills add wolfyxbt/skills --list
```

安装其中一个（`-g` 表示装到用户级，所有项目都能用）：

```bash
npx skills add wolfyxbt/skills --skill good-video-opening -g
```

一次装上全部：

```bash
npx skills add wolfyxbt/skills --skill '*' -g
```

更新已安装的 skill：

```bash
npx skills update -g
```

### 手动安装

也可以把 skill 文件夹直接复制到 agent 的 skills 目录：

- Claude Code：`~/.claude/skills/<skill-name>/`
- Codex：`~/.codex/skills/<skill-name>/`

```bash
git clone https://github.com/wolfyxbt/skills.git
cp -R skills/good-video-opening ~/.claude/skills/
```

## 怎么使用

装好之后不用记命令，正常描述需求就行。agent 会根据每个 skill 的 `description` 判断要不要调用，比如：

> 帮我设计一下这支视频的开头，前 3 秒怎么抓人？

也可以点名调用：

> 用 good-video-opening 帮我设计这支视频的开头。

## 仓库结构

每个 skill 一个文件夹，放在仓库根目录：

```
skills/
├── README.md
├── LICENSE
└── <skill-name>/
    ├── SKILL.md            # 必需：frontmatter（name、description）+ 正文说明
    ├── references/         # 可选：资料、案例、长文档，按需读取
    ├── scripts/            # 可选：skill 要执行的脚本
    ├── assets/             # 可选：模板、字体、图片等素材
    └── agents/
        └── openai.yaml     # 可选：Codex 里显示的名称、简介和默认提示词
```

## 新增一个 skill

1. 在根目录新建 `<skill-name>/`，名字用小写字母和连字符，并和 `SKILL.md` 里的 `name` 保持一致。
2. 写 `SKILL.md`：`description` 要写清楚「做什么」和「什么时候用」，agent 靠它决定要不要调用。
3. 长资料放进 `references/`，可执行的部分放进 `scripts/`，让 `SKILL.md` 保持精简。
4. 运行 `npx skills add wolfyxbt/skills --list`（推送后）确认新 skill 能被识别。
5. 在上面的「Skills 一览」表格里加一行。

## 许可证

[MIT](./LICENSE)：可以自由使用、修改和再分发，保留版权声明即可。
