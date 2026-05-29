#!/bin/bash

TARGET_TITLE="GhosttyDropdown"
NOTIFY_ICON="utilities-terminal"

# 通过 hyprctl 查找匹配标题的窗口 PID
MATCH_PIDS=$(hyprctl clients -j 2>/dev/null | jq -r --arg title "$TARGET_TITLE" '.[] | select(.title == $title) | .pid')

if [[ -n "$MATCH_PIDS" ]]; then
    for pid in $MATCH_PIDS; do
        kill "$pid" 2>/dev/null
    done
    notify-send -u low "下拉式终端已关闭" "已退出窗口 \"${TARGET_TITLE}\"" -i "$NOTIFY_ICON" -t 2000
else
    nohup ghostty --title="$TARGET_TITLE" --window-decoration=false >/dev/null 2>&1 &
    disown
    notify-send -u low "下拉式终端已启动" "已创建窗口 \"${TARGET_TITLE}\"" -i "$NOTIFY_ICON" -t 2000
fi
