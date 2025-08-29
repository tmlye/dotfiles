require("custom.keymap")
require("custom.options")
require("custom.commands")
require("custom.packages")

require("autoclose").setup()
require("colorizer").setup()

vim.diagnostic.config({
  underline = false,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.INFO }
  }
})

require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = {     -- :h background
    light = "frappe",
    dark = "macchiato",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
  term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = true,               -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15,            -- percentage of the shade to apply to the inactive window
  },
  no_italic = true,               -- Force no italic
  no_bold = false,                -- Force no bold
  no_underline = false,           -- Force no underline
  styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" },      -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = false,
  },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
