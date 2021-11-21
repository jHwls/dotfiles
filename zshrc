# asdf script
. /opt/homebrew/opt/asdf/libexec/asdf.sh

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -U promptinit; promptinit
prompt pure

source $HOME/repos/dotfiles/aliases
