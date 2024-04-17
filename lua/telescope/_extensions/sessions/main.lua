local has_telescope, _ = pcall(require, 'telescope')

if not has_telescope then
    error('This plugins requires nvim-telescope/telescope.nvim')
end

local M = {}

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local sessions_dir = vim.fn.stdpath('data') ..'/session/'

local load_session = function(prompt_bufnr)
    local dir = actions_state.get_selected_entry(prompt_bufnr).value
    actions.close(prompt_bufnr, true)
    -- Wipe all buffers before loading a session
    local i = 1
    local n = vim.api.nvim_call_function('bufnr', {'$'})
    while i < n do
        if vim.api.nvim_buf_is_valid(i) then
            vim.api.nvim_command('bw ' .. i)
        end
        i = i + 1
    end
    vim.api.nvim_command('silent source ' .. dir)
end

local new_session = function(prompt_bufnr)
    actions.close(prompt_bufnr, true)
    local picked_name = vim.fn.input('New Session Name: ')
    if picked_name == '' then
        return
    end
    local session_file = sessions_dir..'/'..picked_name
    local tree_open = require'nvim-tree.view'.is_visible()
    vim.fn.execute("NvimTreeClose") -- Ensure NvimTree is closed
    vim.fn.execute("mksession! "..session_file)
    if tree_open then
        vim.fn.execute("NvimTreeOpen") -- Reopen NvimTree if it was open
    end
    vim.api.nvim_echo({{'Created: '..session_file,}}, true, {})
end

local save_current = function(prompt_bufnr)
    actions.close(prompt_bufnr, true)
    local current_sdir = vim.api.nvim_eval('v:this_session')
    if current_sdir == '' then
        return
    end
    local tree_open = require'nvim-tree.view'.is_visible()
    vim.fn.execute("NvimTreeClose") -- Ensure NvimTree is closed
    vim.fn.execute("mksession! "..current_sdir)
    if tree_open then
        vim.fn.execute("NvimTreeOpen") -- Reopen NvimTree if it was open
    end
    vim.api.nvim_echo({{'Updated: '..current_sdir,}}, true, {})
end

local del_session = function(prompt_bufnr)
    local dir = actions_state.get_selected_entry(prompt_bufnr).value
    actions.close(prompt_bufnr, true)
    local user_answer = vim.fn.confirm('Remove: '..dir, "&Yes\n&No")
    if user_answer == 1 then
        os.remove(dir)
        vim.api.nvim_echo({{'Removed: '..dir}}, true, {})
    end
end

local sessions = function(projects, opts)
    pickers.new(opts, {
        prompt_title = 'Select a session',
        results_title = 'Sessions',
        finder = finders.new_table {
            results = projects,
            entry_maker = function(entry)
                return {
                    value = entry.path,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end,
        },
        sorter = conf.file_sorter({}),
        attach_mappings = function(_, map)
            map('i', '<CR>', load_session)
            map('i', '<C-n>', new_session)
            map('i', '<Del>', del_session)
            map('i', '<C-s>', save_current)
            return true
        end
    }):find()
end

M.setup = function(ext_config)
    sessions_dir = ext_config.sessions_dir or vim.fn.stdpath('data') ..'/session/'
end

M.run_sessions = function(opts)
    opts = opts or {}
    local handle = vim.loop.fs_scandir(sessions_dir)
    if handle == nil then
        print('Setup correct \'sessions_dir\': "' .. sessions_dir .. '" does not seem to exist. Cancelling')
        return
    end

    if type(handle) == 'string' then
        vim.api.nvim_err_writeln(handle)
        return
    end

    local existing_projects = {}

    while true do
        local name, t = vim.loop.fs_scandir_next(handle)
        if not name then break end
        if t == 'file' then
            table.insert( existing_projects, {name = name, path = sessions_dir..name})
        end
    end

    sessions(existing_projects, opts)
end

return M
