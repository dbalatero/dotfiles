function command_exists() {
  local name=$1

  command -v "$name" >/dev/null 2>&1
}

# _symlinks_current_dir="${BASH_SOURCE%/*}"

# function dotfiles_location() {
#   echo $(cd $_symlinks_current_dir/../.. && pwd)
# }

function dotfiles_location() {
  # Fix this
  echo "$HOME/stripe/dotfiles"
}

function symlink_dotfile() {
  local file=$1
  local destination=$2
  local full_file_path="$(dotfiles_location)/$file"

  if [ ! -e "$destination" ]; then
    echo "Symlinking $full_file_path -> $destination"
    mkdir -p "$(dirname "$destination")"
    ln -s "$full_file_path" "$destination"
  fi
}

function is_stripe_laptop() {
  [ -e "/Applications/Santa.app" ]
}

function is_stripe_machine() {
  is_stripe_laptop
}

function xdg_config_dir() {
  echo "$HOME/.config"
}
