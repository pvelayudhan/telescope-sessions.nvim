# Telescope Sessions

Forked from: https://github.com/JoseConseco/telescope_sessions_picker.nvim

This fork is pared down simply to create, delete, and open sessions with Telescope.

## Lazy

1. Add the plugin to Telescope's dependencies:

```lua
{
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    {
        "pvelayudhan/telescope-sessions.nvim",
    },
  },
}
```

2. Setup and load the extension

```lua
require'telescope'.setup {
    extensions = {
        sessions_picker = {
            sessions_dir = vim.fn.stdpath('data') ..'/session/',
        }
    },
}

require('telescope').load_extension('sessions_picker')
```

## Usage

Call the session picker with:

```viml
:Telescope sessions_picker

"Using lua function
lua require('telescope').extensions.sessions_picker.sessions_picker()
```

Then use one of the commands below:

`<CR>` - Open session

`<DEL>` - Delete session

`<C-n>` - Create new session

`<C-s>` - Save session
