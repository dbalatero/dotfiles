# Usage:
#
#   copy_and_reset_repo ~/code/typescript-interview ~/code/company/some-problem
#
function copy_and_reset_repo() {
  local repo="$1"
  local destination="$2"

  if [ -z "$repo" ] || [ -z "$destination" ]; then
    echo "Usage: copy_and_reset_repo [source_repo] [destination]"
    echo
    echo "This copies an existing repo to a destination, and resets its Git"
    echo "history back to an initial commit."
    return 1
  fi

  if [ ! -d "$repo/.git" ]; then
    echo "Error: $repo is not a valid Git repository to copy from."
    return 1
  fi

  local destination_parent=$(dirname "$destination")
  echo "=> Ensuring $destination_parent exists..."
  mkdir -p "$destination_parent"

  echo "=> Copying repo to destination"
  cp -r "$repo" "$destination"

  echo "=> Removing the .git directory from copy"
  rm -fr "$destination/.git"

  echo "=> Re-initializing git to an initial commit"
  cd "$destination" && git init && git add . && git commit -m "Initial commit"
}
