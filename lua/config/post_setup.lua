vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.cmd("lua vim.lsp.buf.format()")
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

        -- Show diagnostics as inline text to the right of the line, but not as
        -- E/W/I/H letters in the sign column (keeps the gutter clean for git signs)
        vim.diagnostic.config({ virtual_text = true, signs = false })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticSignError" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticSignWarn" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticSignInfo" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticSignHint" })
    end,
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
-- After searching, you can clear the highlights with :noh

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
