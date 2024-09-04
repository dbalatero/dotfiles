{ config, pkgs, ... }:

let
  dotfile = x: "${config.home.homeDirectory}/.dotfiles/${x}";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dbalatero";
  home.homeDirectory = "/home/dbalatero";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    diff-so-fancy
    direnv
    eza
    fasd
    fzf
    git
    gitstatus
    hostname
    lazygit
    less
    neofetch
    neovim
    ripgrep
    starship
    zsh
  ];

  home.file = {
    ".local/bin".source = (dotfile "bin");

    # Git stuff
    ".gitattributes".source = (dotfile "git/gitattributes");
    ".gitconfig".source = (dotfile "git/gitconfig");
    ".gitignore".source = (dotfile "git/gitignore");
    ".gitmessage".source = (dotfile "git/gitmessage");

    ".gitconfig.user".text = ''
      [github]
        user = dbalatero

      [user]
        name = David Balatero
	email = dbalatero@users.noreply.github.com
      '';

    # ZSH stuff
    ".config/starship.toml".source = (dotfile "zsh/starship.toml");
    ".inputrc".source = (dotfile "inputrc");
    ".profile".source = (dotfile "profile");
    ".zsh".source = (dotfile "zsh");
    ".zshenv".source = (dotfile "zsh/zshenv");
    ".zprofile".source = (dotfile "zsh/zprofile");
    ".zshrc".source = (dotfile "zshrc");
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dbalatero/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
