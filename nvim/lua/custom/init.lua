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

vim.cmd.colorscheme "parchment"
