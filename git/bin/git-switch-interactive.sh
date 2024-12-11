git switch $(git branch --sort=-committerdate --format "%(refname:short)" | fzf)
