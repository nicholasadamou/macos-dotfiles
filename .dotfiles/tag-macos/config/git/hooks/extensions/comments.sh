#! /usr/bin/env bash

# Label: Comment Total
# Description: Print project comment total.
# Parameters: $1 (required) - The comment prefix to search for.
_comment_total() {
  local prefix="$1"
  local label="[comments]"
  local lines=("omit:0") # Ensures array is populated, with omitted total, in case Silver Searcher finds nothing.
  local total=0

  if ! command -v ag > /dev/null; then
     printf "%s" "$label: Silver Surfer not found. To install, run: brew install the_silver_searcher."
     exit 1
  fi

  lines+=($(ag --count --depth -1 --ignore "vendor" "^\s*?(#|--|//) $prefix" . || :))

  for line in ${lines[*]}; do
    total=$((total + ${line#*:}))
  done

  if [[ $total -gt 0 ]]; then
    _print_warning "$label: $total $prefix"
  fi
}
export -f _comment_total

# Label: Comment Totals
# Description: Print project comment totals.
comment_totals() {
  local prefixes=("TODO" "FIX" "DUPLICATE" "shellcheck disable" ":reek:")

  for prefix in ${prefixes[*]}; do
    _comment_total "$prefix"
  done
}
export -f comment_totals
