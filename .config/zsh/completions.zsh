OSTYPE=$(uname -s)
if [[ $OSTYPE == Darwin* ]]; then
  (( $+commands[orbctl] )) && source <(orbctl completion zsh)
fi
alias st='open -a SourceTree'
