autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn

theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%F{8}:: %F{magenta}%b%c%u%B%F{green}'
    } else {
        zstyle ':vcs_info:*' formats '%F{8}:: %F{magenta}%b%c%u%B%F{red}●%F{green}'
    }

    vcs_info
}

setprompt() {
  local USER="%{$fg[yellow]%}%n%f"
  local HOST="%{$fg[green]%}%M%f"
  local PWD="%F{7}$($HOME/.dotfiles/bin/rzsh_path)%f"
  local EXIT="%(?..%{$fg_bold[red]%}%?%f)"
  local GIT="${vcs_info_msg_0_}"

  PROMPT="${USER}@$HOST %F{8}:: ${PWD} ${GIT} ${KUBECTL_CONTEXT}
${EXIT} %{$fg_bold[red]%}›%f "
}

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
add-zsh-hook precmd setprompt

# vim: set ft=zsh :
