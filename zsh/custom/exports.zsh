# Editor
export EDITOR=nvim
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# Path
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"

# OpenSSL
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

if command -v yarn >/dev/null 2>&1; then
  export PATH="$PATH:`yarn global bin`"
fi

export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="./node_modules/.bin:$PATH"
export PATH="~/.fzf/bin:$PATH"
export PATH="$PATH:$HOME/.config/base16-shell"

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"

export RESTIC_REPOSITORY="b2:dbalatero-backup"
export SYNC_REPO="$RESTIC_REPOSITORY:/Sync"
export FREEZE_REPO="$RESTIC_REPOSITORY:/Freeze"

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --exclude node_modules --color=always'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--ansi"
