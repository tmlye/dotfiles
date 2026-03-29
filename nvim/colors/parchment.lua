-- Parchment 1850 Light — colorscheme for Neovim

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.o.background = "light"
vim.g.colors_name = "parchment"

local c = {
  bg0     = "#f5efe0",
  bg1     = "#ede4d0",
  bg2     = "#e2d8c4",
  bg3     = "#d4c8b0",
  ui      = "#c8b898",
  comment = "#9a8870",
  subtle  = "#7a6650",
  fg      = "#2a1f10",
  bright  = "#180e04",
  red     = "#a03020",
  orange  = "#a05c10",
  yellow  = "#8a6500",
  green   = "#3a7a28",
  teal    = "#246e5e",
  blue    = "#2a5c90",
  purple  = "#7040a0",
  pink    = "#884060",
  none    = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hi("Normal",       { fg = c.fg, bg = c.bg1 })
hi("NormalFloat",  { fg = c.fg, bg = c.bg1 })
hi("FloatBorder",  { fg = c.ui, bg = c.bg1 })
hi("Cursor",       { fg = c.bg0, bg = c.orange })
hi("CursorLine",   { bg = c.bg1 })
hi("CursorColumn", { bg = c.bg1 })
hi("ColorColumn",  { bg = c.bg1 })
hi("LineNr",       { fg = c.ui })
hi("CursorLineNr", { fg = c.subtle, bold = true })
hi("SignColumn",   { fg = c.ui, bg = c.bg0 })
hi("VertSplit",    { fg = c.ui, bg = c.bg0 })
hi("WinSeparator", { fg = c.ui, bg = c.bg0 })
hi("StatusLine",   { fg = c.fg, bg = c.bg2 })
hi("StatusLineNC", { fg = c.comment, bg = c.bg1 })
hi("TabLine",      { fg = c.comment, bg = c.bg1 })
hi("TabLineFill",  { bg = c.bg1 })
hi("TabLineSel",   { fg = c.fg, bg = c.bg0, bold = true })
hi("Pmenu",        { fg = c.fg, bg = c.bg1 })
hi("PmenuSel",     { fg = c.fg, bg = c.bg3 })
hi("PmenuSbar",    { bg = c.bg2 })
hi("PmenuThumb",   { bg = c.ui })
hi("Visual",       { bg = c.bg3 })
hi("VisualNOS",    { bg = c.bg3 })
hi("Search",       { fg = c.bg0, bg = c.yellow })
hi("IncSearch",    { fg = c.bg0, bg = c.orange })
hi("CurSearch",    { fg = c.bg0, bg = c.orange })
hi("Folded",       { fg = c.comment, bg = c.bg1 })
hi("FoldColumn",   { fg = c.ui, bg = c.bg0 })
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
hi("DiffAdd",    { bg = "#d0e8c0" })
hi("DiffChange", { bg = "#e8e0c0" })
hi("DiffDelete", { fg = c.red, bg = "#e8d0c8" })
hi("DiffText",   { bg = "#d8d0a8", bold = true })

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
hi("NeoTreeNormal",       { fg = c.fg, bg = c.bg1 })
hi("NeoTreeNormalNC",      { fg = c.fg, bg = c.bg1 })
hi("NeoTreeDirectoryName", { fg = c.blue })
hi("NeoTreeDirectoryIcon", { fg = c.blue })
hi("NeoTreeRootName",      { fg = c.orange, bold = true })
hi("NeoTreeFileName",      { fg = c.fg })
hi("NeoTreeGitAdded",      { fg = c.green })
hi("NeoTreeGitModified",   { fg = c.yellow })
hi("NeoTreeGitDeleted",    { fg = c.red })
hi("NeoTreeGitUntracked",  { fg = c.comment })

-- Telescope
hi("TelescopeNormal",       { fg = c.fg, bg = c.bg1 })
hi("TelescopeBorder",       { fg = c.ui, bg = c.bg1 })
hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg2 })
hi("TelescopePromptBorder", { fg = c.ui, bg = c.bg2 })
hi("TelescopePromptTitle",  { fg = c.bg0, bg = c.orange })
hi("TelescopePreviewTitle", { fg = c.bg0, bg = c.green })
hi("TelescopeResultsTitle", { fg = c.bg0, bg = c.blue })
hi("TelescopeSelection",    { bg = c.bg3 })
hi("TelescopeMatching",     { fg = c.orange, bold = true })

-- LSP
hi("LspReferenceText",  { bg = c.bg2 })
hi("LspReferenceRead",  { bg = c.bg2 })
hi("LspReferenceWrite", { bg = c.bg3 })
hi("LspInlayHint",      { fg = c.comment, bg = c.bg1, italic = true })

-- CMP
hi("CmpItemAbbr",           { fg = c.fg })
hi("CmpItemAbbrMatch",      { fg = c.orange, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.orange })
hi("CmpItemKind",           { fg = c.purple })
hi("CmpItemMenu",           { fg = c.comment })

-- Terminal colors
vim.g.terminal_color_0  = "#2a1f10"
vim.g.terminal_color_1  = "#a03020"
vim.g.terminal_color_2  = "#3a7a28"
vim.g.terminal_color_3  = "#8a6500"
vim.g.terminal_color_4  = "#2a5c90"
vim.g.terminal_color_5  = "#7040a0"
vim.g.terminal_color_6  = "#246e5e"
vim.g.terminal_color_7  = "#ede4d0"
vim.g.terminal_color_8  = "#7a6650"
vim.g.terminal_color_9  = "#a05c10"
vim.g.terminal_color_10 = "#3a7a28"
vim.g.terminal_color_11 = "#a05c10"
vim.g.terminal_color_12 = "#2a5c90"
vim.g.terminal_color_13 = "#884060"
vim.g.terminal_color_14 = "#246e5e"
vim.g.terminal_color_15 = "#f5efe0"
