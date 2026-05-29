-- 使用 fcitx5-remote 管理输入法状态，解决 Normal 模式下中文候选框的问题
local fcitx_bin = "/usr/bin/fcitx5-remote"

-- 创建一个手动测试命令，查看当前输入法状态
vim.api.nvim_create_user_command("FcitxStatus", function()
  local ret = vim.fn.system({ fcitx_bin }):gsub("%s+", "")
  local name = vim.fn.system({ fcitx_bin, "-n" }):gsub("%s+", "")
  local state_map = { [0] = "关闭", [1] = "未激活", [2] = "激活中" }
  local status = state_map[tonumber(ret)] or "未知(" .. ret .. ")"
  vim.notify(string.format("输入法: %s (%s)", name, status), vim.log.levels.INFO)
end, { desc = "Show fcitx5 input method status" })

-- 离开 Insert → 切到英文键盘
vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Switch to English IME in normal mode",
  callback = function()
    vim.g.fcitx_last_im = vim.fn.system({ fcitx_bin, "-n" }):gsub("%s+", "")
    vim.fn.jobstart({ fcitx_bin, "-s", "keyboard-us" })
  end,
})

-- 进入 Insert → 恢复之前的输入法
vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Restore previous IME in insert mode",
  callback = function()
    if vim.g.fcitx_last_im and vim.g.fcitx_last_im ~= "" then
      vim.fn.jobstart({ fcitx_bin, "-s", vim.g.fcitx_last_im })
    end
  end,
})
