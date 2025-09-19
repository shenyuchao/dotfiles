# ~/.config/zsh/aliases.zsh
# Zsh aliases configuration

# General
alias edc="$EDITOR $HOME/.zshrc; $EDITOR $HOME/.zshrc.local"

# Modern Unix commands
if (( $+commands[eza] )); then
    alias ls='eza --color=auto --icons --group-directories-first'
    alias l='ls -lhF'
    alias la='ls -lhAF'
    alias tree='ls --tree'
elif (( $+commands[exa] )); then
    alias ls='exa --color=auto --icons --group-directories-first'
    alias l='ls -lhF'
    alias la='ls -lahF'
    alias tree='ls --tree'
else
    alias ls='ls --color=tty --group-directories-first'
fi
(( $+commands[bat] )) && alias cat='bat -p --wrap character'
(( $+commands[fd] )) && alias find=fd
if (( $+commands[btop] )); then
    alias top=btop
elif (( $+commands[btm] )); then
    alias top=btm
fi
(( $+commands[rg] )) && alias grep=rg
(( $+commands[tldr] )) && alias help=tldr
(( $+commands[delta] )) && alias diff=delta
(( $+commands[duf] )) && alias df=duf
(( $+commands[dust] )) && alias du=dust
(( $+commands[hyperfine] )) && alias benchmark=hyperfine
(( $+commands[gping] )) && alias ping=gping
(( $+commands[paru] )) && alias yay=paru
(( $+commands[nvim] )) && alias vim=nvim

# Git
alias gtr='git tag -d $(git tag) && git fetch --tags'

# Ripgrep integration
function rgv () {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi --height 80% --tmux 100%,80% \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(emacsclient -c -nw -a "vim" +{2} {1} || vim {1} +{2})'
}

# Proxy settings
PROXYMAN_ENV_FILE="$HOME/Library/Application Support/com.proxyman.NSProxy-setapp/app-data/proxyman_env_automatic_setup.sh"
if [[ -f "$PROXYMAN_ENV_FILE" ]]; then
    alias setproxy='set -a 2>/dev/null || true; source "$PROXYMAN_ENV_FILE"; set +a 2>/dev/null || true'
    alias unsetproxy='unset http_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY && echo "Proxyman proxy disabled"'
else
    PROXY=http://127.0.0.1:7897
    NO_PROXY=10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1
    alias showproxy='echo "proxy=$http_proxy"'
    alias setproxy='export http_proxy=$PROXY; export https_proxy=$PROXY; all_proxy=$PROXY; export no_proxy=$NO_PROXY; showproxy'
    alias unsetproxy='export http_proxy=; export https_proxy=; export all_proxy=; export no_proxy=; showproxy'
    alias toggleproxy='if [ -n "$http_proxy" ]; then unsetproxy; else setproxy; fi'
fi

# Homebrew completion
if (( $+commands[brew] )); then
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

# Upgrade
alias upgrade_repo='git pull --rebase --stat origin master'
alias upgrade_dotfiles='cd $DOTFILES && upgrade_repo; cd - >/dev/null'
alias upgrade_omt='cd $HOME/.tmux && upgrade_repo; cd - >/dev/null'
alias upgrade_zinit='zinit self-update && zinit update -a -p && zinit compinit'

(( $+commands[cargo] )) && alias upgrade_cargo='cargo install cargo-update; cargo install-update -a'
(( $+commands[gem] )) && alias upgrade_gem='gem update && gem cleanup'
(( $+commands[go] )) && alias upgrade_go='$DOTFILES/install_go.sh'
(( $+commands[npm] )) && alias upgrade_npm='for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do npm -g install "$package"; done'
(( ! $+commands[brew] )) && (( $+commands[pip] )) && alias upgrade_pip="pip list --outdated --format=json | python -c '
import json
import sys

for item in json.loads(sys.stdin.read()):
    print(\"=\".join([item[\"name\"], item[\"latest_version\"]]))
' | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
(( ! $+commands[brew] )) && (( $+commands[pip3] )) && alias upgrade_pip3="pip3 list --outdated --format=json | python3 -c '
import json
import sys

for item in json.loads(sys.stdin.read()):
    print(\"=\".join([item[\"name\"], item[\"latest_version\"]]))
' | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"
(( $+commands[brew] )) && alias upgrade_brew='brew bundle --global; bua'
