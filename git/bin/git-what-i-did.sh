set -euo pipefail

# Prints the commits since the given time period.
if [ "$#" -eq 0 ]; then
  >&2 echo "Usage: git-what-i-did [git-log-options...]"
  exit 1
fi

# TODO: I've explicitly turned on coloring for this command because GIT isn't smart enough to
# detect TTY when the command is piped through sort. In the future, I should probably check the
# output manually for this script and set the value dynamically.
GIT_USER=$(git config user.name)
RESULT=$(
  while read -r git_directory; do
    REPO=$(basename "$git_directory")

    git \
      --git-dir "$git_directory/.git" \
      --no-pager \
      log \
      "$@" \
      --all \
      --author="$GIT_USER" \
      --date=format:'%Y-%m-%d %H:%M:%S' \
      --format="[%Cblue%ad%Creset] %Cgreen$REPO%Creset %s (%Cred%h%Creset)"

  done <<< "$(git local-repos)" | sort -r | grep -v "Initial commit"
)

# Display the result in less if it's long enough
echo "$RESULT" | less -X -F
