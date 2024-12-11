# empty file

is_stripe = Dir.exist?("/Applications/Santa.app")

# Core
brew "fd"
brew "readline"
brew "ripgrep"
brew "wget"
brew "xz"

# Git
brew "diff-so-fancy"
brew "gh" if OS.mac?
brew "git"
brew "go-jira" if OS.mac?
brew "lazygit"

# Ruby
brew "openssl"
brew "rbenv"
brew "ruby-build"

if OS.mac?
  if !is_stripe
    brew "restic"
  end
end

# vim: set ft=ruby
