-- ============================================================================
-- NEOVIM LUA CONFIGURATION
-- Migrated from VimScript (.vimrc) — 2026-02-10
-- Plugin Manager: lazy.nvim | LSP: Native | Theme: Catppuccin Mocha
--
-- Original .vimrc kept as fallback for regular Vim.
-- This file replaces ~/.config/nvim/init.vim (backed up to init.vim.bak).
-- ============================================================================

-- ========================== LEADER (must be set before lazy) ================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ========================== BOOTSTRAP LAZY.NVIM =============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================== DISABLE UNUSED PROVIDERS ========================
-- Python3 provider auto-detection costs ~355ms on every startup.
-- Disable all providers we don't use (no Python/Ruby/Perl/Node remote plugins).
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0

-- ========================== OPTIONS =========================================
local opt = vim.opt

opt.termguicolors = true
opt.background    = "dark"
opt.backspace     = "indent,eol,start"
opt.ruler         = true
opt.splitright    = true
opt.mouse         = "a"
opt.cursorline    = true
opt.incsearch     = true
opt.hlsearch      = true
opt.showcmd       = true
opt.autoread      = true
opt.autoindent    = true
opt.smartindent   = true
opt.expandtab     = true
opt.tabstop       = 4
opt.shiftwidth    = 4
opt.wildignore:append({ "*/tmp/*", "*.so", "*.swp", "*.zip" })
opt.history       = 1000
opt.wrap          = false
opt.hidden        = true
opt.autochdir     = false
opt.ignorecase    = true
opt.smartcase     = true
opt.swapfile      = false
opt.tags          = "tags;/"
opt.clipboard     = "unnamed,unnamedplus"
opt.scrolloff     = 10
opt.ttimeout      = true
opt.ttimeoutlen   = 0
opt.timeoutlen    = 500
opt.number        = true
opt.relativenumber = true
opt.numberwidth   = 2
opt.laststatus    = 2
opt.showmode      = false
opt.updatetime    = 300
opt.signcolumn    = "yes"

-- ========================== CLIPBOARD (macOS) ===============================
if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
  vim.g.clipboard = {
    name = "pbcopy",
    copy  = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 1,
  }
  vim.api.nvim_create_user_command("TestClipboard", function()
    vim.fn.system("pbcopy", "test clipboard")
    print("Clipboard test sent — try Cmd+V")
  end, {})
end

-- ========================== HELPER FUNCTIONS ================================
local function copy_file_path()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print(path)
end

local function quickfix_toggle()
  for i = 1, vim.fn.winnr("$") do
    if vim.fn.getbufvar(vim.fn.winbufnr(i), "&buftype") == "quickfix" then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end

local function jump_or_open(direction, cmd, use_files)
  local current = vim.fn.winnr()
  vim.cmd("wincmd " .. direction)
  if current == vim.fn.winnr() then
    vim.cmd(cmd)
  end
  if use_files then
    vim.cmd("Files")
  else
    vim.cmd("Rg")
  end
end

local function buf_nav(cmd)
  return function()
    if vim.bo.modifiable and not vim.bo.readonly and vim.bo.modified then
      vim.cmd("write")
    end
    vim.cmd(cmd)
  end
end

local function yaml_tree()
  local list = {}
  local cur = vim.fn.getcurpos()[2]
  local indent_level = vim.fn.indent(cur) + 1
  for n = cur, 1, -1 do
    local i = vim.fn.indent(n)
    local line = vim.fn.getline(n)
    local key = line:match("^%s*(%w+):")
    if key and i < indent_level then
      table.insert(list, 1, key)
      indent_level = i
    end
  end
  print(table.concat(list, " -> "))
end

vim.api.nvim_create_user_command("YAMLTree", yaml_tree, {})

-- Interactive join separator (global state)
vim.g.last_join_separator = " "

-- LineBreakAt — kept as VimScript (complex regex substitution)
vim.cmd([[
function! LineBreakAt(bang, ...) range
  let save_search = @/
  if empty(a:bang)
    let before = '' | let after = '\ze.' | let repl = '&\r'
  else
    let before = '.\zs' | let after = '' | let repl = '\r&'
  endif
  let pat_list = map(deepcopy(a:000), "escape(v:val, '/\\.*$^~[')")
  let find = empty(pat_list) ? @/ : join(pat_list, '\|')
  let find = before . '\%(' . find . '\)' . after
  execute a:firstline . ',' . a:lastline . 's/'. find . '/' . repl . '/ge'
  let @/ = save_search
endfunction
command! -bang -nargs=* -range LineBreakAt <line1>,<line2>call LineBreakAt('<bang>', <f-args>)
]])

-- ========================== PLUGINS (lazy.nvim) ==============================
require("lazy").setup({

  -- ···················· Dependencies ····················
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ···················· Search (fzf + ripgrep) ····························
  {
    "junegunn/fzf",
    build = function() vim.fn["fzf#install"]() end,
  },
  {
    "junegunn/fzf.vim",
    config = function()
      -- Rg with preview (matches original .vimrc command)
      vim.cmd([[
        command! -bang -nargs=* Rg
          \ call fzf#vim#grep(
          \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
          \   fzf#vim#with_preview(), <bang>0)
      ]])

      -- Buffer delete picker
      vim.cmd([[
        function! s:list_buffers()
          redir => list
          silent ls
          redir END
          return split(list, "\n")
        endfunction

        function! s:delete_buffers(lines)
          execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
        endfunction

        command! B call fzf#run(fzf#wrap({
          \ 'source': s:list_buffers(),
          \ 'sink*': { lines -> s:delete_buffers(lines) },
          \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
          \ }))
      ]])

      -- FZF MRU (recent files)
      vim.cmd([[
        command! FZFMru call fzf#run({
          \ 'source': v:oldfiles,
          \ 'sink':   'e',
          \ 'options': '-m -x +s',
          \ 'down':    '40%'})
      ]])
    end,
  },
  -- vim-ripgrep removed: fzf.vim's custom :Rg command already uses rg directly

  -- ···················· Navigation ····················
  { "christoomey/vim-tmux-navigator" },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = { enabled = false },
        char = { enabled = true },   -- replaces clever-f
      },
    },
    keys = {
      { "s", mode = { "n", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
  },

  -- ···················· File Explorer (replaces netrw) ····················
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        view_options = { show_hidden = true },
        keymaps = {
          ["l"] = "actions.select",
          ["h"] = "actions.parent",
          ["q"] = "actions.close",
        },
      })
    end,
  },

  -- ···················· Editing ····················
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },
  { "tpope/vim-repeat" },
  { "tpope/vim-abolish", event = "VeryLazy" },

  {
    "junegunn/vim-easy-align",
    event = "VeryLazy",
    config = function()
      vim.keymap.set({ "x", "n", "v" }, "ga", "<Plug>(EasyAlign)", { remap = true })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true, fast_wrap = {} })
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },

  -- ···················· Git ····················
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "tpope/vim-rhubarb", event = "VeryLazy" },    -- :GBrowse support

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = false,
    },
  },

  -- ···················· LSP (replaces CoC) ····················
  -- Mason installs language servers
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function() require("mason").setup() end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",      -- Go (was in coc-settings.json)
          "ts_ls",      -- TypeScript
          "pyright",    -- Python
          "eslint",     -- ESLint
          "lua_ls",     -- Lua (for editing this config)
          "ruby_lsp",  -- Ruby
        },
        automatic_installation = true,
      })
    end,
  },
  -- nvim-lspconfig provides server default configs on rtp
  { "neovim/nvim-lspconfig", lazy = true },
  -- cmp-nvim-lsp provides extended capabilities
  { "hrsh7th/cmp-nvim-lsp", lazy = true },

  -- ···················· Completion (replaces CoC completion) ················
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Autopairs integration
      local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- ···················· Formatting (replaces ALE fixers) ····················
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python            = { "ruff_fix", "ruff_format" },
          typescript        = { "prettier" },
          typescriptreact   = { "prettier" },
          javascript        = { "prettier" },
          javascriptreact   = { "prettier" },
          lua               = { "stylua" },
          go                = { "goimports", "gofmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- ···················· Linting (replaces ALE linting) ······················
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },

  -- ···················· Treesitter ····················
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      -- Install parsers on plugin install/update
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "python", "javascript", "typescript",
        "tsx", "ruby", "go", "html", "css", "json", "yaml", "markdown",
        "bash", "regex", "dockerfile",
      })
    end,
    config = function()
      -- nvim-treesitter v1.0 — setup() configures install_dir only
      require("nvim-treesitter").setup({})
      -- Neovim 0.11+ auto-enables treesitter highlighting for installed parsers
    end,
  },

  -- ···················· Theme ····················
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          gitsigns = true,
          mason = true,
          cmp = true,
          treesitter = true,
          flash = true,
          indent_blankline = { enabled = true },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors      = { "italic" },
              hints       = { "italic" },
              warnings    = { "italic" },
              information = { "italic" },
            },
          },
        },
        custom_highlights = function(colors)
          return {
            -- Match original .vimrc highlights
            Visual       = { style = { "bold" }, bg = colors.green, fg = colors.base },
            CursorLine   = { style = { "underline" }, bg = "NONE" },
            Comment      = { style = { "italic" }, fg = "#95989d" },    -- exact .vimrc color
            LineNr       = { fg = colors.overlay0, bg = "NONE" },
            SignColumn   = { bg = "NONE" },
            NormalFloat  = { bg = colors.base },

            -- Git sign colors (match old vim-signify highlights)
            GitSignsAdd          = { fg = colors.green },
            GitSignsChange       = { fg = colors.yellow },
            GitSignsDelete       = { fg = colors.red },
            DiffAdd              = { bg = "#415d41" },                  -- exact .vimrc color
            DiffChange           = { bg = "#685a22" },                  -- exact .vimrc color
            DiffDelete           = { bg = "#682b22" },                  -- exact .vimrc color

            -- Ruby (treesitter equivalents of old syntax links)
            ["@keyword.function.ruby"]  = { fg = colors.red, style = { "italic" } },
            ["@module.ruby"]            = { fg = colors.mauve },
            ["@string.ruby"]            = { fg = colors.green },
            ["@string.special.ruby"]    = { fg = colors.yellow },
            ["@variable.parameter.ruby"] = { fg = colors.blue },
          }
        end,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ···················· Statusline (replaces Lightline/Airline) ·············
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {},
          lualine_c = {
            { "filename", path = 0 },
            "diff",
            "diagnostics",
          },
          lualine_x = {},
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ···················· Indent guides ····················
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- ···················· Start screen (replaces vim-startify) ················
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local startify = require("alpha.themes.startify")
      startify.section.header.val = { "NEOVIM" }
      startify.section.top_buttons.val = {
        startify.button("e", "  New file",     ":ene <BAR> startinsert<CR>"),
        startify.button("f", "  Find file",    ":GFiles<CR>"),
        startify.button("r", "  Recent files", ":FZFMru<CR>"),
        startify.button("g", "  Grep text",    ":Rg<CR>"),
        startify.button("c", "  Config",       ":e $MYVIMRC<CR>"),
        startify.button("q", "  Quit",         ":qa<CR>"),
      }
      require("alpha").setup(startify.config)
    end,
  },

  -- ···················· Rainbow delimiters ····················
  { "HiPhish/rainbow-delimiters.nvim", event = { "BufReadPost", "BufNewFile" } },

  -- ···················· Utilities ····················
  { "airblade/vim-localorie", ft = { "yaml", "eruby" } },

}, {
  -- Lazy.nvim options
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- ========================== LSP (Neovim 0.11 native API) ====================
-- Global capabilities for all servers (from cmp-nvim-lsp)
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Server-specific config: Lua LS
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Enable all language servers
vim.lsp.enable({ "gopls", "ts_ls", "pyright", "eslint", "lua_ls", "ruby_lsp" })

-- LSP keymaps via LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local lmap = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc, silent = true })
    end
    lmap("gd", vim.lsp.buf.definition, "Go to definition")
    lmap("gy", vim.lsp.buf.type_definition, "Type definition")
    lmap("gi", vim.lsp.buf.implementation, "Implementation")
    lmap("gr", vim.lsp.buf.references, "References")
    lmap("gh", vim.lsp.buf.hover, "Hover docs")
    lmap("<leader>rn", vim.lsp.buf.rename, "Rename")
    lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
    lmap("<leader>D", vim.diagnostic.open_float, "Line diagnostics")
    lmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    lmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

-- Diagnostic display
vim.diagnostic.config({
  virtual_text = { spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- ========================== KEYMAPS =========================================
local map = vim.keymap.set

-- ---- Basic ----
map("n", ";", ":", { noremap = true })
map("n", "Q", "@@", { noremap = true })

-- ---- Movement ----
map("n", "J", "5j", { noremap = true })
map("n", "K", "5k", { noremap = true })
map("n", "H", "{", { noremap = true })
map("n", "L", "}", { noremap = true })
map("n", "vA", "ggVG", { noremap = true })

-- ---- Escape ----
map("i", "jj", "<ESC>", { noremap = true })

-- ---- Undo / Redo ----
map("n", "U", "<C-r>", { noremap = true })

-- ---- Black hole register for delete/change ----
for _, mode in ipairs({ "n", "v" }) do
  map(mode, "d",  '"_d',  { noremap = true })
  map(mode, "dd", '"_dd', { noremap = true })
  map(mode, "D",  '"_D',  { noremap = true })
  map(mode, "c",  '"_c',  { noremap = true })
  map(mode, "cc", '"_cc', { noremap = true })
  map(mode, "C",  '"_C',  { noremap = true })
end
map("n", "X", "yydd", { noremap = true })   -- cut line (yank + delete)
map("n", "Y", "^y$",  { noremap = true })   -- yank to EOL

-- ---- Paste from yank register ----
map("n", "<leader>r", 'viw"0p')

-- ---- Delete empty lines in visual ----
map("v", "de", ":g/^\\s*$/d<CR>:noh<CR>", { noremap = true, silent = true })

-- ---- Text objects: yank in / ----
for _, mode in ipairs({ "o", "x" }) do
  map(mode, "i/", ":<C-U>normal! T/vt/<CR>", { noremap = true, silent = true })
  map(mode, "a/", ":<C-U>normal! F/vf/<CR>", { noremap = true, silent = true })
end

-- ---- Paste mode ----
map("n", "<F2>", ":set paste!<CR>", { noremap = true })
map("i", "<F2>", "<C-O>:set paste!<CR>", { noremap = true })

-- ---- Word deletion in insert mode ----
map("i", "<C-w>",  "<C-\\><C-o>dB", { noremap = true })
map("i", "<C-BS>", "<C-\\><C-o>db", { noremap = true })

-- ========================== WINDOW MANAGEMENT ===============================
map("n", "vv", "<C-w>v", { noremap = true, silent = true })
map("n", "qq", ":close<CR>", { noremap = true })

-- Save / Quit
map("n", "<Leader>w", ":w<CR>")
map("n", "<Leader>q", ":q<CR>")
map("n", "<Leader>e", ":wq<CR>")
map("n", "<Leader>Q", ":qa!<CR>")

-- Buffers
map("n", "<Leader>b", ":Buffers<CR>")

-- Duplicate lines
map("n", "du", "Yp", { noremap = true })
map("v", "du", "yp", { noremap = true })

-- Buffer navigation with auto-save
map("n", "<leader><tab>", buf_nav("b#"),        { silent = true })
map("n", "<tab>",         buf_nav("bnext"),     { silent = true })
map("n", "<s-tab>",       buf_nav("bprevious"), { silent = true })

-- Switch pane
map("n", "<Leader><space>", "<C-w><C-p>", { noremap = true })
map("n", "<Leader>0",       "<C-w><C-p>", { noremap = true })

-- Window switching by number (1–9)
for i = 1, 9 do
  map("n", "<Leader>" .. i, ":" .. i .. "wincmd w<CR>", { silent = true })
end

-- Resize
map("n", "<Leader>>", "30<C-w>>", { noremap = true, silent = true })
map("n", "<Leader><", "30<C-w><", { noremap = true, silent = true })
map("n", "<Leader>=", "<C-w>=",   { noremap = true, silent = true })

-- Split with fzf buffers
map("n", "<leader>v", ":vsp | Buffers<CR>")
map("n", "<leader>o", ":only<CR>", { noremap = true })

-- Directional splits
map("n", "<Leader>ls", ":leftabove vsplit<CR>",  { silent = true })
map("n", "<Leader>ks", ":rightbelow split<CR>",  { silent = true })

for _, d in ipairs({
  { "hn", "leftabove vnew" },  { "ln", "rightbelow vnew" },
  { "kn", "leftabove new" },   { "jn", "rightbelow new" },
}) do
  map("n", "<Leader>" .. d[1], ":" .. d[2] .. "<CR>", { silent = true })
end

-- Directional splits + fzf buffers
for _, d in ipairs({
  { "hb", "leftabove vnew" },  { "lb", "rightbelow vnew" },
  { "kb", "leftabove new" },   { "jb", "rightbelow new" },
}) do
  map("n", "<Leader>" .. d[1], ":" .. d[2] .. "<CR>:Buffers<CR>", { silent = true })
end

-- Directional splits + Rg
for _, d in ipairs({
  { "HH", "leftabove vnew" },  { "LL", "rightbelow vnew" },
  { "KK", "leftabove new" },   { "JJ", "rightbelow new" },
}) do
  map("n", "<Leader>" .. d[1], ":" .. d[2] .. "<CR>:Rg!<CR>", { silent = true })
end

-- Directional splits + Files
for _, d in ipairs({
  { "H ", "leftabove vnew" },  { "L ", "rightbelow vnew" },
  { "K ", "leftabove new" },   { "J ", "rightbelow new" },
}) do
  map("n", "<Leader>" .. d[1], ":" .. d[2] .. "<CR>:Files!<CR>", { silent = true })
end

-- Jump or open new split (smart: jump if pane exists, else open new)
for _, cfg in ipairs({
  { "hh", "h", "leftabove vnew",  true },
  { "ll", "l", "rightbelow vnew", true },
  { "kk", "k", "leftabove vnew",  true },
  { "jj", "j", "rightbelow vnew", true },
}) do
  map("n", "<Leader>" .. cfg[1], function() jump_or_open(cfg[2], cfg[3], cfg[4]) end, { silent = true })
end

for _, cfg in ipairs({
  { "h<Space>", "h", "leftabove vsplit",  false },
  { "l<Space>", "l", "rightbelow vsplit", false },
  { "k<Space>", "k", "leftabove split",   false },
  { "j<Space>", "j", "rightbelow split",  false },
}) do
  map("n", "<Leader>" .. cfg[1], function() jump_or_open(cfg[2], cfg[3], cfg[4]) end, { silent = true })
end

-- ========================== SEARCH ==========================================
map("n", "ff", ":Rg<CR>")
map("n", "FF", ":Files<CR>", { silent = true })
map("n", "<leader>f", ":Rg <C-r>=expand('<cword>')<CR><CR>")
map("n", "<leader>F", "/<C-r>=expand('<cword>')<CR><CR>n")

-- Go to definition in vsplit (LSP)
map("n", "<leader>d", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end)

-- Quickfix navigation
map("n", "<C-n>", ":cn<CR>")
map("n", "<C-p>", ":cp<CR>")

-- File explorer (oil.nvim)
map("n", "<leader>t", function() require("oil").open() end)

-- Comment toggle (Comment.nvim)
map("n", "<leader>/", "gcc", { remap = true, silent = true })
map("v", "<leader>/", "gc",  { remap = true, silent = true })

-- ========================== FILE SHORTCUTS ==================================
map("n", "<Leader>yp", copy_file_path)
map("n", "<leader>%",  copy_file_path)

-- Python debugger
map("n", "<leader>p", "oimport pdb; pdb.set_trace()<Esc>")

-- ========================== JOINS / LINE BREAK ==============================
-- LineBreakAt
map("n", "S", ":LineBreakAt ",  { noremap = true })
map("v", "s", ":'<,'>LineBreakAt ", { noremap = true })

-- Interactive join
map({ "n", "x" }, "z", function()
  local sep = vim.fn.input("Separator: ", vim.g.last_join_separator)
  vim.cmd("redraw!")
  if sep == "" then return end
  vim.g.last_join_separator = sep

  local first = vim.fn.line("v") ~= 0 and vim.fn.line("'<") or vim.fn.line(".")
  local last  = vim.fn.line("v") ~= 0 and vim.fn.line("'>") or vim.fn.line(".")

  if first == 0 then first = vim.fn.line(".") end
  if last == 0 then last = first end

  local escaped_sep = sep:gsub("'", "''")
  local subst = "s/\\s*\\n\\+\\s*/\\='" .. escaped_sep .. "'/"
  if first < last then
    vim.cmd(first .. "," .. (last - 1) .. subst)
  else
    vim.cmd(subst)
  end
end, { silent = true })

-- Quickfix toggle
map("n", "<Leader>c", quickfix_toggle, { silent = true })

-- Git keymaps (fugitive)
map("n", "<leader>gd", ":Git diff<CR>",    { silent = true })
map("n", "<leader>gs", ":vertical Git<CR>", { silent = true })
map("n", "<leader>gb", ":Git blame<CR>",   { silent = true })
map("n", "<leader>gg", ":GBrowse<CR>",     { silent = true })

-- Localorie (YAML i18n)
map("n", "<leader>yyp", function()
  local ok, _ = pcall(function()
    local key = vim.fn["localorie#expand_key"]()
    vim.fn.setreg("+", key)
    print(key)
  end)
  if not ok then print("localorie not available") end
end)

-- Sudo write
vim.cmd("cnoremap w!! w !sudo tee % > /dev/null")

-- Fix Ctrl-C to trigger InsertLeave
map("i", "<C-c>", "<C-c><cmd>doautocmd InsertLeave<CR>", { noremap = true })

-- B command for buffer delete is defined in fzf.vim plugin config above

-- ========================== COMMAND ABBREVIATIONS ============================
vim.cmd([[
  cnoreabbrev rg    Rg
  cnoreabbrev files GFiles
  cnoreabbrev f     GFiles
  cnoreabbrev b     Buffers
  cnoreabbrev QQ    FZFMru
  cnoreabbrev Q     History
  cnoreabbrev ..    cd ..
  cnoreabbrev sv    source ~/.config/nvim/init.lua
  cnoreabbrev ve    vsplit ~/.config/nvim/init.lua
  cnoreabbrev ze    vsplit ~/.zshrc
  cnoreabbrev te    vsplit ~/.tc_settings
  cnoreabbrev save  mksession! ~/.local/state/nvim/session.vim
  cnoreabbrev load  source ~/.local/state/nvim/session.vim
]])

-- ========================== AUTOCOMMANDS ====================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Disable undo for sensitive files
augroup("NoUndoUlysses", { clear = true })
autocmd("BufWritePre", {
  group   = "NoUndoUlysses",
  pattern = "*boxer-*.yaml",
  callback = function() vim.opt_local.undofile = false end,
})

-- Relative number only in focused window
augroup("NumberToggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = "NumberToggle",
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = true end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = "NumberToggle",
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = false end
  end,
})

-- Auto-save when leaving window
autocmd({ "FocusLost", "WinLeave" }, {
  callback = function()
    if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly
       and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Check for external changes
autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then vim.cmd("checktime") end
  end,
})

-- Tmux window rename (uses table form to avoid shell injection on special filenames)
autocmd("BufEnter", {
  callback = function()
    if vim.env.TMUX then
      vim.fn.system({ "tmux", "rename-window", vim.fn.expand("%:t") })
    end
  end,
})
autocmd("VimLeave", {
  callback = function()
    if vim.env.TMUX then
      vim.fn.system({ "tmux", "setw", "automatic-rename" })
    end
  end,
})

-- Large file optimization (>1MB: disable syntax, treesitter, swap, undo)
augroup("LargeFile", { clear = true })
autocmd("BufReadPre", {
  group = "LargeFile",
  callback = function()
    if vim.fn.getfsize(vim.fn.expand("%")) > 1000000 then
      vim.cmd("syntax off")
      vim.opt_local.swapfile = false
      vim.opt_local.undolevels = -1
      vim.opt_local.foldmethod = "manual"
      -- Stop treesitter for this buffer after it loads
      vim.api.nvim_create_autocmd("BufReadPost", {
        buffer = 0,
        once = true,
        callback = function() pcall(vim.treesitter.stop) end,
      })
    end
  end,
})

-- ========================== NETRW FALLBACK ==================================
-- These apply if oil.nvim fails to load for any reason
vim.g.netrw_preview      = 1
vim.g.netrw_liststyle    = 3
vim.g.netrw_banner       = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize      = 25
vim.g.netrw_keepdir      = 1

-- ============================================================================
-- vim: set foldmethod=marker foldlevel=0:
