return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true, -- 启用透明背景
    styles = {
      sidebars = "transparent", -- 侧边栏透明
      floats = "transparent", -- 浮动窗口透明
    },
    -- 可选：其他配置
    -- on_colors = function(colors)
    --   -- 自定义颜色
    -- end,
    -- on_highlights = function(highlights, colors)
    --   -- 自定义高亮
    -- end,
    --
    -- 自定义高亮组
    on_highlights = function(highlights, colors)
      -- 行号颜色（普通行号）
      highlights.LineNr = {
        fg = colors.blue3, -- 使用更亮的蓝色
        -- 或者用具体颜色：fg = "#7aa2f7"
      }
    end,
  },
}
