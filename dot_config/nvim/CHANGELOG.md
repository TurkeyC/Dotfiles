# Neovim 配置变更记录

## 2026-05-26 VSCode 风格快捷键

### 新增快捷键

| 快捷键 | 模式 | 作用 |
|--------|------|------|
| `Ctrl+A` | Normal | 全选 |
| `Ctrl+/` | Normal / Visual | 注释切换 |
| `Ctrl+S` | Insert | 保存（不退出 insert 模式） |

### 备注
- 修改文件：`lua/plugins/astrocore.lua`
- `Ctrl+F` 和 `Ctrl+Shift+P` 已移除：前者需要 ripgrep 且覆盖翻页，后者与 Ghostty 终端冲突
- `Ctrl+/` 在部分终端可能不生效，可用 `<Space>/` 作为后备

---

## 2026-05-25 初次自定义

### 解决的问题

#### 1. 右键弹出菜单 → 改为粘贴系统剪贴板
- 修改文件：`lua/plugins/astrocore.lua`
- 设置 `mousemodel = "extend"` 禁用 Nvim 原生右键菜单
- Visual 模式下右键 → 粘贴系统剪贴板 (`"+p`)
- Insert 模式下右键 → 粘贴系统剪贴板 (`<C-r>+`)

#### 2. Ctrl+C / Ctrl+X 走系统剪贴板
- 修改文件：`lua/plugins/astrocore.lua`
- Visual 模式下 Ctrl+C → 复制到系统剪贴板 (`"+y`)
- Visual 模式下 Ctrl+X → 剪切到系统剪贴板 (`"+d`)
- 注意：`y`/`d`/`p` 等原生操作不干扰系统剪贴板，只有 Ctrl+C/X 走系统剪贴板

#### 3. Ctrl+Z / Ctrl+Shift+Z 撤销 / 重做
- 修改文件：`lua/plugins/astrocore.lua`
- Normal 模式下 Ctrl+Z → `u`（撤销，覆盖默认的挂起到后台行为）
- Normal 模式下 Ctrl+Shift+Z → `<C-r>`（重做）
- Insert 模式下 Ctrl+Z → `<C-o>u`（退出插入、撤销、返回插入）

#### 4. 中文输入法兼容（全角符号映射）
- 修改文件：`lua/plugins/astrocore.lua`
- Normal 模式下 `：` → `:`（全角冒号映射为半角，在中文输入法下也能输入 `:wq`）
- Normal 模式下 `／` → `/`（全角斜杠映射为半角，在中文输入法下也能搜索）

#### 5. 离开 Insert 模式自动切换到英文输入法
- 修改文件：`lua/polish.lua`
- 启用原来的 `polish.lua`（删除了 `if true then return end`）
- 基于 fcitx5 + RIME 输入法框架
- `InsertLeave`：自动调用 `fcitx5-remote -s keyboard-us` 切换到英文键盘
- `InsertEnter`：自动恢复之前的输入法（RIME 中文）
- 提供 `:FcitxStatus` 命令调试输入法状态

### 文件改动总览

```
~/.config/nvim/
├── lua/
│   ├── polish.lua              # 启用 + 新增 fcitx5 输入法自动切换 + :FcitxStatus 命令
│   └── plugins/
│       └── astrocore.lua        # 新增按键映射、鼠标行为、中文符号兼容
```

### 新增快捷键

| 快捷键 | 模式 | 作用 |
|--------|------|------|
| `Ctrl+C` | Visual | 复制到系统剪贴板 |
| `Ctrl+X` | Visual | 剪切到系统剪贴板 |
| `右键` | Visual / Insert | 粘贴系统剪贴板 |
| `Ctrl+Z` | Normal / Insert | 撤销 |
| `Ctrl+Shift+Z` | Normal | 重做 |
| `：` | Normal | 全角冒号 → 命令模式（中文输入兼容） |
| `／` | Normal | 全角斜杠 → 搜索（中文输入兼容） |
