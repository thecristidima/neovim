vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(ev)
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
            if client:supports_method("textDocument/formatting", ev.buf) then
                vim.lsp.buf.format({
                    bufnr = ev.buf,
                    id = client.id,
                    formatting_options = {
                        insertFinalNewline = true,
                        trimFinalNewlines = false,
                    },
                })
                return
            end
        end
    end,
})

vim.api.nvim_create_user_command("WriteNoFormat", function()
    vim.cmd("noautocmd write")
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
        end

        nmap("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
        nmap("<leader>ca", function()
            vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
        end, "Code Action")
        nmap("<leader>cf", vim.lsp.buf.format, "Format Code")
        nmap("<leader>cgd", vim.lsp.buf.definition, "Go to Definition")
        nmap("<leader>cgi", vim.lsp.buf.implementation, "Go to Implementation")
        nmap("<leader>cgr", vim.lsp.buf.references, "Go to References")
        nmap("<leader>cD", vim.lsp.buf.document_symbol, "Show symbol documentation")
        nmap("<S-F12>", vim.lsp.buf.references, "Find All References")
        nmap("<C-F12>", vim.lsp.buf.implementation, "Go to Implementation")

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.name == "roslyn" then
            nmap("<leader>cRt", "<cmd>Roslyn target<cr>", "Roslyn: Select Solution")
            nmap("<leader>cRr", function()
                vim.cmd.lsp("restart", "roslyn")
            end, "Roslyn: Restart")
            nmap("<leader>cRs", function()
                local solution = vim.g.roslyn_nvim_selected_solution

                if solution then
                    vim.notify(vim.fn.fnamemodify(solution, ":."), vim.log.levels.INFO, { title = "Roslyn solution" })
                else
                    vim.notify("No Roslyn solution selected", vim.log.levels.WARN, { title = "Roslyn solution" })
                end
            end, "Roslyn: Show Solution")
        end

        -- Show diagnostics as inline text to the right of the line, but not as
        -- E/W/I/H letters in the sign column (keeps the gutter clean for git signs)
        vim.diagnostic.config({ virtual_text = true, signs = false })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticSignError" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticSignWarn" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticSignInfo" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticSignHint" })
    end,
})

vim.cmd([[
    anoremenu PopUp.Go\ to\ implementation <Cmd>lua vim.lsp.buf.implementation()<CR>
    amenu disable PopUp.Go\ to\ implementation
]])

vim.api.nvim_create_autocmd("MenuPopup", {
    group = vim.api.nvim_create_augroup("user.popupmenu", { clear = true }),
    callback = function()
        local implementation_method = "textDocument/implementation"
        local supports_implementation = false

        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client:supports_method(implementation_method, 0) then
                supports_implementation = true
                break
            end
        end

        if supports_implementation then
            vim.cmd([[anoremenu enable PopUp.Go\ to\ implementation]])
        else
            vim.cmd([[amenu disable PopUp.Go\ to\ implementation]])
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = vim.api.nvim_create_augroup("user.quickfix", { clear = true }),
    callback = function(ev)
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true, desc = "Close quickfix" })
        vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = ev.buf, silent = true, desc = "Close quickfix" })
    end,
})

-- Briefly highlight yanked text so you can see what got copied
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Reload files that changed on disk (e.g. after a git checkout in lazygit).
-- autoread is on by default; the checktime triggers the actual re-read.
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    command = "checktime",
})

-- Command to toggle inline diagnostics
vim.api.nvim_create_user_command("ToggleInlineDiagnostic", function()
    local new_virtual_text = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = new_virtual_text })
end, {})

-- Command to open lazygit in a floating popup (same as <leader>G)
vim.api.nvim_create_user_command("LazyGit", function()
    Snacks.lazygit()
end, {})

-- Command to toggle spellchecker
-- This already exists in neovim, just writing it here because I'll forget it
-- :set spell!


-- Another one I keep forgetting
-- After searching, you can clear the highlights with Esc

-- Automatically enable spell checking
-- Hover over a squigly line and press z= to see fix suggestions
vim.opt.spell = true
vim.opt.spelllang = "en_gb"

-- Use system clipboard
-- TODO Should this be in editor.lua?
vim.opt.clipboard = "unnamedplus"

-- On Windows use PowerShell Core (pwsh) as the shell, falling back to
-- Windows PowerShell if pwsh isn't installed.
-- Recipe taken from `:help shell-powershell` - the extra shell* options are
-- required so that :terminal, :!cmd, redirection and exit codes work correctly.
if IS_WINDOWS then
    vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
    vim.o.shellcmdflag =
        [[-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$PSDefaultParameterValues['Out-File:Encoding']='utf8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;]]
    vim.o.shellredir = [[2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode]]
    vim.o.shellpipe = [[2>&1 | %{ "$_" } | tee %s; exit $LastExitCode]]
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end
