# Fcitx5 输入法使用指南

## 一、系统概览

你的输入法系统由三组「输入法组」组成，通过快捷键在不同场景间快速切换：

```
Super+Space → 默认(雾凇拼音) → 日语(Mozc) → 游戏(纯英文) → 回到默认
Super+Shift+Space → 反向切换
```

| 组名 | 默认输入法 | 用途 |
|------|-----------|------|
| **默认** | 雾凇拼音（Rime） | 日常中文输入 |
| **日语** | Mozc | 日文输入 |
| **游戏** | 纯英文键盘 | 打游戏时防止输入框弹出 |

---

## 二、日常操作速查

### 切换输入法组

| 快捷键 | 功能 |
|--------|------|
| `Super + Space` | 切换到下一个组 |
| `Super + Shift + Space` | 切换到上一个组 |

### 雾凇拼音（Rime）内部

| 快捷键 | 功能 |
|--------|------|
| `Caps Lock` | 切换 中文/英文 模式（系统 LED 同步：亮=大写英文，灭=中文） |
| `Shift`（左/右）| 清空预输入并切换 中文/英文 模式 |
| `Ctrl + `` ` | 打开 Rime 方案选单 |
| `F4` | 同上，打开方案选单 |
| `-` / `=` | 候选词翻页（向前 / 向后） |
| `[` / `]` | 以词定字（取首字 / 末字） |
| `Tab` / `Shift + Tab` | 在拼音间移动光标 |
| `Ctrl + Shift + 3` | 切换中英标点 |
| `Ctrl + Shift + 4` | 切换简繁 |

> **Caps Lock 工作原理**：`good_old_caps_lock: true` 让系统管理 Caps Lock LED，同时 `switch_key/Caps_Lock: clear` 让 Rime 在收到 Caps Lock 按键时切换 `ascii_mode`。两者同时生效——LED 亮=英文大写模式，灭=中文模式。`noop` 会阻止模式切换（`SwitchAsciiMode` 被跳过），不能用。

### Mozc（日语）

| 快捷键 | 功能 |
|--------|------|
| `Shift` | 切换日文 / 英文输入模式 |
| `F10` | 将输入转为半角英文 |
| `F7` | 将输入转为全角片假名 |
| `Space` | 转换汉字 |
| `Tab` | 切换候选 |

---

## 三、输入技巧

### 3.1 英文输入

- **Caps Lock**：按一下（灯亮）→ 大写英文模式，无候选框弹出，输出英文标点；再按（灯灭）→ 回到中文
- **Shift**：按一下清空预输入并切到英文，再按切回中文
- **临时英文**：中文模式下直接输入英文单词，按 `Enter` 上屏英文（无需切换，由 melt_eng 英文辅入引擎提供）

### 3.2 特殊符号

| 输入 | 输出 |
|------|------|
| `rq` | 日期（如 2026-05-25） |
| `sj` | 时间（如 13:45） |
| `xq` | 星期（如 星期一） |
| `/` 开头 + 符号拼音 | 搜索符号（如 `/wjx` → ★） |

### 3.3 U 模式部件拆字

输入 `u` + 字的组成部分来查找不认识的字。例如输入 `uhaoxin`（好+心）来查找由「女子心」组成的字。

### 3.4 模糊拼音

已启用以下模糊音，输入不标准的拼音也能匹配：

- `eng/en`, `ing/in` —— 前后鼻音混淆

如需开启/关闭其他模糊音，编辑 `rime_ice.custom.yaml` 中 `speller/algebra` 下的规则，注释掉对应行后重新部署生效。

### 3.5 自定义短语

在 `~/.local/share/fcitx5/rime/custom_phrase.txt` 中添加，格式：
```
你的自定义短语<Tab>编码<Tab>权重
```

---

## 四、配置文件速查

配置分两层：**全局补丁** (`default.custom.yaml`) 和 **方案补丁** (`rime_ice.custom.yaml`)。放错文件会导致配置不生效。

| 文件 | 作用域 | 负责的配置 |
|------|--------|-----------|
| `~/.config/fcitx5/profile` | fcitx5 | 输入法组定义和顺序 |
| `~/.config/fcitx5/config` | fcitx5 | 快捷键和行为设置 |
| `~/.local/share/fcitx5/rime/default.custom.yaml` | Rime 全局 | `schema_list`、`menu`、`ascii_composer`（Caps/Shift 行为）|
| `~/.local/share/fcitx5/rime/rime_ice.custom.yaml` | 雾凇拼音方案 | `speller`（拼音规则）、`switches`（默认状态）、`grammar`（语法模型）、`translator`（上下文联想）|
| `~/.local/share/fcitx5/rime/wanxiang-lts-zh-hans.gram` | Rime 全局 | 万象语法模型文件（约 235 MB） |

修改 YAML 文件后必须重新部署：`killall fcitx5 && fcitx5 -d`

---

## 五、GUI 配置工具

| 工具 | 用途 |
|------|------|
| `fcitx5-configtool` | fcitx5 全局设置（快捷键、皮肤、插件开关） |
| `mozc-tool` | Mozc 日语输入法设置（词典、快捷键等） |

> Rime / 雾凇拼音没有 GUI 配置工具，所有设置通过编辑 YAML 文件完成。

---

## 六、常见问题

### Q: 输入法突然不见了 / 打不出中文

A: `killall fcitx5 && fcitx5 -d` 重启输入法框架，然后右键托盘图标 →「部署」。

### Q: 切换组的时候顺序不对

A: 编辑 `~/.config/fcitx5/profile` 中的 `[GroupOrder]` 部分，重启 fcitx5。

### Q: Caps Lock 按下后没有切换中英

A: 检查 `~/.local/share/fcitx5/rime/build/default.yaml` 中 `ascii_composer` 部分：
```yaml
good_old_caps_lock: true
switch_key:
  Caps_Lock: clear
```
如果 `Caps_Lock` 是 `noop`，说明 `default.custom.yaml` 补丁有误——`noop` 会导致 `SwitchAsciiMode` 被跳过，模式切换不执行。应改为 `clear`，然后重新部署。

### Q: 模糊拼音太过了 / 不够

A: 编辑 `rime_ice.custom.yaml` → `speller/algebra` 下注释（加 `#`）或取消注释对应规则。重新部署生效。

### Q: 万象模型没有生效

A: 检查：
1. `~/.local/share/fcitx5/rime/wanxiang-lts-zh-hans.gram` 文件存在（约 235 MB）
2. `rime_ice.custom.yaml` 中有 `"grammar/language": wanxiang-lts-zh-hans`
3. 已重新部署
4. 验证：输入长句如「渐渐地就不在意了」，断句应该准确

### Q: Mozc 不工作

A: 确认已安装 `fcitx5-mozc`：
```bash
sudo dnf install -y fcitx5-mozc
killall fcitx5; fcitx5 -d
```

### Q: 游戏中出现输入框

A: 用 `Super + Space` 切换到「游戏」组，该组只有纯英文键盘，不会弹出输入法窗口。

---

## 七、进阶配置

### 开启/关闭特定模糊音

编辑 `rime_ice.custom.yaml`，在 `speller/algebra` 下取消注释或注释对应行。可用的模糊音规则：

```yaml
# 平翘舌模糊
# - derive/^([zcs])h/$1/          # zh/ch/sh → z/c/s
# - derive/^([zcs])([^h])/$1h$2/  # z/c/s → zh/ch/sh
# 鼻音混淆
# - derive/^l/n/
# - derive/^n/l/
# 前后鼻音模糊（当前仅 eng/en、ing/in 启用）
# - derive/ang$/an/
# - derive/an$/ang/
- derive/eng$/en/
- derive/en$/eng/
- derive/ing$/in/
- derive/in$/ing/
```

### 调整语法模型灵敏度

在 `rime_ice.custom.yaml` 中修改：
- `collocation_penalty: -10` → 调高（如 `-8`）使常见搭配更优先
- `non_collocation_penalty: -17` → 调高使非搭配输入更难出现

### 修改 Caps Lock / Shift 行为

编辑 `default.custom.yaml`（注意：必须在全局补丁文件中）：

```yaml
# Caps Lock 切换中英（clear: Rime 切换模式 + good_old_caps_lock: 系统同步 LED）
"ascii_composer/good_old_caps_lock": true   # true=系统管LED, false=Rime拦截(Linux不工作)
"ascii_composer/switch_key/Caps_Lock": clear # clear|commit_code|commit_text|noop
# 注意：noop 会导致 SwitchAsciiMode 被跳过，Caps Lock 无法切换中英
# Shift 行为
"ascii_composer/switch_key/Shift_L": clear  # clear|commit_code|commit_text|inline_ascii|noop
```

### 添加更多词库

在 `default.custom.yaml` 的 `schema_list` 中添加新 schema（需预先放入对应 `.schema.yaml` 和 `.dict.yaml` 文件）。
