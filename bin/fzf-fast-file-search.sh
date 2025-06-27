#!/usr/bin/env bash

# Function to get the current directory or git repo root
function get_context_path() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ $? -eq 0 ]; then
    echo "$git_root"
  else
    echo "$PWD"
  fi
}

# Use XDG_CACHE_HOME if set, otherwise default to ~/.cache
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/fast-fzf"
context_path=$(get_context_path)
cache_file="$cache_dir/$(echo "$context_path" | sed 's/\//_/g')_cache"

# Ensure cache directory exists
mkdir -p "$cache_dir"

# Function to perform the expensive search
function expensive_search() {
  rg --files --hidden --glob '!{node_modules/*,.git/*}'
}

# Create a temporary file to store new results
temp_results=$(mktemp)

# Function to handle cleanup
function cleanup() {
  (
    # Kill the background rg process if it's still running
    kill $rg_pid 2>/dev/null

    # Kill the tail process
    kill $tail_pid 2>/dev/null

    # Sort and unique the results, then write to cache file
    sort -u "$temp_results" "$cache_file" > "${cache_file}.tmp"
    mv "${cache_file}.tmp" "$cache_file"

    # Remove the temporary file
    rm "$temp_results"
  ) &
  disown
}

# Set up trap to ensure cleanup happens
trap cleanup EXIT

# Output cached results immediately if they exist
if [[ -f "$cache_file" ]]; then
  cat "$cache_file"
fi

# Start the expensive search in the background
expensive_search > "$temp_results" &
rg_pid=$!

# Stream new results as they come in
tail -f "$temp_results" &
tail_pid=$!

# Wait for the expensive search to complete
wait $rg_pid

# Kill the tail process as we're done streaming results
kill $tail_pid 2>/dev/null

# Cleanup is handled by the trap and will run in the background
