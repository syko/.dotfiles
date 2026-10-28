-- ~/.config/nvim/init.lua
--
-- WSL clipboard: put win32yank.exe in ~/.local/bin (grab the x64 zip from
-- https://github.com/equalsraf/win32yank/releases)

-- ── Options ────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt
o.number = true
o.mouse = "a"
o.clipboard = "unnamedplus"
-- On WSL, talk to the Windows clipboard directly via win32yank
if vim.fn.has("wsl") == 1 and vim.fn.executable("win32yank.exe") == 1 then
  vim.g.clipboard = {
    name = "win32yank",
    copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
    paste = { ["+"] = "win32yank.exe -o --lf", ["*"] = "win32yank.exe -o --lf" },
    cache_enabled = 0,
  }
end
o.ignorecase = true
o.smartcase = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.wrap = false
o.undofile = true
o.signcolumn = "yes"
o.updatetime = 250
o.splitright = true
o.splitbelow = true
o.scrolloff = 8
o.termguicolors = true
o.inccommand = "split"

-- ── Keymaps ────────────────────────────────────────────────
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})

-- ── Bootstrap lazy.nvim ────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ────────────────────────────────────────────────
require("lazy").setup({
  -- Colorscheme
  { "folke/tokyonight.nvim", priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true, -- let the terminal's background show through
        styles = { sidebars = "transparent", floats = "transparent" },
      })
      vim.cmd.colorscheme("tokyonight-night")
    end },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Help" },
    } },

  -- File tree sidebar (icons need a Nerd Font in the terminal)
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>t", "<cmd>Neotree toggle reveal<CR>", desc = "File tree" },
    },
    opts = {
      filesystem = { follow_current_file = { enabled = true } },
    } },

  -- Syntax highlighting
  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "bash", "python",
                             "javascript", "typescript", "json", "markdown" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end },

  -- LSP: Mason installs servers, lspconfig provides their configs
  { "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = { ensure_installed = { "lua_ls" } } },

  -- Completion
  { "saghen/blink.cmp", version = "1.*",
    opts = { keymap = { preset = "default" } } },

  -- Git signs in the gutter
  { "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        -- Jump between git changes; in diff mode keep the built-in ]c / [c
        local function nav(key, direction)
          vim.keymap.set("n", key, function()
            if vim.wo.diff then
              vim.cmd.normal({ key, bang = true })
            else
              gs.nav_hunk(direction)
            end
          end, { buffer = bufnr, desc = direction == "next" and "Next git change" or "Prev git change" })
        end
        nav("]c", "next")
        nav("[c", "prev")
      end,
    } },

  -- Scrollbar with diagnostics, git changes and search matches
  { "lewis6991/satellite.nvim",
    config = function()
      require("satellite").setup({})
      local view = require("satellite.view")

      -- Scroll so the clicked spot on the bar (0 = top, last row = bottom)
      -- maps to the same spot in the file, with the cursor in the middle
      local function scroll_to_row(win, row)
        local height = vim.api.nvim_win_get_height(win)
        local total = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win))
        local max_top = math.max(total - height + 1, 1)
        local ratio = math.min(math.max(row / math.max(height - 1, 1), 0), 1)
        local top = math.floor(ratio * (max_top - 1) + 0.5) + 1
        vim.api.nvim_win_call(win, function()
          vim.fn.winrestview({ topline = top, lnum = math.min(top + math.floor(height / 2), total) })
        end)
        view.refresh_bars()
        vim.cmd.redraw()
      end

      local function mouse_row(win)
        return vim.fn.getmousepos().screenrow - vim.fn.win_screenpos(win)[1]
      end

      -- Satellite's own drag handling misses clicks by one row, so handle
      -- the bar here: click anywhere on it to jump, hold and drag to scroll
      vim.keymap.set({ "n", "v", "o", "i" }, "<LeftMouse>", function()
        local pos = vim.fn.getmousepos()
        local win = pos.winid
        local on_bar = win ~= 0 and view.get_props(win) ~= nil
          and pos.wincol >= vim.api.nvim_win_get_width(win) - 1
          and pos.winrow >= 1 and pos.winrow <= vim.api.nvim_win_get_height(win)
        if not on_bar then
          vim.api.nvim_feedkeys(vim.keycode("<LeftMouse>"), "ni", false)
          return
        end
        scroll_to_row(win, mouse_row(win))
        while true do
          local ok, key = pcall(vim.fn.getcharstr)
          if not ok or key == vim.keycode("<LeftRelease>") then break end
          if key ~= vim.keycode("<LeftDrag>") then
            vim.api.nvim_feedkeys(key, "ni", false)
            break
          end
          scroll_to_row(win, mouse_row(win))
        end
      end)
    end },

  -- Shows pending keybinds as you type
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
})
