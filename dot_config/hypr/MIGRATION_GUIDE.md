# Hyprland 配置完全指南

> 从零安装到完善配置，基于 niri 使用习惯迁移。  
> Hyprland 0.55 / Fedora 43 / 2026-05

---

## 目录

1. [对话总结](#对话总结)
2. [全新安装流程](#全新安装流程)
3. [配置详解](#配置详解)
4. [快捷键速查表](#快捷键速查表)
5. [配套工具](#配套工具)
6. [新电脑迁移指南](#新电脑迁移指南)

---

## 对话总结

本次配置将 **niri** 的使用习惯完整迁移到 **Hyprland 0.55**，历时多轮迭代修复，核心变化如下：

### 踩坑历程

| 阶段 | 关键问题 | 最终方案 |
|------|---------|---------|
| 初始迁移 | `.conf` 格式大量选项被废弃 | **改用 Lua 配置**（`hyprland.lua`） |
| 布局选择 | dwindle 和 niri 列布局差距大 | **scrolling 滚动布局**，专有 `layoutmsg` 命令 |
| API 语法 | 反复尝试 `fullscreen_state`/`resize`/`tag` 参数格式 | 查 Wiki 确认命名/位置参数规则 |
| 窗口编组 | `window.move` 不能正确交换列 | `consume_or_expel` + `swapcol` 布局消息 |
| 动画 | speed 越大越慢（反直觉） | `speed=1~2` 实现快速动画 |
| 桌面 shell | DMS 对 Hyprland 支持不佳 | **Noctalia**（启动器+剪贴板）+ **hyprshell**（Alt+Tab+预览） |

### 最终架构

```
~/.config/hypr/
├── hyprland.lua              ← 主配置（Lua 格式，Hyprland 0.55 标准）
├── dropdown-terminal.sh      ← 下拉终端脚本
├── dms/                      ← DMS 遗留文件（不再使用）
└── hyprland.conf.bak*        ← 旧 .conf 备份
```

**配套软件：**

| 工具 | 用途 | 安装方式 |
|------|------|---------|
| [Noctalia](https://github.com/noctalia-dev/noctalia-shell) | 桌面 shell（启动器、剪贴板、状态栏） | `dnf install noctalia-git` |
| [hyprshell](https://github.com/liammmcauliffe/hyprshell) ⚠️ WIP | GTK4 窗口切换器（Alt+Tab / Super+Tab） | `cargo install hyprshell` |
| [waycorner](https://github.com/andersmmg/waycorner) | 热角触发（预留） | `cargo install waycorner` |
| hyprland-plugins | 官方插件（hyprbars 等） | `dnf install hyprland-plugins` |
| grimblast | 截图工具 | 随 hyprland-contrib |
| brightnessctl | 亮度控制 | `dnf install brightnessctl` |
| playerctl | 媒体控制 | `dnf install playerctl` |
| jq | JSON 处理（下拉终端脚本依赖） | `dnf install jq` |

---

## 全新安装流程

### 1. 安装 Hyprland

```bash
# Fedora（需要 COPR）
sudo dnf copr enable lionheartp/Hyprland
sudo dnf install hyprland hyprland-plugins
```

### 2. 安装配套工具

```bash
# Noctalia 桌面 shell（v5 轻量版）
sudo dnf install noctalia-git

# grimblast 截图
sudo dnf install grimblast

# 亮度/媒体控制
sudo dnf install brightnessctl playerctl

# jq（下拉终端脚本依赖）
sudo dnf install jq
```

### 3. 安装 hyprshell ⚠️ WIP（窗口切换器）

```bash
cargo install hyprshell
# 首次生成配置
hyprshell config generate
```

### 4. 安装 waycorner（热角，可选）

```bash
cargo install waycorner
mkdir -p ~/.config/waycorner
```

`~/.config/waycorner/config.toml`：
```toml
[top-left]
command = "hyprctl eval 'hl.dispatch(hl.dsp.global(\"hyprexpo:expo_toggle\"))'"
margin = 5
```

### 5. 部署配置文件

```bash
# 创建目录
mkdir -p ~/.config/hypr

# 复制主配置
cp hyprland.lua ~/.config/hypr/

# 复制下拉终端脚本
cp dropdown-terminal.sh ~/.config/hypr/
chmod +x ~/.config/hypr/dropdown-terminal.sh
```

### 6. 登录

从 SDDM/GDM 选择 Hyprland 会话登录。

---

## 配置详解

### 显示器

```lua
hl.monitor({
    output    = "eDP-1",
    mode      = "2560x1600@165.000",
    position  = "0x0",
    scale     = 1.6,        -- Hyprland 0.55 要求特定步长
    vrr       = true,       -- 可变刷新率
})
```

> **迁移注意**：`output` 名称因机器而异，用 `hyprctl monitors` 查看。
>
> **虚拟显示器（如 DP-9）**：不要在 `hl.monitor()` 中声明——一旦声明 Hyprland 会自动启用。需要时手动 `wlr-randr --output DP-9 --on`。

### 布局：scrolling 滚动布局

这是与 niri 列布局最接近的 Hyprland 方案：

```lua
scrolling = {
    column_width            = 0.5,
    explicit_column_widths  = "0.333, 0.5, 0.666",  -- 逗号分隔比例
    fullscreen_on_one_column = true,
    follow_focus            = true,
    wrap_focus              = false,
}
```

**重要**：scrolling 布局使用 `layoutmsg`（`hl.dsp.layout()`）而非通用的 `focus`/`move` dispatcher。详见下方快捷键表。

**工作区排列模型**：Hyprland 没有 niri 的"竖向工作区"概念，工作区只是编号 1-10。竖向体验通过以下方式实现：
- 窗口在列中**横向排列**（scrolling 布局自然达成）
- 工作区切换用**纵向操作**（`Super+U/I`、三指上下滑）——心理上就是"上下切换工作区"
- 滚轮**左右**在列间滚动，**上下**在工作区间切换

### 编组行为

```lua
group = {
    auto_group             = false,   -- 禁止自动编组
    drag_into_group        = false,
    merge_groups_on_drag   = false,
    merge_floated_into_tiled_on_groupbar = false,
}
```

每列默认只有一个窗口，手动 `Super+W` 编组，`Super+[`/`Super+]` 脱离。

### 触控板手势

对应 niri 的三指/四指操作，通过 `hl.gesture()` 定义：

```lua
-- 三指纵向滑动 → 切换工作区（1:1 跟手）
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
-- 三指横向滑动 → 水平滚动列（scroll_move 专用于 scrolling 布局）
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
-- 四指上滑 → 全局预览（通过 wtype 模拟 Alt+Tab 触发 hyprshell）⚠️ WIP
hl.gesture({ fingers = 4, direction = "up", action = function()
    hl.exec_cmd("wtype -M alt -k Tab")
end })
```

手势参数在 `hl.config` 的 `gestures` 节：

```lua
gestures = {
    workspace_swipe_distance      = 300,   -- 触发距离 (px)
    workspace_swipe_cancel_ratio  = 0.5,   -- 撤回比例
    workspace_swipe_create_new    = true,  -- 滑过最后工作区时新建
    workspace_swipe_invert        = true,  -- 匹配自然滚动方向
    workspace_swipe_direction_lock = true, -- 锁定初始方向
}
```

> **注意**：`workspace_swipe_fingers` 在 0.55 中不存在，手指数量由 `hl.gesture()` 的 `fingers` 参数指定。

| 手势 | 效果 | 对应 niri |
|------|------|----------|
| 三指上下滑 | 切换工作区 | `focus-workspace-down/up` |
| 三指左右滑 | 水平滚动列 | `focus-column-left/right` |
| 四指上滑 ⚠️ WIP | 全局预览（依赖 wtype） | toggle-overview |

### 动画

Hyprland 的 `speed` 是**动画时长**，值越小越快：

```lua
hl.animation({ leaf = "global",      enabled = true, speed = 1,   ... })
hl.animation({ leaf = "windows",     enabled = true, speed = 2,   spring = "mySpring" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 1,   style = "slidevert" })  -- 纵向滑动
```

spring 曲线控制弹性：
```lua
hl.curve("mySpring", { type = "spring", mass = 1, stiffness = 50, dampening = 20 })
-- stiffness ↓ = 弹力小，dampening ↑ = 阻尼大 → 柔和
```

### 窗口规则

关键语法差异（vs 旧 `.conf` 格式）：

| 旧 `windowrulev2` | 新 `hl.window_rule` |
|---|---|
| `opacity 0.95` (数字) | `opacity = "0.95"` (**字符串**) |
| `noblur` | `no_blur` (snake_case) |
| `nofocus` | `no_focus` |
| `maxsize 100% 100%` | `maximize = true` |
| (无) | `scrolling_width = 0.66` (滚动布局专用) |

`match` 字段使用正则，不需要 `class:` 前缀：
```lua
hl.window_rule({
    match = { class = "^org.kde.kcalc$" },
    float = true,
    size  = "20% 50%",
})
```

---

## 快捷键速查表

所有快捷键用 `Super`（Windows 键）作为主修饰键。

### 启动应用

| 快捷键 | 命令 |
|--------|------|
| `Super+T` | Ghostty 终端 |
| `Super+Z` | Zen 浏览器 |
| `Super+M` | Dolphin 文件管理器 |
| `Super+N` | KWrite 编辑器 |
| `Super+X` | VSCode Insiders |
| `Super+D` | Noctalia 启动器 |
| `Super+V` | Noctalia 剪贴板 |
| `Super+`` ` | 下拉终端（Ghostty） |
| `Ctrl+Alt+Del` | MissionCenter 任务管理器 |

### 窗口管理

| 快捷键 | 操作 | 对应 niri |
|--------|------|----------|
| `Super+Q` | 关闭窗口 | `close-window` |
| `Super+F` | 最大化/取消 | `maximize-column` |
| `Super+Shift+F` | 全屏/取消 | `fullscreen-window` |
| `Super+B` | 切换浮动 | `toggle-window-floating` |
| `Super+Shift+B` | 切回上一个窗口 | `focus-previous` |
| `Super+W` | 切换编组 | `toggle-column-tabbed-display` |
| `Super+[` | consume-or-expel 向左 | `consume-or-expel-window-left` |
| `Super+]` | consume-or-expel 向右 | `consume-or-expel-window-right` |

### 列/工作区导航

| 快捷键 | 操作 | 对应 niri |
|--------|------|----------|
| `Super+H/L` / `←→` | 焦点左右列 | `focus-column-left/right` |
| `Super+Ctrl+H/L` | 交换列位置 | `move-column-left/right` |
| `Super+1~0` | 切换到工作区 1-10 | `focus-workspace` |
| `Super+Ctrl+1~0` | 移窗口到工作区 | `move-column-to-workspace` |
| `Super+U/I` | 上/下一个工作区 | `focus-workspace-down/up` |
| `Super+Page_Up/Down` | 上/下一个工作区 | 同上 |
| `Super+R` | **循环预设列宽** (1/3→1/2→2/3) | `switch-preset-column-width` |
| `Super+Minus/Equal` | 微调当前列宽 | `set-column-width` |
| `Super+Home/End` | 跳转首/尾列 | `focus-column-first/last` |

### 滚轮操作

| 快捷键 | 操作 |
|--------|------|
| `Super+滚轮上下` | 切换工作区 |
| `Super+Ctrl+滚轮上下` | 移窗口到工作区 |
| `Super+滚轮左右` | 水平滚动列 |
| `Super+Ctrl+滚轮左右` | 交换列位置 |
| `Super+左键拖拽` | 拖动窗口 |
| `Super+右键拖拽` | 调整窗口大小 |

### 系统

| 快捷键 | 操作 |
|--------|------|
| `Super+Shift+E` | 退出 Hyprland |
| `Super+Shift+S` | 区域截图（复制到剪贴板） |
| `Print` | 全屏截图 |
| `Alt+Print` | 窗口截图 |
| `Super+Shift+P` | 关闭显示器 |
| `Super+Escape` | 逃生舱（打开 Ghostty） |

### 触控板手势

| 手势 | 效果 |
|------|------|
| 三指上下滑 | 切换工作区（1:1 跟手） |
| 三指左右滑 | 水平滚动列 |
| 四指上滑 | 全局预览（同 Super+O） |

### 窗口切换器 ⚠️ WIP

| 快捷键 | 工具 | 效果 |
|--------|------|------|
| `Super+Tab` | hyprshell ⚠️ WIP | 全局预览 + 启动器 |
| `Alt+Tab` | hyprshell ⚠️ WIP | 窗口切换器（GTK4 可视化） |

### 媒体键

| 按键 | 操作 |
|------|------|
| `XF86AudioRaise/Lower` | 音量 +/- |
| `XF86AudioMute` | 静音切换 |
| `XF86AudioMicMute` | 麦克风静音 |
| `XF86AudioPlay/Stop/Prev/Next` | 媒体播放控制 |
| `XF86MonBrightnessUp/Down` | 亮度 +/- |

---

## 配套工具

### Noctalia (v5)

- **安装**：`sudo dnf install noctalia-git`
- **自启动**：`hl.exec_cmd("noctalia --daemon")`
- **启动器**：`noctalia msg panel-toggle launcher`
- **剪贴板**：`noctalia msg panel-toggle clipboard`
- **配置文件**：`~/.config/noctalia/`（首次启动生成）
- **主题设置**：`noctalia msg theme-mode-set dark`

### hyprshell ⚠️ WIP

- **安装**：`cargo install hyprshell`
- **自启动**：`hl.exec_cmd("hyprshell run")`
- **配置文件**：`~/.config/hyprshell/config.ron`
- **GUI 编辑器**：`hyprshell config edit`
- Super+Tab 和 Alt+Tab 由 hyprshell daemon 直接接管，无需在 Hyprland 里绑

### 下拉终端

脚本 `~/.config/hypr/dropdown-terminal.sh`：
- 依赖 `jq` 解析 `hyprctl clients -j`
- `Super+`` 一键切换 Ghostty 下拉窗口
- 已配置窗口规则：99% 宽度、50% 高度、固定在屏幕顶部、不模糊

### 截图

`grimblast copy` —— 截图并自动复制到剪贴板。也保存到 `~/Pictures/Screenshots/`。

---

## 新电脑迁移指南

### 需要复制的文件

```
源机器                          目标机器
───────────────────────────────────────────────
~/.config/hypr/hyprland.lua   → ~/.config/hypr/hyprland.lua
~/.config/hypr/dropdown-terminal.sh → ~/.config/hypr/dropdown-terminal.sh
~/.config/waycorner/config.toml     → ~/.config/waycorner/config.toml  (可选)
```

### 迁移步骤

#### 1. 安装基础软件包

```bash
# Fedora
sudo dnf copr enable lionheartp/Hyprland
sudo dnf install hyprland hyprland-plugins noctalia-git
sudo dnf install grimblast brightnessctl playerctl jq

# hyprshell
cargo install hyprshell
```

#### 2. 复制配置文件

```bash
mkdir -p ~/.config/hypr ~/.config/waycorner
cp hyprland.lua ~/.config/hypr/
cp dropdown-terminal.sh ~/.config/hypr/
chmod +x ~/.config/hypr/dropdown-terminal.sh

# waycorner（可选）
cp config.toml ~/.config/waycorner/
```

#### 3. 初始化 hyprshell

```bash
hyprshell config generate
```

#### 4. 调整显示器配置

**重要**：显示器名称因机器而异。在新机器上运行：

```bash
hyprctl monitors | grep Monitor
```

然后编辑 `hyprland.lua` 中的 `hl.monitor()` 块，修改：
- `output`：显示器名称（如 `eDP-1`、`DP-1`）
- `mode`：分辨率和刷新率（如 `"2560x1600@165.000"`）
- `scale`：缩放比例
- `position`：多显示器时的位置

#### 5. 移除不需要的硬件相关配置

如果需要额外的显示器，在 `hl.monitor()` 中声明即可（Hyprland 会自动启用）。

#### 6. 登录测试

从 SDDM/GDM 选择 Hyprland 会话登录，验证所有快捷键。

### 故障排查

| 问题 | 检查 |
|------|------|
| 快捷键不生效 | `hyprctl binds` 列出所有绑定，确认`hyprctl configerrors` |
| 显示器不显示 | `hyprctl monitors` 查看识别到的显示器名称 |
| Noctalia 无反应 | `noctalia --help` 验证安装，检查 `noctalia msg --help` |
| hyprshell 不启动 | `hyprshell run` 手动启动查看报错 |
| 动画不对 | `hyprctl animations` 查看当前动画配置 |

### 备份脚本

```bash
#!/bin/bash
# 备份 Hyprland 配置
BACKUP_DIR="hyprland-config-backup-$(date +%Y%m%d)"
mkdir "$BACKUP_DIR"
cp ~/.config/hypr/hyprland.lua "$BACKUP_DIR/"
cp ~/.config/hypr/dropdown-terminal.sh "$BACKUP_DIR/"
cp ~/.config/waycorner/config.toml "$BACKUP_DIR/" 2>/dev/null
cp ~/.config/hyprshell/config.ron "$BACKUP_DIR/" 2>/dev/null
tar czf "${BACKUP_DIR}.tar.gz" "$BACKUP_DIR"
rm -r "$BACKUP_DIR"
echo "备份完成: ${BACKUP_DIR}.tar.gz"
```
