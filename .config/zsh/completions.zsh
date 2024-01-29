OSTYPE=$(uname -s)
if [[ $OSTYPE == Darwin* ]]; then
  (( $+commands[orbctl] )) && source <(orbctl completion zsh)
fi
