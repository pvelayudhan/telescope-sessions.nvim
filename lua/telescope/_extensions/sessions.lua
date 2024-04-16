local has_telescope, telescope = pcall(require, 'telescope')
local main = require('telescope._extensions.sessions.main')

if not has_telescope then
    error('This plugins requires nvim-telescope/telescope.nvim')
end

return telescope.register_extension {
    exports = {sessions = main.run_sessions},
    setup = main.setup,
}
