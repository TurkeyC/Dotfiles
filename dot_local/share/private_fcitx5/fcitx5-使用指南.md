# CapsLock 切换中/英配置

## 目标

在任何输入状态下，按下 CapsLock 切换到纯英文键盘模式（fcitx5 的 keyboard-us），再次按下 CapsLock 回到原输入法。

## 修改的文件

### 1. `~/.config/fcitx5/config`

在 `[Hotkey/TriggerKeys]` 中添加 `Caps_Lock` 作为输入法切换触发键：

```ini
[Hotkey/TriggerKeys]
0=Shift+Shift_L
1=Shift+Shift_R
2=Caps_Lock
```

这样 fcitx5 会在按下 CapsLock 时在输入法组内切换（rime ↔ keyboard-us）。

### 2. `~/.local/share/fcitx5/rime/rime_ice.custom.yaml`

新增 `ascii_composer` 配置，让 Rime 不参与 CapsLock 处理，避免干扰 fcitx5：

```yaml
"ascii_composer/good_old_caps_lock": false       # 不同步 CapsLock LED
"ascii_composer/switch_key":
  Caps_Lock: noop                                  # Rime 不处理 CapsLock
  Shift_L: clear
  Shift_R: clear
```

## 原理

- 用户在 fcitx5 中配了两个输入法：`rime`（雾凇拼音）和 `keyboard-us`（英文键盘）
- `[Hotkey/TriggerKeys]` 控制什么键用于在输入法间切换
- 将 `Caps_Lock` 加入 TriggerKeys，按下 CapsLock 时 fcitx5 会切换到下一个输入法（rime → keyboard-us 或反之）
- Rime 侧用 `Caps_Lock: noop` 确保它不会截胡 CapsLock 事件
- `good_old_caps_lock: false` 防止 Rime 与系统争夺 CapsLock LED 状态

## 使用

修改后需要重启 fcitx5 使配置生效：

```bash
fcitx5 -rd
```

或重启桌面环境。

- 在雾凇拼音下按 CapsLock → 切换到英文键盘
- 再按一次 CapsLock → 回到雾凇拼音
- Shift（左/右）仍可继续用于切换输入法（原有的行为不变）

## 排查

如果 CapsLock 切换无效，检查：

1. fcitx5 配置中 `[Hotkey/TriggerKeys]` 是否包含 `Caps_Lock`
2. 是否重启了 fcitx5
3. 如果使用 Wayland，确认 `waylandim.conf` 存在（已存在则无需操作）
4. 如果使用 X11，部分桌面环境可能拦截 CapsLock 事件，需要检查系统键盘设置
