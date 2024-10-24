source $HOME/.config/zsh/keybindings
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export FZF_ALT_C_COMMAND="fd -H --type d"
export FZF_CTRL_T_COMMAND="fd -H --type f"
export FZF_DEFAULT_COMMAND="fd -H --type f"
export FZF_DEFAULT_OPTS="\
    --color=bg+:#1f2335 \
    --color=bg:#1f2335 \
    --color=border:#41a6b5 \
    --color=fg:#c0caf5 \
    --color=gutter:#1f2335 \
    --color=header:#ff9e64 \
    --color=hl+:#41a6b5 \
    --color=hl:#41a6b5 \
    --color=info:#565f89 \
    --color=marker:#c53b53 \
    --color=pointer:#c53b53 \
    --color=prompt:#41a6b5 \
    --color=query:#c0caf5:regular \
    --color=scrollbar:#41a6b5 \
    --color=separator:#ff9e64 \
    --color=spinner:#c53b53 \
    --height 75% \
    --layout=default"
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LESSHISTFILE=-
export MANROFFOPT=-c
export SUDO_EDITOR="nvim"
export TERM="kitty"
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

alias ad="age -d -o"
alias ae="age -e -p -o"
alias cat="bat -p"
alias dg="/usr/bin/git --git-dir=$HOME/.dotz/ --work-tree=$HOME"
alias f='handlr open $(fzf) && exit'
alias ls="eza -l -g --hyperlink --group-directories-first --icons -t modified"
alias lsa="eza -a -l -g --hyperlink --group-directories-first --icons -t modified"
alias mc='watch -n 1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias mpv='io.mpv.Mpv'
alias nt="nvim $HOME/Documents/linuxnotes.txt"
alias pp="pipes.sh -p 9 -t 0 -r 20000 -c 1 -c 2 -c 3 -c 4 -c 5 -c 6 -c 7"
alias sc="nvim $HOME/Documents/shellscripts.sh"
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
