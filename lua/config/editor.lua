-- Colour scheme
vim.cmd.colorscheme("gruvbox-material")

-- Font
-- Common choices:
--   SF Mono:h11 (SFMono Nerd Font)
--   JetBrainsMono NFM:h11
--   Cascadia Code NF:h11
vim.o.guifont = "MonacoLigaturized Nerd Font:h11"

-- Tab is 4 spaces, indenting is one tab
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smarttab = true

-- Display line numbers
vim.o.number = true

-- Enable mouse support, including extra mouse buttons in supporting terminals/GUIs
vim.o.mouse = "a"

-- Code folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "1"

-- Display invisible characters
vim.o.list = true
vim.o.listchars = "tab:>-,lead:-,trail:•"

-- Colour column
vim.o.colorcolumn = "140"

-- Case-insensitive search, unless the search contains an uppercase letter
vim.o.ignorecase = true
vim.o.smartcase = true

-- Persistent undo - undo history survives closing and reopening a file
vim.o.undofile = true

-- Avoid swapfile checks/writes on every opened buffer. Persistent undo remains
-- enabled above, so normal edit history still survives restarts.
vim.o.swapfile = false

-- Highlight the line the cursor is on
vim.o.cursorline = true

-- Always show the sign column so text doesn't shift when signs appear
vim.o.signcolumn = "yes"

-- Open new splits to the right and below (more intuitive)
vim.o.splitright = true
vim.o.splitbelow = true

-- Faster response for things like diagnostics and which-key (default is 4000)
vim.o.updatetime = 250

-- Prompt to save instead of erroring when quitting with unsaved changes
vim.o.confirm = true

-- Keep GUI clients like Neovide silent: no audible bell and no visual flash.
vim.o.belloff = "all"
vim.o.errorbells = false
vim.o.visualbell = false

-- Rounded borders on floating windows (LSP hover, diagnostics float, etc.)
vim.o.winborder = "rounded"
