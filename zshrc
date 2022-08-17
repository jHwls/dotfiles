# asdf script
. $(brew --prefix asdf)/libexec/asdf.sh

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -U promptinit; promptinit
prompt pure

source $HOME/repos/dotfiles/aliases

# The next line updates PATH for Netlify's Git Credential Helper.
if [ -f '~/.netlify/helper/path.zsh.inc' ]; then source '~/.netlify/helper/path.zsh.inc'; fi

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

export PATH=/opt/homebrew/Caskroom/redis-stack-server/6.26.0/bin:$PATH
export ERL_AFLAGS="-kernel shell_history enabled"
