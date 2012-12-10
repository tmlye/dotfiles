## COMPLETION
# ignore completion to commands we don't have
zstyle ':completion:*:functions'          ignored-patterns '_*'

# format autocompletion style
zstyle ':completion:*:descriptions'       format "%{$c1%}%d%{$reset_color%}"
zstyle ':completion:*:corrections'        format "%{$c3%}%d%{$reset_color%}"
zstyle ':completion:*:messages'           format "%{$c1%}%d%{$reset_color%}"
zstyle ':completion:*:warnings'           format "%{$c1%}%d%{$reset_color%}"

# zstyle show completion menu if 2 or more items to select
zstyle ':completion:*'                    menu select=2

# zstyle kill menu
zstyle ':completion:*:*:kill:*'           menu yes select
zstyle ':completion:*:kill:*'             force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

## VCS
# vcs_info
zstyle ':vcs_info:*'                      enable git hg svn
# check-for-changes can be really slow.
# you should disable it, if you work with large repositories   
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:*' actionformats "${FMT_BRANCH}${FMT_ACTION}" "${FMT_PATH}"
zstyle ':vcs_info:*' formats       "${FMT_BRANCH}"              "${FMT_PATH}"
zstyle ':vcs_info:*' nvcsformats   ""                           "%~"

# vim: set ft=zsh :
