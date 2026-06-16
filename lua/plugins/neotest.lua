return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",           -- already present (neo-tree dep)
        "nvim-treesitter/nvim-treesitter", -- already present
        "nsidorenco/neotest-vstest",
        -- "antoinemadec/FixCursorHold.nvim", -- only needed on Neovim < 0.10; we're on 0.12
    },
    -- Lazy-load on first test keypress (keys below are C#-buffer-local)
    keys = {
        { "<leader>ctt", function() require("neotest").run.run() end,                    ft = "cs", desc = "Run nearest test" },
        { "<leader>ctA", function() require("neotest").run.run(vim.fn.expand("%")) end,   ft = "cs", desc = "Run all tests in file/class" },
        { "<leader>ctP", function()
            local project = vim.fs.find(function(name)
                return name:match("%.csproj$")
            end, { upward = true, type = "file", path = vim.fn.expand("%:p:h") })[1]

            if project then
                require("neotest").run.run(vim.fs.dirname(project))
            else
                vim.notify("No C# project found for current buffer", vim.log.levels.WARN)
            end
        end, ft = "cs", desc = "Run current test project" },
        { "<leader>ctS", function() require("neotest").run.run({ suite = true }) end,      ft = "cs", desc = "Run test suite" },
        { "<leader>cts", function() require("neotest").summary.toggle() end,             ft = "cs", desc = "Toggle test summary" },
        { "<leader>cto", function() require("neotest").output.open({ enter = true }) end, ft = "cs", desc = "Show test output" },
        { "<leader>ctO", function() require("neotest").output_panel.toggle() end,         ft = "cs", desc = "Toggle output panel" },
        { "<leader>ctx", function() require("neotest").run.stop() end,                    ft = "cs", desc = "Stop test run" },
    },
    config = function()
        local subprocess = require("neotest.lib.subprocess")
        local add_paths_to_rtp = subprocess.add_paths_to_rtp

        subprocess.add_paths_to_rtp = function(paths)
            local resolved_paths = {}

            for _, path in ipairs(paths) do
                if type(path) == "function" then
                    path = subprocess.resolve_plugin_root(path)
                end

                if type(path) == "string" then
                    table.insert(resolved_paths, path)
                end
            end

            return add_paths_to_rtp(resolved_paths)
        end

        vim.g.neotest_vstest = {
            broad_recursive_discovery = false,
            solution_selector = function(solutions)
                if vim.g.roslyn_nvim_selected_solution then
                    return vim.g.roslyn_nvim_selected_solution
                end

                if #solutions == 1 then
                    return solutions[1]
                end
            end,
        }

        require("neotest").setup({
            discovery = {
                concurrent = 1,
            },
            adapters = {
                require("neotest-vstest"),
            },
        })
    end,
}
