set -euo pipefail

git fetch
git checkout -q master

BRANCHES="$(git branch --no-color --merged | grep -v '\\* master')"

# If there are no branches to delete, don't do anything.
if [ -z "$BRANCHES" ]; then
  echo "There are no branches to delete. 😎"
  exit 0
fi

echo "$BRANCHES" | xargs -n 1 git branch -d
