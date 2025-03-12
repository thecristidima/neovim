vim.g.gruvbox_material_background = "hard"

return {
    "sainnhe/gruvbox-material",
    config = function()
        vim.cmd([[colorscheme gruvbox-material]])
    end
}
