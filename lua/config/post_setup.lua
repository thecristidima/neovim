vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.cmd("lua vim.lsp.buf.format()")
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local nmap = function(keys, func, desc)
			if desc then
				desc = "LSP: " .. desc
			end
			vim.keymap.set("n", keys, func, { buffer = buff, desc = desc })
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
	end,
})
