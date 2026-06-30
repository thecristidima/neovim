local function normalize_path(path)
    return path and path:gsub("\\", "/"):gsub("/+$", "")
end

local function neotest_path(path)
    if not path then
        return path
    end

    if package.config:sub(1, 1) == "\\" then
        path = path:gsub("/", "\\")
    end

    return path:gsub("[/\\]+$", "")
end

local function target_framework(node)
    return node.targetFramework and node.targetFramework ~= "" and node.targetFramework or nil
end

local function framework_group_id(file_path, framework)
    return ("%s::target-framework:%s"):format(file_path, framework)
end

local function refresh_current_file(callback)
    local neotest = require("neotest")
    local easy_dotnet = neotest.easy_dotnet

    if easy_dotnet and easy_dotnet.refresh_file then
        easy_dotnet.refresh_file(vim.fn.expand("%:p"), callback)
    elseif callback then
        callback()
    end
end

local function distance_to_range(row, range)
    if not range then
        return math.huge
    end

    if row < range[1] then
        return range[1] - row
    end

    if row <= range[3] then
        return 0
    end

    return row - range[3]
end

local function range_size(range)
    if not range then
        return math.huge
    end

    return range[3] - range[1] + 1
end

local function position_matches_file(position, file_path)
    local normalized_file_path = normalize_path(file_path)

    return normalize_path(position.path) == normalized_file_path or normalize_path(position.id) == normalized_file_path
end

local function node_has_tests(node)
    for _, descendant in node:iter_nodes() do
        if descendant:data().type == "test" then
            return true
        end
    end

    return false
end

local function find_file_node(file_path)
    local best = nil

    for _, adapter_id in ipairs(require("neotest").state.adapter_ids()) do
        local positions = require("neotest").state.positions(adapter_id)

        if positions then
            for _, node in positions:iter_nodes() do
                local position = node:data()

                if position.type == "file" and position_matches_file(position, file_path) then
                    local candidate = {
                        adapter = adapter_id,
                        id = position.id,
                        node = node,
                    }

                    if node_has_tests(node) then
                        return candidate
                    end

                    best = best or candidate
                end
            end
        end
    end

    return best
end

local function find_nearest_test(file_path, row)
    local best = nil
    local best_distance = math.huge
    local best_size = math.huge

    for _, adapter_id in ipairs(require("neotest").state.adapter_ids()) do
        local positions = require("neotest").state.positions(adapter_id)

        if positions then
            for _, position in positions:iter() do
                local range = position.total_range or position.range
                local distance = distance_to_range(row, range)
                local size = range_size(range)

                if
                    position.type == "test"
                    and position_matches_file(position, file_path)
                    and range
                    and (distance < best_distance or (distance == best_distance and size < best_size))
                then
                    best = {
                        adapter = adapter_id,
                        id = position.id,
                    }
                    best_distance = distance
                    best_size = size
                end
            end
        end
    end

    return best
end

local function run_nearest_test()
    local file_path = vim.fn.expand("%:p")
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1

    refresh_current_file(function()
        local test = find_nearest_test(file_path, row)

        if test then
            require("neotest").run.run({ test.id, adapter = test.adapter })
        else
            require("neotest").run.run(file_path)
        end
    end)
end

local function run_current_file()
    local file_path = vim.fn.expand("%:p")

    refresh_current_file(function()
        local file = find_file_node(file_path)

        if not file then
            require("neotest").run.run(file_path)
            return
        end

        local children = file.node:children()

        if #children == 0 then
            require("neotest").run.run({ file.id, adapter = file.adapter })
            return
        end

        for _, child in ipairs(children) do
            local child_position = child:data()

            require("neotest").run.run({ child_position.id, adapter = file.adapter })
        end
    end)
end

local function open_nearest_output()
    local file_path = vim.fn.expand("%:p")
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1

    refresh_current_file(function()
        local test = find_nearest_test(file_path, row)

        if test then
            require("neotest").output.open({ position_id = test.id, adapter = test.adapter, enter = true })
        else
            require("neotest").output.open({ enter = true })
        end
    end)
end

return {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "GustavEikaas/easy-dotnet.nvim",
    },
    keys = {
        { "<leader>ctt", run_nearest_test, ft = "cs", desc = "Run nearest test" },
        { "<leader>ctA", run_current_file, ft = "cs", desc = "Run all tests in file/class" },
        {
            "<leader>ctP",
            function()
                local project = vim.fs.find(function(name)
                    return name:match("%.csproj$")
                end, { upward = true, type = "file", path = vim.fn.expand("%:p:h") })[1]

                if project then
                    require("neotest").run.run(vim.fs.dirname(project))
                else
                    vim.notify("No C# project found for current buffer", vim.log.levels.WARN)
                end
            end,
            ft = "cs",
            desc = "Run current test project",
        },
        { "<leader>ctS", function() require("neotest").run.run({ suite = true }) end, ft = "cs", desc = "Run test suite" },
        { "<leader>cts", function() require("neotest").summary.toggle() end, ft = "cs", desc = "Toggle test summary" },
        { "<leader>cto", open_nearest_output, ft = "cs", desc = "Show test output" },
        { "<leader>ctO", function() require("neotest").output_panel.toggle() end, ft = "cs", desc = "Toggle output panel" },
        { "<leader>ctx", function() require("neotest").run.stop() end, ft = "cs", desc = "Stop test run" },
    },
    config = function()
        local easy_dotnet_adapter = require("easy-dotnet.neotest")

        local root = easy_dotnet_adapter.root
        easy_dotnet_adapter.root = function(dir)
            return neotest_path(root(dir))
        end

        local is_test_file = easy_dotnet_adapter.is_test_file
        easy_dotnet_adapter.is_test_file = function(file_path)
            return is_test_file(normalize_path(file_path))
        end

        local function same_path(left, right)
            return normalize_path(vim.fn.resolve(left)) == normalize_path(vim.fn.resolve(right))
        end

        local function neotest_type(node)
            local type_name = node.type and node.type.type

            if type_name == "TestMethod" then
                return "test"
            end

            if type_name == "TestClass" or type_name == "TestNamespace" then
                return "namespace"
            end
        end

        local function position_range(node)
            local start_line = node.signatureLine or node.bodyStartLine or 0
            local end_line = node.endLine or start_line

            return { start_line, 0, end_line, 0 }
        end

        easy_dotnet_adapter.discover_positions = function(file_path)
            local neotest_file_path = neotest_path(file_path)
            local comparable_file_path = normalize_path(file_path)

            if not is_test_file(comparable_file_path) then
                return nil
            end

            local state = require("easy-dotnet.test-runner.state")
            local nodes = {}
            local included = {}
            local source_nodes = {}
            local source_node_ids = {}
            local frameworks = {}
            local framework_count = 0

            for _, node in pairs(state.nodes) do
                local type_name = neotest_type(node)

                if type_name and node.filePath and same_path(node.filePath, comparable_file_path) then
                    table.insert(source_nodes, { node = node, type_name = type_name })
                    source_node_ids[node.id] = true

                    local framework = target_framework(node)

                    if framework and not frameworks[framework] then
                        frameworks[framework] = true
                        framework_count = framework_count + 1
                    end
                end
            end

            local group_by_framework = framework_count > 1

            for _, source in ipairs(source_nodes) do
                local node = source.node
                local framework = target_framework(node)
                local parent_id = node.parentId

                if group_by_framework and framework and not source_node_ids[parent_id] then
                    parent_id = framework_group_id(neotest_file_path, framework)

                    if not nodes[parent_id] then
                        nodes[parent_id] = {
                            id = parent_id,
                            name = framework,
                            type = "namespace",
                            path = neotest_file_path,
                            parentId = nil,
                            range = { 0, 0, 0, 0 },
                        }
                        included[parent_id] = true
                    end
                end

                nodes[node.id] = {
                    id = node.id,
                    name = node.displayName,
                    type = source.type_name,
                    path = neotest_file_path,
                    parentId = parent_id,
                    range = position_range(node),
                }
                included[node.id] = true
            end

            if vim.tbl_isempty(nodes) then
                return nil
            end

            local roots = {}
            local children_by_parent = {}

            for id, node in pairs(nodes) do
                if node.parentId and included[node.parentId] then
                    children_by_parent[node.parentId] = children_by_parent[node.parentId] or {}
                    table.insert(children_by_parent[node.parentId], id)
                else
                    table.insert(roots, id)
                end
            end

            local function sort_by_line(left, right)
                local left_node = nodes[left]
                local right_node = nodes[right]
                local left_line = left_node.range[1]
                local right_line = right_node.range[1]

                if left_line == right_line then
                    return left_node.name < right_node.name
                end

                return left_line < right_line
            end

            table.sort(roots, sort_by_line)

            local function build_list(id)
                local node = nodes[id]
                local children = children_by_parent[id] or {}
                local position = {
                    id = node.id,
                    name = node.name,
                    type = node.type,
                    path = node.path,
                    range = node.range,
                }
                local list = { position }

                table.sort(children, sort_by_line)

                for _, child_id in ipairs(children) do
                    table.insert(list, build_list(child_id))
                end

                return list
            end

            local file_root = {
                {
                    id = neotest_file_path,
                    name = vim.fn.fnamemodify(neotest_file_path, ":t"),
                    type = "file",
                    path = neotest_file_path,
                    range = { 0, 0, 0, 0 },
                },
            }

            for _, id in ipairs(roots) do
                table.insert(file_root, build_list(id))
            end

            return require("neotest.types").Tree.from_list(file_root, function(position)
                return position.id
            end)
        end

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

        require("neotest").setup({
            discovery = {
                concurrent = 1,
            },
            summary = {
                mappings = {
                    output = { "o", "<leader>cto" },
                },
            },
            consumers = {
                easy_dotnet = function(client)
                    local pending_refresh = {}
                    local refresh_timer = nil

                    local function refresh_file(file_path, callback)
                        file_path = neotest_path(file_path)

                        if not file_path or file_path == "" then
                            if callback then
                                callback()
                            end
                            return
                        end

                        require("nio").run(function()
                            local ok, adapter_id = pcall(function()
                                return client:get_adapter(file_path)
                            end)

                            if ok and adapter_id then
                                client:_update_positions(file_path, { adapter = adapter_id })
                            end

                            if callback then
                                vim.schedule(callback)
                            end
                        end)
                    end

                    local function schedule_refresh(file_path)
                        file_path = neotest_path(file_path)

                        if not file_path or file_path == "" then
                            return
                        end

                        pending_refresh[file_path] = true
                        refresh_timer = refresh_timer or (vim.uv or vim.loop).new_timer()

                        refresh_timer:stop()
                        refresh_timer:start(100, 0, vim.schedule_wrap(function()
                            local files = vim.tbl_keys(pending_refresh)
                            pending_refresh = {}

                            for _, path in ipairs(files) do
                                refresh_file(path)
                            end
                        end))
                    end

                    require("easy-dotnet.neotest.events").subscribe("registerTest", function(test)
                        schedule_refresh(test and test.filePath)
                    end)

                    return {
                        refresh_file = refresh_file,
                    }
                end,
            },
            adapters = {
                easy_dotnet_adapter,
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "neotest-output",
            callback = function(event)
                local function close_window()
                    pcall(vim.api.nvim_win_close, vim.api.nvim_get_current_win(), true)
                end

                vim.keymap.set({ "n", "t" }, "q", close_window, { buffer = event.buf, silent = true })
                vim.keymap.set({ "n", "t" }, "<Esc>", close_window, { buffer = event.buf, silent = true })
                vim.keymap.set({ "n", "t" }, "<C-c>", close_window, { buffer = event.buf, silent = true })
            end,
        })
    end,
}
