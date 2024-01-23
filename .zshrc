# Zsh configuration

### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode depth"1" for \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl

### End of Zinit's installer chunk

# Oh My Zsh
zinit for \
      OMZL::correction.zsh \
      OMZL::directories.zsh \
      OMZL::history.zsh \
      OMZL::key-bindings.zsh \
      OMZL::theme-and-appearance.zsh \
      OMZP::common-aliases

zinit wait lucid for \
      OMZP::colored-man-pages \
      OMZP::cp \
      OMZP::extract \
      OMZP::fancy-ctrl-z \
      OMZP::git \
      OMZP::sudo

# Completion enhancements

# FZF: fuzzy finderls
if [[ $OSTYPE == darwin* ]]; then
    FZF="$(brew --prefix)/opt/fzf/shell"
elif (( $+commands[apt-get] )); then
    FZF="/usr/share/doc/fzf/examples"
else
    FZF="/usr/share/fzf"
fi

if [[ -f "$FZF/completion.zsh" ]]; then
    source "$FZF/completion.zsh"
fi

if [[ -f "$FZF/key-bindings.zsh" ]]; then
    source "$FZF/key-bindings.zsh"
fi
zinit wait lucid light-mode depth=1 nocd for \
    atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' zdharma-continuum/fast-syntax-highlighting \
    atload='_zsh_autosuggest_start' zsh-users/zsh-autosuggestions \
    atload='MODE_CURSOR_VIINS="bar"; vim-mode-cursor-init-hook' softmoth/zsh-vim-mode \
    Aloxaf/fzf-tab

zinit wait lucid light-mode depth"1" for \
      djui/alias-tips \
      zsh-users/zsh-history-substring-search \
      hlissner/zsh-autopair

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Theme
zinit ice depth=1 atload"!source ~/.p10k.zsh" lucid nocd
        zinit light romkatv/powerlevel10k

#
# Utilities
#

# Z
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
    export _ZO_FZF_OPTS="$_FZF_DEFAULT_OPTS --select-1"
else
    zinit ice wait lucid depth"1"
    zinit light agkozak/zsh-z
fi

# Git extras
zinit ice wait lucid as"program" pick"$ZPFX/bin/git-*" src"etc/git-extras-completion.zsh" make"PREFIX=$ZPFX" if'(( $+commands[make] ))'
zinit light tj/git-extras

# Prettify ls
if (( $+commands[gls] )); then
    alias ls='gls --color=tty --group-directories-first'
else
    alias ls='ls --color=tty --group-directories-first'
fi

# Homebrew completion
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# OS bundles
if [[ $OSTYPE == darwin* ]]; then
    zinit snippet PZTM::osx
    if (( $+commands[brew] )); then
        alias bu='brew update; brew upgrade; brew cleanup'
        alias bcu='brew cu --all --yes --cleanup'
        alias bua='bu; bcu'
    fi
elif [[ $OSTYPE == linux* ]]; then
    if (( $+commands[apt-get] )); then
        zinit snippet OMZP::ubuntu
        alias agua='aguu -y && agar -y && aga -y'
        alias kclean+='sudo aptitude remove -P "?and(~i~nlinux-(ima|hea),\
                            ?not(?or(~n`uname -r | cut -d'\''-'\'' -f-2`,\
                            ~nlinux-generic,\
                            ~n(linux-(virtual|headers-virtual|headers-generic|image-virtual|image-generic|image-`dpkg --print-architecture`)))))"'
    elif (( $+commands[pacman] )); then
        zinit snippet OMZP::archlinux
    fi
fi

#
# Aliases
#

# General
alias cz="$EDITOR $HOME/.zshrc"
alias lz=". $HOME/.zshrc"
alias h='history'
alias c='clear'

# Modern Unix commands
# See https://github.com/ibraheemdev/modern-unix
if (( $+commands[eza] )); then
    alias ls='eza --color=auto --icons --group-directories-first'
    alias tree='ls --tree'
elif (( $+commands[exa] )); then
    alias ls='exa --color=auto --icons --group-directories-first'
    alias la='ls -laFh'
    alias tree='ls --tree'
fi

(( $+commands[bat] )) && alias cat='bat -p --wrap character'
(( $+commands[fd] )) && alias find=fd
(( $+commands[btm] )) && alias top=btm
(( $+commands[rg] )) && alias grep=rg
(( $+commands[tldr] )) && alias help=tldr
(( $+commands[delta] )) && alias diff=delta
(( $+commands[duf] )) && alias df=duf
(( $+commands[dust] )) && alias du=dust
(( $+commands[hyperfine] )) && alias benchmark=hyperfine
(( $+commands[gping] )) && alias ping=gping
(( $+commands[difft] )) && alias diff=difft

# Proxy
PROXY=http://127.0.0.1:7890         # ss:1088, vr:8001
NO_PROXY=10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1
alias showproxy='echo "proxy=$http_proxy"'
if [[ -f $HOME/.proxyman/proxyman_env_automatic_setup.sh ]]; then
  alias setproxy="source $HOME/.proxyman/proxyman_env_automatic_setup.sh"
  alias unsetproxy="source $HOME/.proxyman/proxyman_env_automatic_unset.sh"
else
  alias setproxy='export http_proxy=$PROXY; export https_proxy=$PROXY; export no_proxy=$NO_PROXY; showproxy'
  alias unsetproxy='export http_proxy=; export https_proxy=; export all_proxy=; export no_proxy=; showproxy'
fi

# Local customizations, e.g. theme, plugins, aliases, etc.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local || true

# alias
source $HOME/.config/zsh/aliases.zsh
