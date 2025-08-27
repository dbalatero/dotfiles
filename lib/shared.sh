function command_exists() {
  local name=$1

  command -v "$name" >/dev/null 2>&1
}

function source_if_exists() {
  local file
  file="$1"

  [ -f "$file" ] && source "$file"
}

# function source_if_exists() {
#   local file="$1"
#   if [ -f "$file" ]; then
#     echo "Sourcing $file..."
#     local start=$(($(date +%s%N)/1000000))
#     source "$file"
#     local end=$(($(date +%s%N)/1000000))
#     echo "Sourced $file in $((end-start))ms"
#   fi
# }

_symlinks_current_dir="${BASH_SOURCE%/*}"

function dotfiles_location() {
  cd "$_symlinks_current_dir/.." && pwd
}

function symlink_dotfile() {
  local file="$1"
  local destination="$2"

  local full_file_path
  full_file_path="$(dotfiles_location)/$file"

  if [ ! -e "$destination" ]; then
    echo "Symlinking $full_file_path -> $destination"
    mkdir -p "$(dirname "$destination")"
    ln -s "$full_file_path" "$destination"
  fi
}

function ensure_git_clone() {
  local repo="$1"
  local destination="$2"

  if [ ! -d "$destination" ]; then
    git clone "$repo" "$destination"
  fi
}

function is_stripe_laptop() {
  [ -e "/Applications/Santa.app" ]
}

IS_STRIPE_DEVBOX="false"
if [[ -v STRIPE_USER ]]; then
  IS_STRIPE_DEVBOX="true"
fi

function is_stripe_devbox() {
  [[ "$IS_STRIPE_DEVBOX" == "true" ]]
}

function is_stripe_machine() {
  is_stripe_laptop || is_stripe_devbox
}

function xdg_config_dir() {
  echo "${XDG_CONFIG_HOME:-$HOME/.config}"
}

function xdg_data_dir() {
  echo "${XDG_DATA_HOME:-$HOME/.local/share}"
}

_current_os="$(uname)"

function is_macos() {
  [[ "$_current_os" == "Darwin" ]]
}

function is_linux() {
  [[ "$_current_os" == "Linux" ]]
}

function is_arch_linux() {
  [ -f /etc/arch-release ]
}
