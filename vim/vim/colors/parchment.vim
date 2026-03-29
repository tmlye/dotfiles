" Vim color scheme
" Parchment 1850 Dark

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "parchment"

" Palette
let s:bg0     = '#1e1810'
let s:bg1     = '#26201a'
let s:bg2     = '#2e2820'
let s:bg3     = '#3a3228'
let s:ui      = '#4a4035'
let s:comment = '#6b5c48'
let s:subtle  = '#8c7a62'
let s:fg      = '#d4c4a8'
let s:bright  = '#e8d8b8'
let s:red     = '#c0624a'
let s:orange  = '#c88040'
let s:yellow  = '#c4a850'
let s:green   = '#7a9e68'
let s:teal    = '#5e9e8a'
let s:blue    = '#6e8cb0'
let s:purple  = '#9e7ab0'
let s:pink    = '#b07080'

exe 'hi Normal          guifg='.s:fg.'       guibg='.s:bg1
exe 'hi Cursor                               guibg='.s:orange
exe 'hi CursorLine                           guibg='.s:bg2
exe 'hi LineNr          guifg='.s:ui.'       guibg='.s:bg1
exe 'hi CursorLineNr    guifg='.s:subtle.'   guibg='.s:bg1.'   gui=bold'
exe 'hi Search                               guibg='.s:bg3
exe 'hi IncSearch       guifg='.s:bg0.'      guibg='.s:orange
exe 'hi VertSplit       guifg='.s:ui.'       guibg='.s:ui
exe 'hi Visual                               guibg='.s:bg3
exe 'hi Folded          guifg='.s:comment.'  guibg='.s:bg2
exe 'hi FoldColumn      guifg='.s:ui.'       guibg='.s:bg1
exe 'hi Directory       guifg='.s:blue
exe 'hi Pmenu           guifg='.s:fg.'       guibg='.s:bg2
exe 'hi PmenuSel        guifg='.s:fg.'       guibg='.s:bg3
exe 'hi PMenuSbar                            guibg='.s:bg3
exe 'hi PMenuThumb                           guibg='.s:ui
exe 'hi SignColumn      guifg='.s:ui.'       guibg='.s:bg1
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

exe 'hi DiffAdd         guifg='.s:green.'    guibg=#2a3828'
exe 'hi DiffDelete      guifg='.s:red.'      guibg=#3a2020'
exe 'hi DiffChange                           guibg=#2e2820'
exe 'hi DiffText                             guibg=#3a3020      gui=bold'

exe 'hi StatusLine      guifg='.s:fg.'       guibg='.s:bg3.'    gui=none'
exe 'hi StatusLineNC    guifg='.s:comment.'  guibg='.s:bg2.'    gui=none'
exe 'hi TabLine         guifg='.s:comment.'  guibg='.s:bg2.'    gui=none'
exe 'hi TabLineFill                          guibg='.s:bg2.'    gui=none'
exe 'hi TabLineSel      guifg='.s:fg.'       guibg='.s:bg1.'    gui=bold'

exe 'hi User1           guifg='.s:yellow.'   guibg='.s:bg3.'    gui=none'
exe 'hi User2           guifg='.s:red.'      guibg='.s:bg3.'    gui=none'
exe 'hi User3           guifg='.s:green.'    guibg='.s:bg3.'    gui=none'
exe 'hi User4           guifg='.s:bg0.'      guibg='.s:purple.' gui=none'
exe 'hi User5           guifg='.s:fg.'       guibg='.s:bg3
exe 'hi User6           guifg='.s:comment.'  guibg='.s:bg3
exe 'hi User7           guifg='.s:bg3.'      guibg='.s:bg3.'    gui=none'

hi link htmlTag              xmlTag
hi link htmlTagName          xmlTagName
hi link htmlEndTag           xmlEndTag

exe 'hi xmlTag          guifg='.s:orange
exe 'hi xmlTagName      guifg='.s:orange
exe 'hi xmlEndTag       guifg='.s:orange

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    exe 'hi User4 guifg=#1e1810 guibg=#6e8cb0'
  elseif a:mode == 'r'
    exe 'hi User4 guifg=#1e1810 guibg=#c0624a'
  else
    exe 'hi User4 guifg=#1e1810 guibg=#9e7ab0'
  endif
endfunction

exe 'au InsertEnter * call InsertStatuslineColor(v:insertmode)'
exe 'au InsertLeave * hi StatusLine guifg='.s:fg.' guibg='.s:bg3
exe 'au InsertLeave * hi User4 guifg='.s:bg0.' guibg='.s:purple
