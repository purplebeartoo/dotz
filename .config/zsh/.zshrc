source $HOME/.config/zsh/keybindings
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export FZF_ALT_C_COMMAND="fd -H --type d"
export FZF_CTRL_T_COMMAND="fd -H --type f"
export FZF_DEFAULT_COMMAND="fd -H --type f"
export FZF_DEFAULT_OPTS="\
  --color=bg+:#282a36 \
  --color=bg:#282a36 \
  --color=border:#8be9fd \
  --color=fg:#f8f8f2 \
  --color=gutter:#282a36 \
  --color=header:#ffb86c \
  --color=hl+:#8be9fd \
  --color=hl:#8be9fd \
  --color=info:#6272a4 \
  --color=marker:#ff5555 \
  --color=pointer:#ff5555 \
  --color=prompt:#8be9fd \
  --color=query:#f8f8f2:regular \
  --color=scrollbar:#8be9fd \
  --color=separator:#ffb86c \
  --color=spinner:#ff5555 \
  --height 75% \
  --layout=default"
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LESSHISTFILE=-
export MANPAGER="nvim +Man!"
export SUDO_EDITOR="nvim"
export TERM="ghostty"
export VISUAL="nvim"

# auto/tab completion:
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.

HISTFILE=$HOME/.config/zsh/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt autocd
setopt extendedglob
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt inc_append_history
setopt rmstarsilent

alias ad="age -d -o"
alias ae="age -e -p -o"
alias cat="bat -p"
alias dg="/usr/bin/git --git-dir=$HOME/.dotz/ --work-tree=$HOME"
alias dsk="ollama run deepseek-r1:7b"
alias f='handlr open $(fzf) && exit'
alias ls="eza -l -g --hyperlink --group-directories-first --icons -t modified"
alias lsa="eza -a -l -g --hyperlink --group-directories-first --icons -t modified"
alias mc='watch -n 1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias mpv='io.mpv.Mpv'
alias nt="nvim $HOME/Documents/linuxnotes.txt"
alias sc="nvim $HOME/Documents/utilityscripts.sh"
alias tp="watch -n 1 sensors"
alias ud="paru -Syu"
alias v="nvim"

function rr() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

if [[ "$(tty)" =~ "/pts/" ]]; then
  eval "$(starship init zsh)"
  fastfetch
fi
