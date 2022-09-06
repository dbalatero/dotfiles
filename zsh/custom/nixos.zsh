NIX_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh"

[ -f "$NIX_SCRIPT" ] && source "$NIX_SCRIPT"

HOME_MANAGER_SCRIPT="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

[ -f "$HOME_MANAGER_SCRIPT" ] && source "$HOME_MANAGER_SCRIPT"

NIX_SSHOPTS='source ~/.zshrc;'
export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels

# Modern way??!?!
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
