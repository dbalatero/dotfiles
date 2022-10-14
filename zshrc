# ======== Cache directory (for oh-my-zsh plugins) =========
[ ! -d $HOME/.zcustom/cache ] && mkdir -p $HOME/.zcustom/cache

export ZSH="$HOME/.zcustom"
export ZSH_CACHE_DIR="$ZSH/cache"

# ======== Random settings ===========

# Disable auto title so tmux window titles don't get messed up.
export DISABLE_AUTO_TITLE="true"

# Maintain a stack of cd directory traversals for `popd`
setopt AUTO_PUSHD

# Allow extended matchers like ^file, etc
set -o EXTENDED_GLOB

# ========= History settings =========
if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt inc_append_history
setopt share_history # share command history data
setopt extended_glob

# =========== Plugins ============
source $HOME/.zsh/vendor/antigen.zsh

antigen bundle robbyrussell/oh-my-zsh plugins/git

if [ ! -f ~/.config/dotfiles/no-nvm ]; then
  antigen bundle robbyrussell/oh-my-zsh plugins/nvm
fi

antigen bundle robbyrussell/oh-my-zsh plugins/pyenv

if [ ! -f ~/.config/dotfiles/rbenv ]; then
  antigen bundle robbyrussell/oh-my-zsh plugins/rvm
else
  antigen bundle robbyrussell/oh-my-zsh plugins/rbenv
fi

antigen bundle robbyrussell/oh-my-zsh plugins/vi-mode

antigen bundle dbalatero/fzf-git
antigen bundle DarrinTisdale/zsh-aliases-exa
antigen bundle chriskempson/base16-shell
antigen bundle wookayin/fzf-fasd
antigen bundle twang817/zsh-ssh-agent
antigen bundle zsh-users/zsh-completions
antigen bundle dbalatero/fast-syntax-highlighting
antigen bundle hlissner/zsh-autopair

antigen theme romkatv/powerlevel10k

antigen apply

source ~/.base16_theme

eval "$(direnv hook zsh)"
eval "$(fasd --init auto)"
eval "$(nodenv init -)"

# =========== Custom settings ================

for file in $HOME/.zsh/custom/**/*.zsh
do
  source $file
done

source $HOME/.zsh/themes/original.zsh

for file in $HOME/.zsh/secrets/**/*.zsh
do
  source $file
done

# ======= RVM is a special snowflake and needs to be last ========
if [ ! -f ~/.config/dotfiles/rbenv ]; then
  export PATH="$HOME/.rvm/bin:$PATH"
  [ -f ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
