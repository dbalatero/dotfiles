#!/usr/bin/env bash

item=$1
subcommand=${2:-show}

function print_usage() {
  echo "Usage: daily [item] [command]"
  echo
  echo "Commands"
  echo "--------"
  echo " * daily [item] add [amount]"
  echo "   Adds [amount] to today's daily count."
  echo "   Example, add 16oz of water: $ daily water add 16"
  echo
  echo " * daily [item] reset"
  echo "   Resets today's count to 0"
  echo
  echo " * daily [item] show"
  echo "   Returns the current count for [item] for today."
  echo
  echo " * daily [item] updated"
  echo "   Returns how many seconds it's been since you last updated the counter."
}

function print_error() {
  echo "ERROR: $1"
  echo
  print_usage
  exit 1
}

if [ -z "$item" ]; then
  print_usage && exit 1
fi

function is_int() {
  test "$@" -eq "$@" 2>/dev/null
}

function last_modified_seconds() {
  echo "$(($(date +%s) - $(stat -f%c "$1")))"
}

function add_amount() {
  local item=$1
  local amount=$2

  if [ -z "$amount" ]; then
    print_error "missing amount"
  fi

  if ! is_int "$amount"; then
    print_error "amount must be an integer"
  fi

  local item_dir="$HOME/.daily/items/$item/history"
  mkdir -p "$item_dir"

  local daily_file="$item_dir/$(date '+%Y-%m-%d')"

  if [ -f "$daily_file" ]; then
    # Add to the value
    local current_value=$(cat "$daily_file")
    local new_value=$(echo "$current_value + $amount" | bc)

    # Write it back
    echo "$new_value" >"$daily_file"

    echo $new_value
  else
    # Start a new file
    echo "$amount" >"$daily_file"

    echo $amount
  fi
}

function reset_amount() {
  local item=$1

  local item_dir="$HOME/.daily/items/$item/history"
  mkdir -p $item_dir

  local daily_file="$item_dir/$(date '+%Y-%m-%d')"

  echo "0" >"$daily_file"
  echo "Reset $item's amount to 0"
}

function show_amount() {
  local item=$1

  local item_dir="$HOME/.daily/items/$item/history"
  local daily_file="$item_dir/$(date '+%Y-%m-%d')"

  if [ -f "$daily_file" ]; then
    cat "$daily_file"
  else
    echo 0
  fi
}

function updated_amount() {
  local item=$1

  local item_dir="$HOME/.daily/items/$item/history"
  local daily_file="$item_dir/$(date '+%Y-%m-%d')"

  if [ -f "$daily_file" ]; then
    echo $(last_modified_seconds "$daily_file")
  else
    # return high value, 24hrs, whatever
    echo 86400
  fi
}

case $subcommand in
add)
  amount=$3
  add_amount "$item" "$amount"
  ;;
reset)
  reset_amount "$item"
  ;;
show)
  show_amount "$item"
  ;;
updated)
  updated_amount "$item"
  ;;
*)
  print_error "Invalid command"
  ;;
esac
