" Vim color scheme
" Parchment 1850 Light

set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "parchment"

" Palette
let s:bg0     = '#f5efe0'
let s:bg1     = '#ede4d0'
let s:bg2     = '#e2d8c4'
let s:bg3     = '#d4c8b0'
let s:ui      = '#c8b898'
let s:comment = '#9a8870'
let s:subtle  = '#7a6650'
let s:fg      = '#2a1f10'
let s:bright  = '#180e04'
let s:red     = '#a03020'
let s:orange  = '#a05c10'
let s:yellow  = '#8a6500'
let s:green   = '#3a7a28'
let s:teal    = '#246e5e'
let s:blue    = '#2a5c90'
let s:purple  = '#7040a0'
let s:pink    = '#884060'

exe 'hi Normal          guifg='.s:fg.'       guibg='.s:bg0
exe 'hi Cursor                               guibg='.s:orange
exe 'hi CursorLine                           guibg='.s:bg1
exe 'hi LineNr          guifg='.s:ui.'       guibg='.s:bg0
exe 'hi CursorLineNr    guifg='.s:subtle.'   guibg='.s:bg0.'   gui=bold'
exe 'hi Search                               guibg='.s:bg3
exe 'hi IncSearch       guifg='.s:bg0.'      guibg='.s:orange
exe 'hi VertSplit       guifg='.s:ui.'       guibg='.s:ui
exe 'hi Visual                               guibg='.s:bg3
exe 'hi Folded          guifg='.s:comment.'  guibg='.s:bg1
exe 'hi FoldColumn      guifg='.s:ui.'       guibg='.s:bg0
exe 'hi Directory       guifg='.s:blue
exe 'hi Pmenu           guifg='.s:fg.'       guibg='.s:bg1
exe 'hi PmenuSel        guifg='.s:fg.'       guibg='.s:bg3
exe 'hi PMenuSbar                            guibg='.s:bg2
exe 'hi PMenuThumb                           guibg='.s:ui
exe 'hi SignColumn      guifg='.s:ui.'       guibg='.s:bg0
exe 'hi NonText         guifg='.s:ui
exe 'hi SpecialKey      guifg='.s:ui
exe 'hi MatchParen      guifg='.s:bright.'   guibg='.s:bg3.'   gui=bold'

exe 'hi Comment         guifg='.s:comment.'                     gui=italic'
exe 'hi Todo            guifg='.s:purple.'   guibg=NONE         gui=bold'
exe 'hi Constant        guifg='.s:orange
exe 'hi String          guifg='.s:green
exe 'hi Number          guifg='.s:red
exe 'hi Boolean         guifg='.s:red
exe 'hi Float           guifg='.s:red
exe 'hi Identifier      guifg='.s:fg
exe 'hi Function        guifg='.s:yellow
exe 'hi Statement       guifg='.s:purple.'                      gui=none'
exe 'hi Keyword         guifg='.s:purple
exe 'hi Conditional     guifg='.s:purple.'                      gui=italic'
exe 'hi Repeat          guifg='.s:purple
exe 'hi Operator        guifg='.s:teal
exe 'hi PreProc         guifg='.s:pink
exe 'hi Include         guifg='.s:purple
exe 'hi Define          guifg='.s:pink
exe 'hi Macro           guifg='.s:pink
exe 'hi PreCondit       guifg='.s:pink
exe 'hi Type            guifg='.s:orange.'                      gui=none'
exe 'hi StorageClass    guifg='.s:orange
exe 'hi Structure       guifg='.s:orange
exe 'hi Typedef         guifg='.s:orange
exe 'hi Special         guifg='.s:teal
exe 'hi Delimiter       guifg='.s:subtle
exe 'hi Underlined      guifg='.s:blue.'                        gui=underline'
exe 'hi Error           guifg='.s:red.'      guibg=NONE         gui=bold'
exe 'hi Title           guifg='.s:orange.'                      gui=bold'
exe 'hi ErrorMsg        guifg='.s:red.'                         gui=bold'
exe 'hi WarningMsg      guifg='.s:orange

exe 'hi DiffAdd         guifg='.s:green.'    guibg=#d0e8c0'
exe 'hi DiffDelete      guifg='.s:red.'      guibg=#e8d0c8'
exe 'hi DiffChange                           guibg=#e8e0c0'
exe 'hi DiffText                             guibg=#d8d0a8      gui=bold'

exe 'hi StatusLine      guifg='.s:fg.'       guibg='.s:bg2.'    gui=none'
exe 'hi StatusLineNC    guifg='.s:comment.'  guibg='.s:bg1.'    gui=none'
exe 'hi TabLine         guifg='.s:comment.'  guibg='.s:bg1.'    gui=none'
exe 'hi TabLineFill                          guibg='.s:bg1.'    gui=none'
exe 'hi TabLineSel      guifg='.s:fg.'       guibg='.s:bg0.'    gui=bold'

exe 'hi User1           guifg='.s:yellow.'   guibg='.s:bg2.'    gui=none'
exe 'hi User2           guifg='.s:red.'      guibg='.s:bg2.'    gui=none'
exe 'hi User3           guifg='.s:green.'    guibg='.s:bg2.'    gui=none'
exe 'hi User4           guifg='.s:bg0.'      guibg='.s:purple.' gui=none'
exe 'hi User5           guifg='.s:fg.'       guibg='.s:bg2
exe 'hi User6           guifg='.s:comment.'  guibg='.s:bg2
exe 'hi User7           guifg='.s:bg2.'      guibg='.s:bg2.'    gui=none'

hi link htmlTag              xmlTag
hi link htmlTagName          xmlTagName
hi link htmlEndTag           xmlEndTag

exe 'hi xmlTag          guifg='.s:orange
exe 'hi xmlTagName      guifg='.s:orange
exe 'hi xmlEndTag       guifg='.s:orange

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    exe 'hi User4 guifg=#f5efe0 guibg=#2a5c90'
  elseif a:mode == 'r'
    exe 'hi User4 guifg=#f5efe0 guibg=#a03020'
  else
    exe 'hi User4 guifg=#f5efe0 guibg=#7040a0'
  endif
endfunction

exe 'au InsertEnter * call InsertStatuslineColor(v:insertmode)'
exe 'au InsertLeave * hi StatusLine guifg='.s:fg.' guibg='.s:bg2
exe 'au InsertLeave * hi User4 guifg='.s:bg0.' guibg='.s:purple
