# Config (override before sourcing, or export in your rc file):
#   WT_DIR          where worktrees live; blank = sibling
#                   dirs next to the main worktree          (default: blank)

: "${WT_DIR:=.agents/worktrees}"
: "${WT_BASE_BRANCH:=origin/main}"

# --- internals ---------------------------------------------------------------

# Path of the MAIN worktree. `git worktree list` always prints it first, so this
# works no matter which worktree you are standing in.
_wt_main() {
  local main
  main=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print substr($0,10); exit}')
  if [ -z "$main" ]; then
    printf 'not inside a git repository\n' >&2
    return 1
  fi
  printf '%s' "$main"
}

# Directory that holds worktrees. A relative WT_DIR is anchored at the main
# worktree, not the cwd.
_wt_parent() {
  local main; main=$(_wt_main) || return 1
  if [ -z "$WT_DIR" ]; then
    printf '%s' "$(dirname "$main")"
  else
    case "$WT_DIR" in
      /*) printf '%s' "${WT_DIR%/}" ;;
      *)  printf '%s/%s' "$main" "${WT_DIR%/}" ;;
    esac
  fi
}

# feat/thing -> feat-thing  (avoids accidental nested directories)
_wt_slug() { printf '%s' "${1//\//-}"; }

# Absolute path a given branch name maps to.
_wt_path() {
  local parent; parent=$(_wt_parent) || return 1
  printf '%s/%s' "$parent" "$(_wt_slug "$1")"
}

# Resolve a fuzzy name to a worktree path, matching on path OR branch name.
_wt_find() {
  git worktree list --porcelain 2>/dev/null | awk -v pat="$1" '
    function hit(p, b) {
      p = tolower(p); b = tolower(b)
      return (index(p, tolower(pat)) || (b != "" && index(b, tolower(pat))))
    }
    /^worktree /  { path = substr($0, 10); br = "" }
    /^branch /    { br = substr($0, 8); sub("refs/heads/", "", br) }
    /^$/          { if (!found && path != "" && hit(path, br)) found = path
                    path = ""; br = "" }
    END           { if (!found && path != "" && hit(path, br)) found = path
                    if (found) print found }
  '
}

# Trust the new worktree's .envrc so the direnv toolchain works immediately.
_wt_setup() {
  [ -f .envrc ] && command -v direnv >/dev/null 2>&1 && direnv allow
  return 0
}

# --- commands ----------------------------------------------------------------

# wtl — list worktrees, branch + short sha + path
wtl() {
  git worktree list --porcelain 2>/dev/null | awk '
    /^worktree /  { path=substr($0,10) }
    /^HEAD /      { sha=substr($2,1,8) }
    /^branch /    { br=substr($0,8); sub("refs/heads/","",br) }
    /^detached$/  { br="(detached)" }
    /^$/          { if (path) printf "%-28s %-10s %s\n", br, sha, path; path=br=sha="" }
    END           { if (path) printf "%-28s %-10s %s\n", br, sha, path }
  '
}

# wtn <branch> [base] — new branch in a new worktree, then cd there
wtn() {
  [ -n "$1" ] || { printf 'usage: wtn <branch> [base]\n' >&2; return 1; }
  # NB: never `local path` in zsh — it shadows the array tied to $PATH
  local base="${2:-$WT_BASE_BRANCH}" wt
  wt=$(_wt_path "$1") || return 1
  [ -e "$wt" ] && { printf '%s already exists\n' "$wt" >&2; return 1; }
  git fetch --quiet "${base%%/*}" 2>/dev/null || git fetch --quiet origin || true
  # --no-track: without it, branching from origin/main sets that as the
  # upstream, which makes a bare `git push` ambiguous. `git push -u origin HEAD`
  # sets the correct upstream on first push instead.
  git worktree add --no-track -b "$1" "$wt" "$base" || return 1
  cd "$wt" && _wt_setup
}

# wtc <branch|remote-branch> — worktree for a branch that already exists
wtc() {
  [ -n "$1" ] || { printf 'usage: wtc <branch>\n' >&2; return 1; }
  local wt; wt=$(_wt_path "$1") || return 1
  [ -e "$wt" ] && { cd "$wt"; return; }
  git fetch --quiet origin || true
  git worktree add "$wt" "$1" || return 1
  cd "$wt" && _wt_setup
}

# wtpr <number> — check out a GitHub PR into its own worktree
wtpr() {
  [ -n "$1" ] || { printf 'usage: wtpr <pr-number>\n' >&2; return 1; }
  local br="pr-$1" wt
  wt=$(_wt_path "$br") || return 1
  git fetch origin "+pull/$1/head:$br" || return 1
  if [ -e "$wt" ]; then cd "$wt"; else
    git worktree add "$wt" "$br" || return 1
    cd "$wt" && _wt_setup
  fi
}

# wtg [name] — go to a worktree; fzf picker when available, else substring match
wtg() {
  local parent wt
  parent=$(_wt_parent) || return 1
  if [ -z "$1" ]; then
    if command -v fzf >/dev/null 2>&1; then
      wt=$(git worktree list | fzf --height 40% --reverse | awk '{print $1}')
    else
      wtl; return 0
    fi
  else
    wt=$(_wt_find "$1")
    [ -z "$wt" ] && wt="$parent/$(_wt_slug "$1")"
  fi
  [ -d "$wt" ] || { printf 'no worktree matching %s\n' "$1" >&2; return 1; }
  cd "$wt"
}

# wtrm [name] — remove a worktree (default: the one you're in) and its branch
wtrm() {
  local main wt br
  main=$(_wt_main) || return 1
  if [ -n "$1" ]; then
    wt=$(_wt_find "$1")
    [ -z "$wt" ] && { printf 'no worktree matching %s\n' "$1" >&2; return 1; }
  else
    wt=$(git rev-parse --show-toplevel)
  fi
  if [ "$wt" = "$main" ]; then
    printf 'refusing to remove the main worktree\n' >&2; return 1
  fi
  br=$(git -C "$wt" symbolic-ref --quiet --short HEAD 2>/dev/null)
  # step out before deleting, or the shell is left in a dead directory
  case "$PWD/" in "$wt"/*) cd "$main" ;; esac
  git worktree remove "$wt" || {
    printf 'dirty worktree; rerun as: git worktree remove --force %s\n' "$wt" >&2
    return 1
  }
  if [ -n "$br" ]; then
    git branch -d "$br" 2>/dev/null \
      || printf 'branch %s kept — unmerged work. delete with: git branch -D %s\n' "$br" "$br"
  fi
  return 0
}

# wtprune — drop worktrees whose upstream branch is gone on the remote
wtprune() {
  local main list wt br
  main=$(_wt_main) || return 1
  git fetch --prune --quiet origin || true
  git worktree prune
  # snapshot the list first: removing entries mid-pipe would race the producer
  list=$(git worktree list --porcelain | awk '
    /^worktree /{path=substr($0,10)}
    /^branch /  {br=substr($0,8); sub("refs/heads/","",br); print path "\t" br}
  ')
  while IFS='	' read -r wt br; do
    [ -n "$br" ] && [ "$wt" != "$main" ] || continue
    # upstream configured but no longer resolvable => remote branch deleted
    git config --get "branch.$br.merge" >/dev/null 2>&1 || continue
    git rev-parse --verify --quiet "$br@{upstream}" >/dev/null 2>&1 && continue
    if ! git -C "$wt" diff --quiet HEAD 2>/dev/null \
       || [ -n "$(git -C "$wt" status --porcelain 2>/dev/null)" ]; then
      printf 'kept %s (%s): dirty worktree\n' "$wt" "$br"
      continue
    fi
    case "$PWD/" in "$wt"/*) cd "$main" ;; esac
    git worktree remove "$wt" || continue
    # -D: squash merges leave the branch "unmerged" in git's eyes. Print the
    # sha so a mistaken delete is recoverable.
    printf 'removed %s (%s @ %s)\n' "$wt" "$br" "$(git rev-parse --short "$br")"
    git branch -D "$br" >/dev/null
  done <<< "$list"
}
