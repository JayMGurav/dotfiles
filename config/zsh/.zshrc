autoload -Uz compinit
compinit -C

export PATH="/opt/homebrew/bin:$PATH:$PATH"

# ============
# NVM
# ============
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion"

# ============
# SDKMAN
# ============
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# ============
# Starship
# ============
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# ============
# Atuin
# ============
eval "$(atuin init zsh)"
export ATUIN_NOBIND="true"
bindkey '^r' atuin-search

# ============
# fzf
# ============
eval "$(fzf --zsh)"

# Use fd for file discovery
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"

# UI & preview
export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
--prompt='❯ '
--preview 'bat --style=numbers --color=always {}'
--preview-window=right:60%
"

# CTRL-T (files)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# CTRL-R (history via atuin)
export FZF_CTRL_R_OPTS="
--preview 'echo {} | sed \"s/^[0-9]* //\" | bat --language=bash --color=always'
"

# Git helpers using fzf
gco() {
  local branch
  branch=$(git branch --all --color=always \
    | sed 's/^..//' \
    | fzf --ansi --preview 'git log --oneline --graph --decorate --color=always {} | head -100') \
    || return

  git checkout "$(echo "$branch" | sed 's|remotes/[^/]*/||')"
}

gl() {
  git log --oneline --graph --decorate --color=always \
    | fzf --ansi --no-sort --reverse \
      --preview 'git show --color=always {1}' \
      --bind 'enter:execute(git show --color=always {1} | less -R)'
}

ga() {
  local files
  files=$(git status --short \
    | fzf -m --preview 'git diff --color=always -- {-1}') || return
  echo "$files" | awk '{print $2}' | xargs git add
}

# ============
# zoxide
# ============
eval "$(zoxide init zsh)"
alias cd="z"

# ============
# direnv
# ============
eval "$(direnv hook zsh)"

# ============
# eza
# ============
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --git"
alias la="eza -la"
alias lt="eza --tree --level=2"

# ============
# bat
# ============
export BAT_THEME="TwoDark"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"



# ============ helpers ============

function detect-columns() { nu -c 'cat | detect columns' }