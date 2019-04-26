alias vim="nvim"

alias l="ls -al"
alias tn="rvm . do tmuxinator"
alias tk="tmux kill-session"
alias work="cd ~/code/boundless && tn start boundless"
alias word="cd ~/code/boundless && tn start wordpress"
alias mobile="cd ~/code/boundless && tn start mobile"
alias dbm="rake db:migrate && RAILS_ENV=test rake db:migrate"
alias less="less -r"

alias b="aid begin"
alias bs="./bin/rspec"
alias bat="open -a 'Adobe Acrobat' $@"

alias md="open -a Markoff $@"

# Simple rsync
alias srync="rsync -vrazh"

alias G="spotify play uri https://open.spotify.com/track/1F9bmLBJ8VpXVadlxjafKM > /dev/null"
alias gd="g d"
alias gs="g s"

alias sketch="magick $1 \( -clone 0 -negate -blur 0x5 \) -compose colordodge -composite \
-modulate 100,0,100 -auto-level $2"

pgrefresh() {
  rm -fr /usr/local/var/postgres/postmaster.pid
  brew services restart postgresql
}

sslcert() {
  echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text
}
