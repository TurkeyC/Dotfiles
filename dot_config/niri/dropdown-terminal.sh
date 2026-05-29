#!/bin/bash

TARGET_TITLE="GhosttyDropdown"
NOTIFY_ICON="utilities-terminal"

# 通过 niri 原生接口精确匹配标题并提取对应 PID
MATCH_PIDS=$(niri msg windows 2>/dev/null | awk -v target="$TARGET_TITLE" '
    /Title:/ {
        line = $0
        gsub(/.*Title: "/, "", line)
        gsub(/".*/, "", line)
        if (line == target) found = 1; else found = 0
    }
    found && /PID:/ {
        print $2
        found = 0
    }
')

if [[ -n "$MATCH_PIDS" ]]; then
    # ✅ 窗口存在：终止进程并发送系统通知
    for pid in $MATCH_PIDS; do
        kill "$pid" 2>/dev/null
    done
    # -u low: 低优先级（次要通知），通常不记录历史，显示更低调
    notify-send -u low "下拉式终端已关闭" "已退出窗口 \"${TARGET_TITLE}\"" -i "$NOTIFY_ICON" -t 2000
else
    # ❌ 窗口不存在：启动新窗口并发送系统通知
    nohup ghostty --title="$TARGET_TITLE" --window-decoration=false >/dev/null 2>&1 &
    disown
    notify-send -u low "下拉式终端已启动" "已创建窗口 \"${TARGET_TITLE}\"" -i "$NOTIFY_ICON" -t 2000
fi
