source $HOME/.config/zsh/keybindings
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export FZF_ALT_C_COMMAND="fd -H --type d"
export FZF_CTRL_T_COMMAND="fd -H --type f"
export FZF_DEFAULT_COMMAND="fd -H --type f"
export FZF_DEFAULT_OPTS="\
  --color=bg+:#282828 \
  --color=bg:#282828 \
  --color=border:#458588 \
  --color=fg:#fbf1c7 \
  --color=gutter:#282828 \
  --color=header:#ffb86c \
  --color=hl+:#458588 \
  --color=hl:#458588 \
  --color=info:#a89984\
  --color=marker:#cc241d \
  --color=pointer:#cc241d \
  --color=prompt:#458588 \
  --color=query:#fbf1c7:regular \
  --color=scrollbar:#458588 \
  --color=separator:#ffb86c \
  --color=spinner:#cc241d \
  --height 75% \
  --layout=default"
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LESSHISTFILE=-
export MANPAGER="nvim +Man!"
export PATH="$HOME/.local/bin:$PATH"
export SUDO_EDITOR="nvim"
export TERM="ghostty"
export VISUAL="nvim"

# Vi key binding
bindkey -v

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
alias backup="$HOME/.local/bin/backup.sh"
alias cat="bat -p"
alias ctc="$HOME/.local/bin/copy-to-control.sh"
alias dcp="$HOME/.local/bin/delete-chromium-profile.sh"
alias dg="/usr/bin/git --git-dir=$HOME/.dotz/ --work-tree=$HOME"
alias dotoff="$HOME/.local/bin/dotoff.sh"
alias doton="$HOME/.local/bin/doton.sh"
alias f='handlr open $(fzf) && exit'
alias hfs="$HOME/.local/bin/hyprland-from-source.sh"
alias ls="eza -l -g --hyperlink --group-directories-first --icons -t modified"
alias lsa="eza -a -l -g --hyperlink --group-directories-first --icons -t modified"
alias mc='watch -n 1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias mpv='io.mpv.Mpv'
alias nt="nvim $HOME/Documents/linuxnotes.txt"
alias osp="$HOME/.local/bin/ollama-stop.sh"
alias ost="$HOME/.local/bin/ollama-start.sh"
alias rha="$HOME/.local/bin/rebuild-hyprland-aur.sh"
alias rs="$HOME/.local/bin/ripgrep-search.sh"
alias rup="$HOME/.local/bin/remove-unneeded-packages.sh"
alias sbk="$HOME/.local/bin/sync-backup.sh"
alias tp="watch -n 1 sensors"
alias uom="$HOME/.local/bin/update-ollama-models.sh"
alias upo="$HOME/.local/bin/update-podman-ollama.sh"
alias v="nvim"
alias wf="sudo systemctl stop NetworkManager.service"
alias wo="sudo systemctl start NetworkManager.service"

function rr() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if [[ $? -ne 0 ]]; then
    echo "Error running yazi"
    return 1
  fi
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

if [[ "$(tty)" =~ "/pts/" ]]; then
  eval "$(starship init zsh)"
  fastfetch
fi
