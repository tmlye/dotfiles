-- Parchment 1850 Dark — colorscheme for Neovim

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.o.background = "dark"
vim.g.colors_name = "parchment"

local c = {
  bg0     = "#1e1810",
  bg1     = "#26201a",
  bg2     = "#2e2820",
  bg3     = "#3a3228",
  ui      = "#4a4035",
  comment = "#6b5c48",
  subtle  = "#8c7a62",
  fg      = "#d4c4a8",
  bright  = "#e8d8b8",
  red     = "#c0624a",
  orange  = "#c88040",
  yellow  = "#c4a850",
  green   = "#7a9e68",
  teal    = "#5e9e8a",
  blue    = "#6e8cb0",
  purple  = "#9e7ab0",
  pink    = "#b07080",
  none    = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hi("Normal",       { fg = c.fg, bg = c.bg1 })
hi("NormalFloat",  { fg = c.fg, bg = c.bg2 })
hi("FloatBorder",  { fg = c.ui, bg = c.bg2 })
hi("Cursor",       { fg = c.bg0, bg = c.orange })
hi("CursorLine",   { bg = c.bg2 })
hi("CursorColumn", { bg = c.bg2 })
hi("ColorColumn",  { bg = c.bg2 })
hi("LineNr",       { fg = c.ui })
hi("CursorLineNr", { fg = c.subtle, bold = true })
hi("SignColumn",   { fg = c.ui, bg = c.bg1 })
hi("VertSplit",    { fg = c.ui, bg = c.bg1 })
hi("WinSeparator", { fg = c.ui, bg = c.bg1 })
hi("StatusLine",   { fg = c.fg, bg = c.bg3 })
hi("StatusLineNC", { fg = c.comment, bg = c.bg2 })
hi("TabLine",      { fg = c.comment, bg = c.bg2 })
hi("TabLineFill",  { bg = c.bg2 })
hi("TabLineSel",   { fg = c.fg, bg = c.bg1, bold = true })
hi("Pmenu",        { fg = c.fg, bg = c.bg2 })
hi("PmenuSel",     { fg = c.fg, bg = c.bg3 })
hi("PmenuSbar",    { bg = c.bg3 })
hi("PmenuThumb",   { bg = c.ui })
hi("Visual",       { bg = c.bg3 })
hi("VisualNOS",    { bg = c.bg3 })
hi("Search",       { fg = c.bg0, bg = c.yellow })
hi("IncSearch",    { fg = c.bg0, bg = c.orange })
hi("CurSearch",    { fg = c.bg0, bg = c.orange })
hi("Folded",       { fg = c.comment, bg = c.bg2 })
hi("FoldColumn",   { fg = c.ui, bg = c.bg1 })
hi("NonText",      { fg = c.ui })
hi("SpecialKey",   { fg = c.ui })
hi("Whitespace",   { fg = c.ui })
hi("EndOfBuffer",  { fg = c.bg2 })
hi("Directory",    { fg = c.blue })
hi("Title",        { fg = c.orange, bold = true })
hi("Question",     { fg = c.green })
hi("MoreMsg",      { fg = c.green })
hi("WarningMsg",   { fg = c.orange })
hi("ErrorMsg",     { fg = c.red, bold = true })
hi("ModeMsg",      { fg = c.fg, bold = true })
hi("MatchParen",   { fg = c.bright, bg = c.bg3, bold = true })
hi("Conceal",      { fg = c.comment })
hi("WildMenu",     { fg = c.fg, bg = c.bg3 })

-- Diff
hi("DiffAdd",    { bg = "#2a3828" })
hi("DiffChange", { bg = "#2e2820" })
hi("DiffDelete", { fg = c.red, bg = "#3a2020" })
hi("DiffText",   { bg = "#3a3020", bold = true })

-- Diagnostics
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn",  { fg = c.orange })
hi("DiagnosticInfo",  { fg = c.blue })
hi("DiagnosticHint",  { fg = c.teal })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.orange })
hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.blue })
hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.teal })

-- Syntax
hi("Comment",    { fg = c.comment, italic = true })
hi("Constant",   { fg = c.orange })
hi("String",     { fg = c.green })
hi("Character",  { fg = c.green })
hi("Number",     { fg = c.red })
hi("Float",      { fg = c.red })
hi("Boolean",    { fg = c.red })
hi("Identifier", { fg = c.fg })
hi("Function",   { fg = c.yellow })
hi("Statement",  { fg = c.purple })
hi("Conditional",{ fg = c.purple, italic = true })
hi("Repeat",     { fg = c.purple })
hi("Label",      { fg = c.purple })
hi("Operator",   { fg = c.teal })
hi("Keyword",    { fg = c.purple })
hi("Exception",  { fg = c.purple })
hi("PreProc",    { fg = c.pink })
hi("Include",    { fg = c.purple })
hi("Define",     { fg = c.pink })
hi("Macro",      { fg = c.pink })
hi("PreCondit",  { fg = c.pink })
hi("Type",       { fg = c.orange })
hi("StorageClass", { fg = c.orange })
hi("Structure",  { fg = c.orange })
hi("Typedef",    { fg = c.orange })
hi("Special",    { fg = c.teal })
hi("SpecialChar",{ fg = c.teal })
hi("Tag",        { fg = c.orange })
hi("Delimiter",  { fg = c.fg })
hi("SpecialComment", { fg = c.comment, bold = true })
hi("Debug",      { fg = c.red })
hi("Underlined", { fg = c.blue, underline = true })
hi("Error",      { fg = c.red, bold = true })
hi("Todo",       { fg = c.purple, bold = true })

-- Treesitter
hi("@variable",           { fg = c.fg })
hi("@variable.builtin",   { fg = c.pink })
hi("@variable.parameter", { fg = c.fg })
hi("@constant",           { fg = c.orange })
hi("@constant.builtin",   { fg = c.red })
hi("@module",             { fg = c.blue })
hi("@string",             { fg = c.green })
hi("@string.escape",      { fg = c.teal })
hi("@character",          { fg = c.green })
hi("@number",             { fg = c.red })
hi("@boolean",            { fg = c.red })
hi("@float",              { fg = c.red })
hi("@function",           { fg = c.yellow })
hi("@function.builtin",   { fg = c.yellow })
hi("@function.call",      { fg = c.yellow })
hi("@function.method",    { fg = c.yellow })
hi("@function.method.call", { fg = c.yellow })
hi("@constructor",        { fg = c.orange })
hi("@keyword",            { fg = c.purple })
hi("@keyword.function",   { fg = c.purple })
hi("@keyword.return",     { fg = c.purple })
hi("@keyword.operator",   { fg = c.teal })
hi("@keyword.conditional",{ fg = c.purple, italic = true })
hi("@keyword.repeat",     { fg = c.purple })
hi("@keyword.import",     { fg = c.purple })
hi("@keyword.exception",  { fg = c.purple })
hi("@operator",           { fg = c.teal })
hi("@punctuation.bracket", { fg = c.subtle })
hi("@punctuation.delimiter", { fg = c.subtle })
hi("@type",               { fg = c.orange })
hi("@type.builtin",       { fg = c.orange })
hi("@type.qualifier",     { fg = c.purple })
hi("@attribute",          { fg = c.blue })
hi("@property",           { fg = c.blue })
hi("@tag",                { fg = c.orange })
hi("@tag.attribute",      { fg = c.blue })
hi("@tag.delimiter",      { fg = c.subtle })
hi("@markup.heading",     { fg = c.orange, bold = true })
hi("@markup.strong",      { bold = true })
hi("@markup.italic",      { italic = true })
hi("@markup.link",        { fg = c.blue, underline = true })
hi("@markup.link.url",    { fg = c.teal, underline = true })
hi("@markup.raw",         { fg = c.green })
hi("@comment",            { fg = c.comment, italic = true })

-- Git signs
hi("GitSignsAdd",    { fg = c.green })
hi("GitSignsChange", { fg = c.yellow })
hi("GitSignsDelete", { fg = c.red })

-- Neo-tree
hi("NeoTreeNormal",       { fg = c.fg, bg = c.bg2 })
hi("NeoTreeNormalNC",      { fg = c.fg, bg = c.bg2 })
hi("NeoTreeDirectoryName", { fg = c.blue })
hi("NeoTreeDirectoryIcon", { fg = c.blue })
hi("NeoTreeRootName",      { fg = c.orange, bold = true })
hi("NeoTreeFileName",      { fg = c.fg })
hi("NeoTreeGitAdded",      { fg = c.green })
hi("NeoTreeGitModified",   { fg = c.yellow })
hi("NeoTreeGitDeleted",    { fg = c.red })
hi("NeoTreeGitUntracked",  { fg = c.comment })

-- Telescope
hi("TelescopeNormal",       { fg = c.fg, bg = c.bg2 })
hi("TelescopeBorder",       { fg = c.ui, bg = c.bg2 })
hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg3 })
hi("TelescopePromptBorder", { fg = c.ui, bg = c.bg3 })
hi("TelescopePromptTitle",  { fg = c.bg0, bg = c.orange })
hi("TelescopePreviewTitle", { fg = c.bg0, bg = c.green })
hi("TelescopeResultsTitle", { fg = c.bg0, bg = c.blue })
hi("TelescopeSelection",    { bg = c.bg3 })
hi("TelescopeMatching",     { fg = c.orange, bold = true })

-- LSP
hi("LspReferenceText",  { bg = c.bg3 })
hi("LspReferenceRead",  { bg = c.bg3 })
hi("LspReferenceWrite", { bg = c.ui })
hi("LspInlayHint",      { fg = c.comment, bg = c.bg2, italic = true })

-- CMP
hi("CmpItemAbbr",           { fg = c.fg })
hi("CmpItemAbbrMatch",      { fg = c.orange, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.orange })
hi("CmpItemKind",           { fg = c.purple })
hi("CmpItemMenu",           { fg = c.comment })

-- Terminal colors
vim.g.terminal_color_0  = "#1e1810"
vim.g.terminal_color_1  = "#c0624a"
vim.g.terminal_color_2  = "#7a9e68"
vim.g.terminal_color_3  = "#c4a850"
vim.g.terminal_color_4  = "#6e8cb0"
vim.g.terminal_color_5  = "#9e7ab0"
vim.g.terminal_color_6  = "#5e9e8a"
vim.g.terminal_color_7  = "#d4c4a8"
vim.g.terminal_color_8  = "#8c7a62"
vim.g.terminal_color_9  = "#c88040"
vim.g.terminal_color_10 = "#7a9e68"
vim.g.terminal_color_11 = "#c88040"
vim.g.terminal_color_12 = "#6e8cb0"
vim.g.terminal_color_13 = "#b07080"
vim.g.terminal_color_14 = "#5e9e8a"
vim.g.terminal_color_15 = "#e8d8b8"
