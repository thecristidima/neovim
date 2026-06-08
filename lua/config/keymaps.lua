local map = vim.keymap.set

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Ctrl+left/right
map({ "n", "v", "o" }, "<C-Left>", "b", { silent = true })
map({ "n", "v", "o" }, "<C-Right>", "w", { silent = true })

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

-- Ctrl+Delete to delete word forwards (without copying)
map("i", "<C-Del>", '<C-o>"_de', { desc = "Delete Word Forward" })

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
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find buffers" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Find keymaps" })

-- buffer commands
-- <leader>bb opens the buffer list (snacks picker); press Ctrl-x or dd to close the highlighted buffer
map("n", "<leader>bb", function() Snacks.picker.buffers() end, { desc = "List buffers" })
-- close the current buffer without disturbing the window layout (snacks)
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })

-- show the full diagnostic message for the current line in a floating window
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- project-wide diagnostics list (snacks picker)
map("n", "<leader>cx", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics (project)" })

-- toggle comment on the current line (normal) or selection (visual)
-- wraps the built-in gcc / gc so it's discoverable under <leader>c
map("n", "<leader>cc", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<leader>cc", "gc", { remap = true, desc = "Toggle comment" })

-- jump between uses of the symbol under the cursor (snacks words)
map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next reference" })
map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev reference" })

-- view noice messages (full command output / errors that scrolled past)
map("n", "<leader>Nn", "<cmd>Noice pick<cr>", { desc = "Message history" })
map("n", "<leader>Nl", "<cmd>Noice last<cr>", { desc = "Last message" })

-- floating terminal (snacks)
map("n", "<leader>t", function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })

-- lazygit in a floating popup (snacks)
map("n", "<leader>G", function() Snacks.lazygit() end, { desc = "Open lazy git" })
