set -e
REPO_ROOT=$(git rev-parse --show-toplevel)

if [[ -f "$REPO_ROOT/.git/refs/heads/main" || -f "$REPO_ROOT/.git/refs/remotes/origin/main" ]]; then
  echo "main"
elif [[ -f "$REPO_ROOT/.git/refs/heads/master" || -f "$REPO_ROOT/.git/refs/remotes/origin/master" ]]; then
  echo "master"
else
  echo "unknown"
  exit 1
fi
