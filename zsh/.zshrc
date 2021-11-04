# Set my prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# Load my aliases 
[ -f ~/.config/aliases ] && source ~/.config/aliases


# History in cache directory
HISTFILE=~/.cache/zsh/zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Automatically cd into directories by just typing the directory name
setopt autocd

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)	
[ ! -d "$HOME/.cache/zsh" ] && mkdir "$HOME/.cache/zsh"
compinit -d "$HOME/.cache/zsh/zcompdump"


# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

### VIM mode config
# Summery:
#  Allows you to use press ESC and then use VIM keys to edit
#  the command currently have in the command line.
#  When you are in INSERT mode, the cursor is a beam and in 
#  NORMAL mode, the cursor is a BLOCK. This makes it easer for us
#  to know what mode we are in.

# Activate vim mode.
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Jump to beginning using H and the end using L in NORMAL mode
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

# Open current command line in vim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

# Prevent backspace key from not working: https://git.io/J48z9
bindkey "^?" backward-delete-char

# This brings the cursor back to the beam instead of the block cursor
_fix_cursor() {
   echo -ne '\e[5 q'
}

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
echo -ne '\e[5 q'

precmd_functions+=(_fix_cursor)


# Disable ctrl-s and ctrl-q because they for some reason
# freezes my terminal
stty -ixon 


# This file has some important variables
source $HOME/.zprofile
source $HOME/.zshenv

# Load my ZSH plugins
source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

# Search and install packages with yay and fzf
yi() {
	SELECTED_PKGS="$(yay -Slq | fzf --header='Install packages' -m --height 100% --preview 'yay -Si {1}')"
    [[ -n "$SELECTED_PKGS" ]] && yay -S "$SELECTED_PKGS"
}

# Search and remove packages with yay and fzf
yr() {
	SELECTED_PKGS="$(yay -Qsq | fzf --header='Remove packages' -m --height 100% --preview 'yay -Si {1}')"
    [[ -n "$SELECTED_PKGS" ]] && yay -Rns "$SELECTED_PKGS"
}

export PURE_PROMPT_SYMBOL="$"

PATH="/home/siddharth/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/siddharth/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/siddharth/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/siddharth/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/siddharth/perl5"; export PERL_MM_OPT;

# The 'cnf' command is needed. Check the 'bin' directory.
command_not_found_handler() {
    mkdir -p "/tmp/command_not_found"
    echo -n "$1" > "/tmp/command_not_found/command"

    echo "zsh: command not found: $1" && exit 1
}
