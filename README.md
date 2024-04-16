# Telescope Sessions

Forked from: https://github.com/JoseConseco/telescope_sessions.nvim

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
        sessions = {
            sessions_dir = vim.fn.stdpath('data') ..'/session/',
        }
    },
}

require('telescope').load_extension('sessions')
```

## Usage

Call the session picker with:

```viml
:Telescope sessions
```

Then use one of the commands below:

`<CR>` - Open session

`<DEL>` - Delete session

`<C-n>` - Create new session

`<C-s>` - Save session
