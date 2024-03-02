source $HOME/.config/zsh/keybindings
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export FZF_ALT_C_COMMAND="fd -H --type d"
export FZF_ALT_C_OPTS="--height 100%"
export FZF_CTRL_T_COMMAND="fd -H --type f"
export FZF_DEFAULT_COMMAND="fd -H --type f"
export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,hl:#cba6f7,spinner:#f5e0dc \
    --color=fg:#cdd6f4,header:#cba6f7,info:#89b4fa,pointer:#f5e0dc \
    --color=fg+:#cdd6f4,hl+:#cba6f7,marker:#f5e0dc,prompt:#89b4fa \
    --layout=default"
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LESSHISTFILE=-
export MANROFFOPT=-c
export PF_COL3=6
export SUDO_EDITOR="nvim"
export VISUAL="nvim"

man() {
    LESS_TERMCAP_md=$'\e[01;34m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;0;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

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

alias cat="bat -p"
alias dg="/usr/bin/git --git-dir=$HOME/.dotz/ --work-tree=$HOME"
alias duf="duf -theme ansi"
alias f='handlr open $(fzf) && exit'
alias hh="Hyprland &>/dev/null"
alias ls="eza -l -g --group-directories-first --icons -t modified"
alias lsa="eza -a -l -g --group-directories-first --icons -t modified"
alias mc='watch -n 1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias mg="radeontop -c -T"
alias mpv="io.mpv.Mpv --hwdec=vaapi"
alias nt="nvim $HOME/Documents/linuxnotes.txt"
alias pp="pipes.sh -p 9 -t 0 -r 20000 -c 1 -c 2 -c 3 -c 4 -c 5 -c 6 -c 7"
alias rr="ranger"
alias sc="nvim $HOME/Documents/shellscripts.sh"
alias sus="systemctl suspend"
alias tp="watch -n 1 sensors"
alias v="nvim"

eval "$(starship init zsh)"

pfetch
