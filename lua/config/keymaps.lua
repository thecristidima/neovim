local map = vim.keymap.set

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Ctrl+left/right
map({ "n", "v", "o" }, "<C-Left>", "b", { silent = true })
map({ "n", "v", "o" }, "<C-Right", "w", { silent = true })

-- Resize window using ctrl+meta+arrow keys
map("n", "<C-M-Down>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-M-Up>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-M-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-M-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move lines
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Ctrl+Backspace to delete word backwards
map("i", "<C-BS>", "<C-w>", { desc = "Delete Word Backwards" })
map("i", "<C-h>", "<C-w>", { desc = "Delete Word Backwards" })

-- Ctrl+Delete to delete word forwards
map("i", "<C-Del>", "<space><esc>ce", { desc = "Delete Word Forward" })

-- Ctrl+X to cut current line
map("i", "<C-x>", "<C-o>dd", { desc = "Cut current line" })

-- Ctrl+C to copy selection
map({ "n", "i" }, "<C-c>", "yy", { desc = "Copy line" })
map("v", "<C-c>", "y", { desc = "Copy selection" })

-- Ctrl+V to paste
-- Paste will place cursor before last character; the l moves it one place to the right to behave as expected
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map("n", "<C-v>", "pl", { desc = "Paste" })
map("v", "<C-v>", '"_dP`]l', { desc = "Paste over selected text" }) -- This one is fucking nuts

-- Undo in insert mode
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Ctrl+S to save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Ctrl+Alt+S to save without formatting (see post_setup.lua)
map({ "i", "x", "n", "s" }, "<C-M-s>", "<cmd>WriteNoFormat<cr><esc>", { desc = "Save without formatting" })

-- better indenting
map("v", "<S-Tab>", "<gv")
map("v", "<Tab>", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- neo-tree
map("n", "<leader>fe", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" })

-- fzf-lua (search files)
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>fs", "<cmd>FzfLua live_grep<cr>", { desc = "Search in all files" })
