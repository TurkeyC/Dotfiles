-- ============================================================
--  Hyprland 配置文件 (Lua)
--  基于 niri 配置迁移而来，适配 Hyprland 0.55
--  API 参考: https://wiki.hypr.land/Configuring/
-- ============================================================

-- ===== 变量 =====
local mainMod = "SUPER"
local terminal = "ghostty --window-decoration=false"
local fileManager = "dolphin"
local browser = "gtk-launch Zen"
local editor = "kwrite"
local codeEditor = "code-insiders"

-- ===== 环境变量 =====
hl.env("XCURSOR_THEME", "Breeze_Light")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Breeze_Light")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- ===== 显示器 =====
hl.monitor({
    output   = "eDP-1",
    mode     = "2560x1600@165.000",
    position = "0x0",
    scale    = 1.6,
    vrr      = true,
})

-- DP-9 虚拟显示器默认禁用，需要时手动打开

-- ===== 全局配置 =====
hl.config({
    general = {
        layout = "scrolling",
        allow_tearing = false,
        resize_on_border = true,
        col = {
            active_border   = "rgb(42a5f5)",
            inactive_border = "rgb(8c9199)",
        },
        gaps_in     = 4,
        gaps_out    = 4,
        border_size = 2,
    },

    group = {
        auto_group             = false,
        drag_into_group        = false,
        merge_groups_on_drag   = false,
        merge_floated_into_tiled_on_groupbar = false,

        col = {
            border_active         = "rgb(42a5f5)",
            border_inactive       = "rgb(8c9199)",
            border_locked_active  = "rgb(f2b8b5)",
            border_locked_inactive = "rgb(8c9199)",
        },
        groupbar = {
            col = {
                active         = "rgb(42a5f5)",
                inactive       = "rgb(8c9199)",
                locked_active  = "rgb(f2b8b5)",
                locked_inactive = "rgb(8c9199)",
            },
        },
    },

    -- 滚动布局（最接近 niri 的列布局）
    scrolling = {
        column_width              = 0.5,
        explicit_column_widths    = "0.333, 0.5, 0.666",  -- Mod+R 循环切换
        fullscreen_on_one_column  = true,
        follow_focus              = true,
        wrap_focus                = false,
    },


    decoration = {
        active_opacity   = 0.95,
        inactive_opacity = 0.85,
        rounding         = 12,
        blur = {
            enabled           = true,
            size              = 3,
            passes            = 3,
            noise             = 0.02,
            new_optimizations = true,
            xray              = true,
        },
        shadow = {
            enabled      = true,
            range        = 30,
            render_power = 3,
            offset       = { 0, 5 },
            color        = "rgba(0, 0, 0, 0.47)",
        },
        dim_inactive = false,
        dim_strength = 0.1,
    },

    input = {
        kb_layout          = "us",
        numlock_by_default = true,
        follow_mouse       = 2,
        sensitivity        = 0,
        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            tap_to_click         = true,
            tap_and_drag         = true,
            clickfinger_behavior = false,
            drag_lock            = false,
            middle_button_emulation = false,
        },
    },

    cursor = {
        no_hardware_cursors = false,
        no_warps            = true,
        inactive_timeout    = 0,
    },

    -- XWayland 显示修复
    xwayland = {
        force_zero_scaling    = true,
        use_nearest_neighbor  = false,
    },

    misc = {
        disable_hyprland_logo        = true,
        disable_splash_rendering     = true,
        force_default_wallpaper      = 0,
        vrr                          = 1,
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
        animate_manual_resizes       = true,
        animate_mouse_windowdragging = true,
        enable_swallow               = false,
        focus_on_activate            = true,
        close_special_on_empty       = false,
    },

    -- 触控板手势
    gestures = {
        workspace_swipe_distance      = 300,   -- 触发距离 (px)
        workspace_swipe_cancel_ratio  = 0.5,   -- 撤回比例
        workspace_swipe_create_new    = true,  -- 滑过最后工作区时新建
        workspace_swipe_invert        = true,  -- 匹配自然滚动方向
        workspace_swipe_forever       = false, -- 不跨多工作区连续滑动
        workspace_swipe_direction_lock = true, -- 锁定初始滑动方向
    },
})

-- ===== 动画曲线 =====
hl.curve("easeOutExpo",    { type = "bezier", points = { {0.16, 1},    {0.3, 1}     } })
hl.curve("easeOutQuad",    { type = "bezier", points = { {0.25, 0.46}, {0.45, 0.94} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0},    {0.35, 1}    } })
hl.curve("mySpring",       { type = "spring", mass = 1, stiffness = 50, dampening = 20 })

-- ===== 触控板手势（对应 niri 的三指/四指操作） =====
-- 三指纵向滑动 → 切换工作区（niri: focus-workspace-down/up）
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })

-- 三指横向滑动 → 水平滚动列（niri: focus-column-left/right）
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })

-- 四指上滑 → 全局预览（通过 wtype 模拟 Alt+Tab 触发 hyprshell overview）
hl.gesture({
    fingers = 4,
    direction = "up",
    action = function()
        hl.exec_cmd("wtype -M alt -k Tab")
    end,
})

-- ===== 动画（快速） =====
hl.animation({ leaf = "global",          enabled = true, speed = 1,   bezier = "easeOutExpo"          })
hl.animation({ leaf = "windows",         enabled = true, speed = 2,   spring = "mySpring"             })
hl.animation({ leaf = "windowsIn",       enabled = true, speed = 2,   spring = "mySpring",             style = "popin 80%" })
hl.animation({ leaf = "windowsOut",      enabled = true, speed = 1.5, bezier = "easeOutQuad",          style = "popin 80%" })
hl.animation({ leaf = "fade",            enabled = true, speed = 2,   bezier = "easeOutQuad"          })
hl.animation({ leaf = "fadeOut",         enabled = true, speed = 1.5, bezier = "easeOutQuad"          })
hl.animation({ leaf = "workspaces",      enabled = true, speed = 1,   bezier = "easeOutExpo",          style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2,  bezier = "easeOutExpo",          style = "slidevert" })

-- ===== 窗口规则 =====

-- XWayland 视频桥
hl.window_rule({
    name    = "xwayland-video-bridge",
    match   = { class = "^xwaylandvideobridge$" },
    opacity = "0.3",
    maximize = true,
})

-- 浏览器 (Zen) — 打开占 2/3 屏
hl.window_rule({
    name           = "zen-browser",
    match          = { class = "^zen$" },
    opacity        = "0.95",
    scrolling_width = 0.66,
})

-- 文件管理器 (Dolphin) — 打开占 2/3 屏
hl.window_rule({
    name           = "dolphin",
    match          = { class = "^org.kde.dolphin$" },
    scrolling_width = 0.666,
    opacity        = "0.95",
})

-- 编辑器 (KWrite) — 打开占 1/3 屏
hl.window_rule({
    name           = "kwrite",
    match          = { class = "^org.kde.kwrite$" },
    scrolling_width = 0.333,
    opacity        = "0.95",
})

-- 需要打开就最大化的应用
hl.window_rule({
    name     = "maximized-apps",
    match    = { class = "^(code-insiders|blender|krita|Godot)$" },
    maximize = true,
})

-- 悬浮计算器
hl.window_rule({
    name  = "kcalc-float",
    match = { class = "^org.kde.kcalc$" },
    float = true,
    size  = "20% 50%",
})

-- 悬浮输入法窗口
hl.window_rule({
    name     = "fcitx5-float",
    match    = { title = "^Fcitx5 Input Window$" },
    float    = true,
    size     = "2% 5%",
    no_focus = true,
})

-- Firefox 画中画
hl.window_rule({
    name  = "firefox-pip",
    match = { title = "^Picture-in-Picture$" },
    float = true,
})

-- 游戏
hl.window_rule({
    name  = "steam-game",
    match = { class = "^steam_app_.*$" },
    size  = "100% 90%",
})

-- Ghostty 普通窗口保持不透明
hl.window_rule({
    name    = "ghostty-opaque",
    match   = { class = "^com.mitchellh.ghostty$" },
    opaque  = true,
    no_blur = true,
})

-- 下拉终端 (GhosttyDropdown)
hl.window_rule({
    name     = "ghostty-dropdown",
    match    = { title = "^GhosttyDropdown$" },
    float    = true,
    size     = "99% 50%",
    move     = "0 0",
    opacity  = "0.95",
    no_blur  = true,
    pin      = true,
    no_anim  = true,
})

-- ===== 快捷键 =====

-- 启动应用
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(codeEditor))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + GRAVE", hl.dsp.exec_cmd("bash /home/casuki/.config/hypr/dropdown-terminal.sh"))
hl.bind(mainMod .. " + O", function()
    hl.dispatch(hl.dsp.global("hyprexpo:expo_toggle"))
end)
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("flatpak run io.missioncenter.MissionCenter"))

-- 逃生舱
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd(terminal))

-- 关闭/退出
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprctl dispatch dpms off"))

-- 焦点移动（滚动布局专用 focus）
hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + left", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + right", hl.dsp.layout("focus r"))

-- 列交换（niri: move-column-left/right）
hl.bind(mainMod .. " + CTRL + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.layout("swapcol r"))

-- 工作区切换 (1-10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,
        hl.dsp.window.move({ workspace = i }))
end

-- 工作区翻页
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + Page_Up",   hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + U", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "-1" }))

hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + CTRL + Page_Up",   hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + CTRL + U", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + CTRL + I", hl.dsp.window.move({ workspace = "-1" }))

hl.bind(mainMod .. " + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + Page_Up",   hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "-1" }))

-- 滚轮切换工作区 (niri: Mod+WheelScrollDown/Up → focus-workspace-down/up)
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + mouse_up",   hl.dsp.window.move({ workspace = "e+1" }))

-- 水平滚轮切列
hl.bind(mainMod .. " + mouse_left",        hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + mouse_right",       hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + CTRL + mouse_left",  hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + CTRL + mouse_right", hl.dsp.layout("swapcol r"))

-- Super+鼠标拖动/调整窗口
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- 滚轮切列 (niri: Mod+Shift+WheelScrollDown/Up → focus-column-right/left)
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + mouse_up",   hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + SHIFT + mouse_down", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + SHIFT + mouse_up",   hl.dsp.window.move({ direction = "right" }))

-- 窗口状态
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.focus({ window = "last" }))
hl.bind(mainMod .. " + W", hl.dsp.window.tag({ tag = "toggle" }))

-- consume-or-expel（niri 同款：独立窗口→并入邻列；已合并→脱离为独立列）
hl.bind(mainMod .. " + bracketleft",  hl.dsp.layout("consume_or_expel prev"))
hl.bind(mainMod .. " + bracketright", hl.dsp.layout("consume_or_expel next"))

-- 列首/列尾
hl.bind(mainMod .. " + Home", hl.dsp.focus({ window = "first" }))
hl.bind(mainMod .. " + End",  hl.dsp.focus({ window = "last" }))

-- 列宽调整（niri: switch-preset-column-width / set-column-width）
hl.bind(mainMod .. " + R", hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -0.05"))
hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +0.05"))

-- 截图
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast copy screen"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("grimblast copy active"))

-- 媒体键
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop",        hl.dsp.exec_cmd("playerctl stop"),      { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),  { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),      { locked = true })

-- 亮度键
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl --class=backlight set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --class=backlight set 5%-"), { locked = true, repeating = true })

-- Alt+Tab / Super+Tab 由 hyprshell daemon 接管 ⚠️ WIP（GTK4 可视化窗口切换器）

-- ===== 自启动 =====
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia --daemon")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("hyprshell run")  -- ⚠️ WIP
end)
