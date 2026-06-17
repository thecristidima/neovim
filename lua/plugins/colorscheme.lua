return {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000, -- load before other UI plugins
    init = function()
        vim.o.background = "dark"
        vim.g.gruvbox_material_background = "medium"
        vim.g.gruvbox_material_foreground = "material"
    end,
}
