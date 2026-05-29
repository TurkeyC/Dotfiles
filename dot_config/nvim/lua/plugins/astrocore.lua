-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        mousemodel = "extend", -- 禁用右键弹出菜单，改为扩展选择模式

        -- 光标样式
        guicursor = "n-v-c:ver25,i-ci-ve:ver25,r-cr:hor20,o:hor50",
        -- 解释：
        -- n-v-c:block      → 普通/视觉/命令行模式：块状
        -- i-ci-ve:ver25    → 插入模式：25% 宽度的竖线（细长）
        -- r-cr:hor20       → 替换模式：20% 高度的横线
        -- o:hor50          → 操作符等待：50% 高度的横线
        shell = "/usr/bin/zsh", -- 默认的内置终端改成zsh
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- Ctrl+Z 撤销（覆盖默认的挂起行为）
        ["<C-z>"] = { "u", desc = "Undo" },
        -- Ctrl+Shift+Z 重做
        ["<C-S-z>"] = { "<C-r>", desc = "Redo" },

        -- VSCode 风格快捷键
        ["<C-a>"] = { "ggVG", desc = "Select all" },
        ["<C-_>"] = { "gcc", remap = true, desc = "Toggle comment line" },
        ["<C-/>"] = { "gcc", remap = true, desc = "Toggle comment line" },

        -- 中文输入法兼容：全角符号映射到半角
        ["："] = { ":", desc = "Fullwidth colon" },
        ["／"] = { "/", desc = "Fullwidth slash" },
        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      v = {
        -- Ctrl+C 复制选中内容到系统剪贴板
        ["<C-c>"] = { '"+y', desc = "Copy to system clipboard" },
        -- Ctrl+X 剪切选中内容到系统剪贴板
        ["<C-x>"] = { '"+d', desc = "Cut to system clipboard" },
        -- 右键粘贴系统剪贴板
        ["<RightMouse>"] = { '"+p', desc = "Paste from system clipboard" },
        -- VSCode 风格快捷键
        ["<C-_>"] = { "gc", remap = true, desc = "Toggle comment" },
        ["<C-/>"] = { "gc", remap = true, desc = "Toggle comment" },
      },
      i = {
        -- Ctrl+Z 撤销（插入模式下退出撤销再回到插入）
        ["<C-z>"] = { '<C-o>u', desc = "Undo" },
        -- 右键粘贴系统剪贴板（插入模式）
        ["<RightMouse>"] = { '<C-r>+', desc = "Paste from system clipboard" },
        -- VSCode 风格快捷键
        ["<C-s>"] = { '<C-o>:w<CR>', desc = "Save" },
      },
    },
  },
}
