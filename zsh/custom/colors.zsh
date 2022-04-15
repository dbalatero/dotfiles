function theme_colors() {
  for code ({000..255}) print -P -- \
    "$code: %F{$code}This is how your text would look like%f"
}

if [[ $(hostname -s) = st-* ]]; then
  export GITSTATUS_DAEMON=$HOME/.nix-profile/bin/gitstatusd
fi
