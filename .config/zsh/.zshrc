source ~/.config/zsh/keybindings
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export EDITOR='$VISUAL'
export FZF_ALT_C_COMMAND='find . -type d'
export FZF_ALT_C_OPTS='--layout=default'
export FZF_CTRL_T_COMMAND='find .'
export FZF_CTRL_T_OPTS='--layout=default'
export FZF_DEFAULT_COMMAND='find .'
export FZF_DEFAULT_OPTS='--layout=default'
export LESSHISTFILE=-
export SUDO_EDITOR=nvim
export VISUAL=nvim

# auto/tab completion:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.

# history
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt autocd
setopt rmstarsilent

alias dg='/usr/bin/git --git-dir=$HOME/.dotz/ --work-tree=$HOME'
alias ds='rm /home/pw/.local/share/nvim/swap/*'
alias f='handlr open $(fzf)'
alias ls='exa -l -g --group-directories-first --icons -t modified'
alias lsa='exa -a -l -g --group-directories-first --icons -t modified'
alias mc='watch -n 1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias mg='radeontop -c'
alias nt='nvim $HOME/Documents/linuxnotes.txt'
alias pm='mpv --no-video'
alias rr='ranger'
alias sc='nvim $HOME/Documents/shellscripts.sh'
alias tp='watch -n 1 sensors'
alias v='nvim'

eval "$(starship init zsh)"

cutefetch --bunny
