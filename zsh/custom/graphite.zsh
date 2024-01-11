function gt_user() {
  local username="$1"
  local user_config_dir="$HOME/.config/graphite-$username"
  local config_dir="$HOME/.config/graphite"

  if [ -e "$config_dir" ] && [ ! -L "$config_dir" ]; then
    echo "$config_dir already exists, but is not a symlink. You probably have"
    echo "an existing configuration directory. To fix this, run:"
    echo
    echo "  mv \"$config_dir\" \"$config_dir-<your username>\""
    echo
    echo "and replace <your username> with your actual GitHub username."
  fi

  if [ ! -d "$user_config_dir" ]; then
    echo "Invalid username: $username ($user_config_dir)"
    exit 1
  fi

  # remove symlink if it exists
  if [ -L "$config_dir" ]; then
    rm "$config_dir"
  fi

  ln -s "$user_config_dir" "$config_dir"

  echo "✔ Updated Graphite config to point at $user_config_dir"
}

function vigt() {
  vim "$HOME/.config/graphite/user_config"
}
