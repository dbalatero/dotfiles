set -euo pipefail

# NOTE: There's a faster way to find Git repositories, but this works for nested repos.
# https://unix.stackexchange.com/questions/333862/how-to-find-all-git-repositories-within-given-folders-fast
find "$DEVELOPMENT_DIRECTORY" -type d -name .git -print -prune | sed 's/\/\.git//g'

