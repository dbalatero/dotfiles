function command_exists() {
  local name=$1

  command -v "$name" >/dev/null 2>&1
}
