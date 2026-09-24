# Homebrew is initialized in .zprofile (runs once per login shell, inherited from here)
# Ghostty injects its shell integration automatically, so no manual source needed.

# --- History ---
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # share history across all open terminals
setopt EXTENDED_HISTORY       # record timestamp + duration for each command
setopt HIST_IGNORE_ALL_DUPS   # drop older copies of a repeated command
setopt HIST_IGNORE_SPACE      # don't log lines starting with a space
setopt HIST_REDUCE_BLANKS     # trim superfluous whitespace
setopt HIST_FIND_NO_DUPS      # no duplicates when searching history
setopt HIST_VERIFY            # show !! expansions before running them

# --- General options ---
setopt AUTO_CD                # type a directory name to cd into it
setopt INTERACTIVE_COMMENTS   # allow "# comments" in pasted commands

eval "$(starship init zsh)"

export EDITOR='micro'
export VISUAL='micro'

# bat (and delta, which reads BAT_THEME) use the terminal's own colours
export BAT_THEME='ansi'
# Colourful man pages via bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT='-c'

# Bitwarden SSH agent
export SSH_AUTH_SOCK="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"

# GitHub PAT for the GitHub MCP server (stored in macOS Keychain, backed up in Bitwarden).
# GITHUB_PERSONAL_ACCESS_TOKEN is the standard name expected by GitHub MCP.
export GITHUB_PERSONAL_ACCESS_TOKEN="$(security find-generic-password -s github-pat -w 2>/dev/null)"
# Keep GITHUB_PAT as alias for CLI tools (gh, etc.)
export GITHUB_PAT="$GITHUB_PERSONAL_ACCESS_TOKEN"

# --- eza (Modern ls) ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --header --group-directories-first'
alias la='eza -a --icons --group-directories-first'
# Detailed list with Git status (Great for dev work)
alias l='eza -l --icons --git --group-directories-first'
# Tree view (Shows folder structure up to 2 levels deep)
alias lt='eza --tree --level=2 --icons'
# Sort by newest (Helpful for finding recent AI-generated files)
alias lr='eza -l --icons --sort=newest'

# --- bat (Modern cat) ---
alias cat='bat'
# Plain version (no line numbers/headers) - great for copy-pasting code
alias catp='bat --style=plain --paging=never'
# Search command history using bat for syntax highlighting
alias hist='history 1 | bat --language=sh --style=plain'

# --- Miscellaneous Helpers ---
alias help='tldr' # Replaces 'man' with concise examples
alias grep='rg'   # Replaces grep with the much faster ripgrep
alias c='claude --dangerously-skip-permissions'
alias cc='claude --continue --dangerously-skip-permissions'
alias cr='claude --resume --dangerously-skip-permissions'

# --- Git shortcuts ---
alias gs='git status -sb'
alias gl='git log --graph --pretty="%C(yellow)%h%C(reset) %s %C(blue)<%an>%C(reset) %C(bright-black)%cr%C(auto)%d" -20'
# gco: switch branch with fzf (recent first, preview shows its log); gco <branch> works as usual
gco() {
  if (( $# )); then git switch "$@"; return; fi
  local branch
  branch=$(git branch --all --sort=-committerdate --format='%(refname:short)' |
    command grep -v -e '^origin$' -e 'HEAD' |
    fzf --prompt='branch> ' --preview 'git log --oneline --color=always -15 {}') || return
  git switch "${branch#origin/}"
}

# --- Completion ---
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'          # fzf-tab uses these as group headers

# fzf-tab: must load after compinit, before autosuggestions/syntax-highlighting
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
# Use the same Tokyo Night fzf colours (FZF_DEFAULT_OPTS below) in tab completion
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# --- fzf-tab Intelligent Previews ---
# 1. Preview file content with 'bat' for commands like cat/nano/vim
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  '[[ -f $realpath ]] && bat --color=always --line-range=:200 "$realpath" || eza -1 --color=always "$realpath"'

# 2. Specific preview for 'cd' (shows directory structure with eza)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always "$realpath"'

# 3. Preview environment variables (like $PATH or $HOME)
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# 4. Preview 'kill' command (shows process info)
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps -p $word -o comm='

# --- fzf core keybindings (Ctrl-R history, Ctrl-T file, Alt-C cd) ---
# Colours use terminal ANSI slots so fzf follows Ghostty's TokyoNight Night/Day theme
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border=rounded --info=inline-right \
--color=fg:-1,bg:-1,hl:blue,fg+:-1,bg+:black,hl+:bright-blue \
--color=info:yellow,prompt:cyan,pointer:magenta,marker:green,spinner:magenta \
--color=header:bright-black,border:bright-black,label:blue,query:-1,gutter:-1"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons {}'"
# Use fd when installed (faster, respects .gitignore)
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
fi
source <(fzf --zsh)

# --- direnv (per-directory env vars via .envrc) ---
eval "$(direnv hook zsh)"

# --- zoxide (Modern cd) ---
# --cmd cd makes `cd` itself zoxide-powered (and `cdi` the interactive picker).
# _ZO_DOCTOR=0 silences a false warning in non-interactive snapshot shells (e.g. Claude Code).
export _ZO_DOCTOR=0
eval "$(zoxide init zsh --cmd cd)"

# Quick jump aliases
alias z='cd'
alias zi='cdi'
alias j='cd'      # Quick jump
alias ji='cdi'    # Interactive jump with fzf
alias ..='cd ..'  # Go up one level
alias ...='cd ../..'

# --- Plugins that wrap zle widgets: load last ---
ZSH_AUTOSUGGEST_STRATEGY=(history completion)   # fall back to tab-completion suggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh-syntax-highlighting must be sourced very last, after anything else that
# registers zle widgets (fzf-tab, fzf keybindings, zoxide).
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Machine-specific overrides (not meant for a shared dotfiles repo)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
