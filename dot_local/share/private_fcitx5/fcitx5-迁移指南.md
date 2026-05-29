# Fcitx5 输入法快速迁移指南（Fedora）

## 适用场景

在新安装的 Fedora 系统上快速部署：
- **雾凇拼音**（基于 Rime，中文全拼）
- **Mozc**（日语输入）
- **万象语法模型**（智能长句预测，可选）

---

## 第一步：安装软件包

```bash
sudo dnf install -y \
  fcitx5 \
  fcitx5-rime \
  fcitx5-chinese-addons \
  fcitx5-mozc \
  fcitx5-configtool \
  fcitx5-autostart \
  fcitx5-gtk2 fcitx5-gtk3 fcitx5-gtk4 \
  fcitx5-qt5 fcitx5-qt6
```

> `fcitx5-autostart` 让 fcitx5 开机自启。

---

## 第二步：设置环境变量

在 `~/.bash_profile`（或 `~/.config/environment.d/fcitx5.conf`）中添加：

```bash
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export SDL_IM_MODULE=fcitx5
export GLFW_IM_MODULE=ibus
```

**重新登录**使环境变量生效。

---

## 第三步：下载雾凇拼音配置

### 方案 A：从旧电脑直接复制（推荐）

```bash
# 在旧电脑上打包
cd ~/.local/share/fcitx5
tar czf ~/fcitx5-rime-backup.tar.gz rime/

# 同时备份 fcitx5 配置
cp ~/.config/fcitx5/profile ~/fcitx5-profile-backup
cp ~/.config/fcitx5/config ~/fcitx5-config-backup
```

```bash
# 在新电脑上还原
cd ~/.local/share/fcitx5
tar xzf ~/fcitx5-rime-backup.tar.gz
mkdir -p ~/.config/fcitx5
cp ~/fcitx5-profile-backup ~/.config/fcitx5/profile
cp ~/fcitx5-config-backup ~/.config/fcitx5/config
```

### 方案 B：从 GitHub 重新下载

```bash
RIME_DIR=~/.local/share/fcitx5/rime
git clone https://github.com/iDvel/rime-ice.git "$RIME_DIR/rime-ice"
cp "$RIME_DIR/rime-ice"/*.yaml "$RIME_DIR/"
cp -r "$RIME_DIR/rime-ice"/{cn_dicts,en_dicts,lua,opencc,others} "$RIME_DIR/"
```

---

## 第四步：配置输入法组

编辑 `~/.config/fcitx5/profile`：

```ini
[Groups/0]
Name=默认
Default Layout=us
DefaultIM=rime

[Groups/0/Items/0]
Name=keyboard-us

[Groups/0/Items/1]
Name=rime

[Groups/1]
Name=日语
Default Layout=us
DefaultIM=mozc

[Groups/1/Items/0]
Name=keyboard-us

[Groups/1/Items/1]
Name=mozc

[Groups/2]
Name=游戏
Default Layout=us
DefaultIM=keyboard-us

[Groups/2/Items/0]
Name=keyboard-us

[GroupOrder]
0=默认
1=日语
2=游戏
```

---

## 第五步：配置雾凇拼音自定义

> **关键**：Rime 的配置补丁分为两层，放错文件会导致配置不生效。

### 全局补丁 `~/.local/share/fcitx5/rime/default.custom.yaml`

```yaml
patch:
  schema_list:
    - schema: rime_ice

  # 候选词数量
  "menu/page_size": 7

  # Caps Lock 切换中/英（Rime 切换 ascii_mode，good_old_caps_lock: true 让系统同步切换 LED）
  "ascii_composer/good_old_caps_lock": true
  "ascii_composer/switch_key/Caps_Lock": clear
  # Shift 清空预输入并切换中/英
  "ascii_composer/switch_key/Shift_L": clear
  "ascii_composer/switch_key/Shift_R": clear
```

### 方案补丁 `~/.local/share/fcitx5/rime/rime_ice.custom.yaml`

```yaml
patch:
  # 模糊拼音（注释掉对应行可禁用某项）
  "speller/algebra":
    __append:
      # 平翘舌模糊: zh/ch/sh ↔ z/c/s
      # - derive/^([zcs])h/$1/
      # - derive/^([zcs])([^h])/$1h$2/
      # 鼻音混淆: n ↔ l
      # - derive/^l/n/
      # - derive/^n/l/
      # 前后鼻音模糊
      # - derive/ang$/an/
      # - derive/an$/ang/
      - derive/eng$/en/
      - derive/en$/eng/
      - derive/ing$/in/
      - derive/in$/ing/

  # 启动时始终默认为中文模式
  "switches/ascii_mode/reset": 0

  # 万象语法模型
  "grammar/language": wanxiang-lts-zh-hans
  "grammar/collocation_max_length": 5
  "grammar/collocation_min_length": 2
  "grammar/collocation_penalty": -10
  "grammar/non_collocation_penalty": -17

  # 上下文联想
  "translator/contextual_suggestions": true
  "translator/max_homophones": 7
  "translator/max_homographs": 7
```

### 配置作用域速查

| 配置项 | 所属文件 | 原因 |
|--------|---------|------|
| `schema_list` | `default.custom.yaml` | 全局方案列表 |
| `menu/page_size` | `default.custom.yaml` | 全局候选词设置 |
| `ascii_composer/*` | `default.custom.yaml` | **全局**键盘行为（定义在 `default.yaml`）|
| `speller/algebra` | `rime_ice.custom.yaml` | 方案级拼音规则 |
| `switches/*` | `rime_ice.custom.yaml` | 方案级开关（定义在 `rime_ice.schema.yaml`）|
| `grammar/*` | `rime_ice.custom.yaml` | 方案级语法模型 |
| `translator/*` | `rime_ice.custom.yaml` | 方案级翻译器设置 |

> 如果放错层级（如将 `ascii_composer` 写在 `rime_ice.custom.yaml`），Rime 不会报错但配置不会生效。遇到不生效的情况，检查 `build/default.yaml` 查看编译后的配置是否包含你的修改。

---

## 第六步：下载万象语法模型（可选）

```bash
cd ~/.local/share/fcitx5/rime
curl -L -o wanxiang-lts-zh-hans.gram \
  "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram"
```

模型约 235 MB。

---

## 第七步：重启并部署

```bash
killall fcitx5; fcitx5 -d
```

然后右键系统托盘 fcitx5 图标 →「部署」。

---

## 验证检查清单

| 检查项 | 验证方法 |
|--------|----------|
| fcitx5 运行 | `ps aux \| grep fcitx5` |
| Rime 加载 | `Super+Space` 切到「默认」组，输入拼音看是否有候选 |
| Caps Lock 切换 | 按 Caps Lock（灯亮）→ 应自动进入英文模式；再按（灯灭）→ 回中文 |
| Shift 切换 | 输入拼音到一半按 Shift → 清空预输入并切到英文；再按 Shift → 回中文 |
| Mozc 加载 | `Super+Space` 切到「日语」组，输入日文 |
| 语法模型 | 输入长句如「渐渐地就不在意了」，断句应准确 |
| 模糊拼音 | 输入 `zengque` 应能匹配「正确」 |
| 游戏模式 | 切到「游戏」组，敲键盘不应弹出输入框 |
| 默认中文 | 重启 fcitx5 后，默认组应为中文模式（非英文） |

---

## 快速一键脚本

保存为 `~/setup-fcitx5.sh`：

```bash
#!/bin/bash
set -e

echo "=== 安装 fcitx5 及相关包 ==="
sudo dnf install -y fcitx5 fcitx5-rime fcitx5-chinese-addons \
  fcitx5-mozc fcitx5-configtool fcitx5-autostart \
  fcitx5-gtk2 fcitx5-gtk3 fcitx5-gtk4 fcitx5-qt5 fcitx5-qt6

echo "=== 克隆雾凇拼音 ==="
RIME_DIR=~/.local/share/fcitx5/rime
mkdir -p "$RIME_DIR"
cd "$RIME_DIR"
git clone https://github.com/iDvel/rime-ice.git rime-ice
cp rime-ice/*.yaml .
cp -r rime-ice/{cn_dicts,en_dicts,lua,opencc,others} .

echo "=== 下载万象模型 ==="
curl -L -o wanxiang-lts-zh-hans.gram \
  "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram"

echo "=== 请手动创建配置文件 ==="
echo "需要创建:"
echo "  ~/.config/fcitx5/profile"
echo "  ~/.local/share/fcitx5/rime/default.custom.yaml"
echo "  ~/.local/share/fcitx5/rime/rime_ice.custom.yaml"
echo "参考上方文档中的配置内容"
echo ""
echo "=== 然后 ==="
echo "  重新登录使环境变量生效"
echo "  killall fcitx5; fcitx5 -d"
```

---

## 备份清单（迁移前在旧电脑执行）

```bash
# 打包
tar czf ~/fcitx5-full-backup-$(date +%Y%m%d).tar.gz \
  -C ~/.local/share/fcitx5 rime/ \
  -C ~/.config fcitx5/profile fcitx5/config
```
