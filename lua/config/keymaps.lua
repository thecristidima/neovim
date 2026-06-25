local map = vim.keymap.set

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Ctrl+left/right
map({ "n", "v", "o" }, "<C-Left>", "b", { silent = true })
map({ "n", "v", "o" }, "<C-Right>", "w", { silent = true })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight", silent = true })

-- Mouse back/forward buttons navigate the jumplist
map("n", "<X1Mouse>", "<C-o>", { desc = "Jump back" })
map("n", "<X2Mouse>", "<C-i>", { desc = "Jump forward" })

-- Resize window using ctrl+meta+arrow keys
map("n", "<C-M-Down>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-M-Up>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-M-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-M-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

if vim.g.neovide then
    local function change_scale(delta)
        local scale = vim.g.neovide_scale_factor or 1
        vim.g.neovide_scale_factor = math.max(0.5, math.min(2, scale + delta))
    end

    map({ "n", "i", "x" }, "<C-=>", function() change_scale(0.1) end, { desc = "Zoom In" })
    map({ "n", "i", "x" }, "<C-+>", function() change_scale(0.1) end, { desc = "Zoom In" })
    map({ "n", "i", "x" }, "<C-->", function() change_scale(-0.1) end, { desc = "Zoom Out" })
    map({ "n", "i", "x" }, "<C-0>", function() vim.g.neovide_scale_factor = 1 end, { desc = "Reset Zoom" })
end

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

local function ctrl_p_file_finder(opts, ctx)
    local filter = ctx.filter:clone()
    local search = vim.trim(filter.search or "")
    local has_glob = search:find("*", 1, true)
        or search:find("?", 1, true)
        or search:find("[", 1, true)
        or search:find("]", 1, true)
        or search:find("{", 1, true)
        or search:find("}", 1, true)
    local has_path = search:find("/", 1, true) or search:find("\\", 1, true)
    local has_extra_args = search:find("%s%-%-%s")

    if search ~= "" and not has_glob and not has_path and not has_extra_args then
        filter.search = "*" .. search .. "*"
    end

    local file_ctx = ctx:clone(opts)
    file_ctx.filter = filter
    return require("snacks.picker.source.files").files(opts, file_ctx)
end

local function search_visual_selection()
    local mode = vim.fn.mode()
    local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
    local text = table.concat(lines, "\n")

    if text == "" then
        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
        return
    end

    local pattern = "\\V" .. vim.fn.escape(text, "\\"):gsub("\n", "\\n")
    vim.fn.setreg("/", pattern)
    vim.o.hlsearch = true
    vim.api.nvim_feedkeys(vim.keycode("<Esc>n"), "n", false)
end

-- Ctrl+P quick open: files plus workspace symbols
map({ "n", "i", "x" }, "<C-p>", function()
    Snacks.picker({
        title = "Search files and symbols",
        live = true,
        supports_live = true,
        workspace = true,
        multi = {
            {
                source = "files",
                cmd = "rg",
                finder = ctrl_p_file_finder,
            },
            "lsp_workspace_symbols",
        },
        filter = {
            transform = function(_, filter)
                filter.pattern = Snacks.picker.util.parse(filter.search)
            end,
        },
        formatters = {
            file = {
                filename_first = true,
                min_width = 50,
            },
        },
        layout = {
            preset = "vscode",
            layout = {
                width = 0.8,
                min_width = 100,
                height = 0.55,
            },
        },
        matcher = {
            cwd_bonus = true,
            frecency = true,
        },
    })
end, { desc = "Search files and symbols" })
map("n", "<C-f>", "/", { desc = "Search current file" })
map("i", "<C-f>", "<Esc>/", { desc = "Search current file" })
map("x", "<C-f>", search_visual_selection, { desc = "Search selection" })
map({ "n", "i", "x" }, "<C-S-F>", "<cmd>FzfLua live_grep<cr>", { desc = "Find in files" })
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>fs", "<cmd>FzfLua live_grep<cr>", { desc = "Search in all files" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find buffers" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Find keymaps" })

local favorite_paths = {
    { name = "Studio", path = "C:/git/Studio" },
    { name = "Robot", path = "C:/git/Studio/Robot" },
    { name = "Integration Tests", path = "C:/git/Studio/Robot/IntegrationTests" },
}

map("n", "<leader>fp", function()
    vim.ui.select(favorite_paths, {
        prompt = "Change directory",
        format_item = function(item)
            return item.name .. " - " .. item.path
        end,
    }, function(item)
        if item then
            vim.cmd.cd(vim.fn.fnameescape(item.path))
        end
    end)
end, { desc = "Favorite paths" })

-- buffer commands
-- <leader>bb opens the buffer list (snacks picker); press Ctrl-x or dd to close the highlighted buffer
map("n", "<leader>bb", function() Snacks.picker.buffers() end, { desc = "List buffers" })
-- close the current buffer without disturbing the window layout (snacks)
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })

-- show the full diagnostic message for the current line in a floating window
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- project-wide diagnostics list (snacks picker)
map("n", "<leader>cx", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics (project)" })

-- Visual Studio Ctrl+Shift+F equivalent: find in files
map("n", "<leader>cfs", "<cmd>FzfLua live_grep<cr>", { desc = "Find in files" })

-- LSP symbol/call pickers
map("n", "<leader>csd", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>csw", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "Workspace symbols" })
map("n", "<leader>csi", "<cmd>FzfLua lsp_incoming_calls<cr>", { desc = "Incoming calls" })
map("n", "<leader>cso", "<cmd>FzfLua lsp_outgoing_calls<cr>", { desc = "Outgoing calls" })

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
