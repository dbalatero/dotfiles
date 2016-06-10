ms() { bash -c "cd ~/code/mariners && ./scoreboard $@" }

alias dbm="rake db:migrate && rake db:test:prepare"
alias ole="bin/open_last_error"

zroute() { zeus rake routes | ag $@ }

ctags_refresh() {
  ctags -R .
  ctags -R -f ./.git/tags
}
