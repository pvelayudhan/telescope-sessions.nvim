# Telescope Sessions

Forked from: https://github.com/JoseConseco/telescope_sessions_picker.nvim

This fork is pared down simply to create, delete, and open sessions with Telescope.

## Install

```
use 'JoseConseco/telescope_sessions_picker.nvim'
```

## Configuration
This extension can be configured using `extensions` field inside Telescope
setup function.

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
