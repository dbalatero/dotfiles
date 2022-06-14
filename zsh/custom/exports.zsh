# Tmux UTF8 support
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# enable git scripts
export DEVELOPMENT_DIRECTORY="$HOME/code"

# FZF
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!{node_modules/*,.git/*}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Editor
export EDITOR=nvim
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# OpenSSL
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# Path
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"

export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="./node_modules/.bin:$PATH"
export PATH="$PATH:$HOME/.config/base16-shell"

export DOOMDIR=$HOME/.doom.d
export PATH="$PATH:$HOME/.emacs.d/bin"

# Cargo
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env

# Python
[[ "$(uname)" == "Darwin" ]] && export PYTHON_CONFIGURE_OPTS="--enable-framework"
[[ "$(uname)" == "Linux" ]] && export PYTHON_CONFIGURE_OPTS="--enable-shared"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Restic/Backblaze
# restic mount -r $SYNC_REPO ~/backblaze
export RESTIC_REPOSITORY="b2:dbalatero-backup"
export SYNC_REPO="$RESTIC_REPOSITORY:/Sync"
export FREEZE_REPO="$RESTIC_REPOSITORY:/Freeze"

# Yarn
if command -v yarn >/dev/null 2>&1; then
  export PATH="$PATH:`yarn global bin`"
fi

# Don't be helpful
export HOMEBREW_NO_AUTO_UPDATE=1

# brew mac m1
export PATH=/opt/homebrew/bin:$PATH

# dotfiles
export PATH=$PATH:$HOME/.dotfiles/bin
