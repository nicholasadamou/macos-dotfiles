#!/bin/bash

#------------------#
# Section: General #
#------------------#

# Label: Print Black on White
# Description: Print black text on a white background.
# Parameters: $1 (required) - Content to print.
_print_black_on_white() {
  local content="$1"
  printf "\e[0;30m\e[48;5;255m$content\033[m"
}

# Label: Clip and Print
# Description: Copy input to clipboard and print what what was copied (best used with a pipe).
# Parameters: $1 (optional) - Displays "(copied to cliboard)" on a new line. Default: false.
_copy_and_print() {
  local delimiter=${1:-' '}
  local message="$delimiter(copied to clipboard)\n"

  pbcopy && printf "%s" "$(pbpaste)" && printf "$message"
}

# Label: Toggle Total Color
# Description: Format and conditionally color the total.
# Parameters: $1 (required) - The total, $2(required) - The label, $3 (required) - The color.
_toggle_total_color() {
  local total="$1"
  local label="$2"
  local color="$3"

  if [[ $total -gt 0 ]]; then
    printf "$color$total $label\033[m"
  else
    printf "$total $label"
  fi
}

#------------------------------------#
# Section: [Git](http://git-scm.com) #
#------------------------------------#

# Label: Git Log Line Format
# Description: Print single line log format.
_git_log_line_format() {
  printf "%s" "%C(yellow)%h%C(reset) %G? %C(bold blue)%an%C(reset) %s%C(bold cyan)%d%C(reset) %C(green)%cr.%C(reset)"
}

# Label: Git Log Details Format
# Description: Prints default log format.
_git_log_details_format() {
  printf "%s" "$(_git_log_line_format) %n%n%b%n%N%-%n"
}

# Label: Git Show Details
# Description: Show commit/file change details in a concise format.
# Parameters: $1 (required) - The params to pass to git show.
_git_show_details() {
  git show --stat --pretty=format:"$(_git_log_details_format)" $@
}

# Label: Git Commits Since Last Tag
# Description: Answer commit history since last tag for project.
_git_commits_since_last_tag() {
  if [[ $(git tag) ]]; then
    git log --oneline --reverse --format='%C(yellow)%h%Creset %s' $(git describe --abbrev=0 --tags --always)..HEAD
  else
    git log --oneline --reverse --format='%C(yellow)%h%Creset %s'
  fi
}

# Label: Git Commit Count Since Last Tag
# Description: Answer commit count since last tag for project.
# Parameters: $1 (optional) - The output prefix. Default: null., $2 (optional) - The output suffix. Default: null.
_git_commit_count_since_last_tag() {
  local prefix="$1"
  local suffix="$2"
  local count=$(_git_commits_since_last_tag | wc -l | xargs -n 1)

  if [[ -n $count ]]; then
    # Prefix
    if [[ -n "$prefix" ]]; then
      printf "\033[36m${prefix}\033[m: " # Cyan.
    fi

    # Commit Count
    if [[ $count -ge 30 ]]; then
      printf "\033[31m$count\033[m" # Red.
    elif [[ $count -ge 20 && $count -le 29 ]]; then
      printf "\033[1;31m$count\033[m" # Light red.
    elif [[ $count -ge 10 && $count -le 19 ]]; then
      printf "\033[33m$count\033[m" # Yellow.
    else
      printf "$count" # White.
    fi

    # Suffix
    if [[ -n "$suffix" ]]; then
      printf "$suffix"
    fi
  fi
}

# Label: Git Commit Last
# Description: Answer last commit for current branch.
_git_commit_last() {
  git log --pretty=format:%h -1
}

# Label: Git Last Tag Info
# Description: Answer last tag for project (including commits added since tag was created).
_git_last_tag_info() {
  printf "%s\n" "$(git describe --tags --always) ($(_git_commit_count_since_last_tag) commits since)"
}

# Label: Git File Commits
# Description: Print file commit history (with optional diff support).
# Parameters: $1 (required) - The file path.
_git_file_commits() {
  local commits=("${!1}")
  local file="$2"
  local commit_total=${#commits[@]}
  local option_padding=${#commit_total}
  local counter=1

  _git_commit_options "${commits[*]}"

  read -r -p "Enter selection: " response
  if [[ "$response" == 'q' ]]; then
    return
  fi

  printf "\n"
  local selected_commit=${commits[$((response - 1))]}
  _git_show_details $selected_commit

  printf "\n"
  read -p "View diff (y = yes, n = no)? " response
  if [[ "$response" == 'y' ]]; then
    gdt $selected_commit^! -- "$file"
  fi
}

# Label: Git Commit Options
# Description: Print options for interacting with Git commits.
# Parameters: $1 (required) - Commit array, $2 (optional) - Options label. Default: "Commits".
_git_commit_options() {
  local commits=("${1}")
  local label="${2:-Commits}"
  local commit_total=${#commits[@]}
  local option_padding=${#commit_total}
  local counter=1

  if [[ ${#commits[@]} == 0 ]]; then
    printf "%s\n" "No commits found."
    return 0
  fi

  printf "%s:\n\n" "$label"

  for commit in ${commits[@]}; do
    local option="$(printf "%${option_padding}s" $counter)"
    printf "%s\n" "$option: $(git log --color --pretty=format:"$(_git_log_line_format)" -n1 $commit)"
    counter=$((counter + 1))
  done

  option_padding=$((option_padding + 1))
  printf "%${option_padding}s %s\n\n" "q:" "Quit/Exit."
}

# Label: Git Branch Name
# Description: Print Git branch name.
_git_branch_name() {
  git branch --show-current | tr -d '\n'
}

# Label: Git Branch SHAs
# Description: Answer branch commit SHAs regardless of branch nesting.
_git_branch_shas() {
  local ifs_original=$IFS
  IFS=$'\n'

  local log_format="%h%d"
  local current_commit=($(git log --pretty=format:$log_format) -1)
  local commits=($(git log --pretty=format:$log_format))
  local parent_sha="$(_git_commit_last)"
  local current_pattern=".*\(HEAD.+\)*"
  local parent_pattern=".*\(.+\)*"
  local origin_pattern=".*\(origin\/$(_git_branch_name)\)$"
  local master_pattern=".*\(.+master(\,|\))*"

  if [[ ! "$current_commit" =~ $master_pattern ]]; then
    for entry in ${commits[@]}; do
      local entry_sha="${entry%% *}"

      if [[ ! "$entry" =~ $current_pattern && ! "$entry" =~ $origin_pattern ]]; then
        if [[ "$entry" =~ $master_pattern ]]; then
          parent_sha="$entry_sha"
          break
        elif [[ "$entry" =~ $parent_pattern ]]; then
          parent_sha="$entry_sha"
          break
        fi
      fi
    done
  fi

  git log --pretty=format:%h "$parent_sha..$(_git_commit_last)"
  IFS=$ifs_original
}

# Label: Git Branch SHA
# Description: Answer SHA from which the branch was created.
_git_branch_sha() {
  local shas=($(_git_branch_shas))

  if [[ ${#shas[@]} != 0 ]]; then
    printf "%s" ${shas[-1]}
  fi
}

# Label: Git Branch List (alphabetical)
# Description: List branches (local/remote) alphabetically.
# Parameters: $1 (optional) - The output format.
_git_branch_list_alpha() {
  _git_branch_list "$1" | sort
}

# Label: Git Branch List
# Description: List branches (local/remote) including author and relative time.
# Parameters: $1 (optional) - The output format.
_git_branch_list() {
  local format=${1:-"%(refname) %(color:blue bold)%(authorname) %(color:green)(%(authordate:relative))"}

  git for-each-ref --sort="authordate:iso8601" \
                   --sort="authorname" \
                   --color \
                   --format="$format" refs/heads refs/remotes/origin | \
                   sed '/HEAD/d' | \
                   sed 's/refs\/heads\///g' | \
                   sed 's/refs\/remotes\/origin\///g' | \
                   uniq
}

# Label: Git Stash Count
# Description: Answer total stash count for current project.
_git_stash_count() {
  git stash list | wc -l | xargs -n 1
}

# Label: Git Stash
# Description: Enhance default git stash behavior by prompting for input (multiple) or using last stash (single).
# Parameters: $1 (required) - The Git stash command to execute, $2 (required) - The prompt label (for multiple stashes).
_process_git_stash() {
  local stash_command="$1"
  local stash_index=0
  local prompt_label="$2"
  local ifs_original=$IFS
  IFS=$'\n'

  # Store existing stashes (if any) as an array. See public, "gashl" for details.
  stashes=($(gashl))

  if [[ ${#stashes[@]} == 0 ]]; then
    printf "%s\n" "Git stash is empty. Nothing to do."
    return 0
  fi

  # Ask which stash to show when multiple stashes are detected, otherwise show the existing stash.
  if [[ ${#stashes[@]} -gt 1 ]]; then
    printf "%s\n" "$prompt_label:"
    for ((index = 0; index < ${#stashes[*]}; index++)); do
      printf "  %s\n" "$index: ${stashes[$index]}"
    done
    printf "  %s\n\n" "q: Quit/Exit."

    read -p "Enter selection: " response

    local match="^[0-9]{1}$"
    if [[ "$response" =~ $match ]]; then
      printf "\n"
      stash_index="$response"
    else
      return 0
    fi
  fi

  IFS=$ifs_original
  eval "$stash_command stash@{$stash_index}"
}

#---------------------------------------#
# Section: [GitHub](https://github.com) #
#---------------------------------------#

# Label: GitHub URL
# Description: Answer GitHub URL for current project.
_gh_url() {
  local remote="$(git remote -v | ag github.com | ag fetch | head -1 | cut -f2 | cut -d' ' -f1)"
  local match="^git@.*"

  if [[ "$remote" =~ $match ]]; then
    printf "$remote" | sed -e 's/:/\//' -e 's/git@/https:\/\//' -e 's/\.git//'
  else
    printf "$remote"
  fi
}

# Label: GitHub Pull Request List
# Description: List pull requests (local/remote) including subject, author, and relative time.
# Parameters: $1 (optional) - The output format.
_gh_pr_list() {
  local format=${1:-"%(refname) %(color:yellow)%(refname)%(color:reset) %(subject) %(color:blue bold)%(authorname) %(color:green)(%(committerdate:relative))"}

  git for-each-ref --color --format="$format" refs/remotes/pull_requests | \
                   sed 's/refs\/remotes\/pull_requests\///g' | \
                   sort --numeric-sort | \
                   cut -d' ' -f2-
}

# Label: Process GitHub Commit Option
# Description: Process GitHub commit option for remote repository viewing.
# Parameters: $1 (optional) - The commit hash.
_process_gh_commit_option() {
  local commit="$1"

  if [[ "$commit" ]]; then
    open "$(_gh_url)/commit/$commit"
  else
    open "$(_gh_url)/commits"
  fi
}

# Label: Process GitHub File Option
# Description: Process GitHub file option for remote repository viewing.
# Parameters: $1 (required) - The local (relative) file path, $2 (optional) - The line numbers.
_process_gh_file_option() {
  local path="$1"
  local lines="$2"
  local start_index=$(pwd | wc -c)
  local end_index=$(printf "$path" | wc -c)
  local url="$(_gh_url)/blob/$(_git_branch_name)/${path:$start_index:$end_index}"

  if [[ -n "$lines" ]]; then
    url="$url#$lines"
  fi

  printf "$url" | _copy_and_print
}

# Label: Process GitHub Branch Option
# Description: Process GitHub branch option for remote repository viewing.
# Parameters: $1 (optional) - The option.
_process_gh_branch_option() {
  case $1 in
    'c')
      open "$(_gh_url)/tree/$(_git_branch_name)";;
    'd')
      open "$(_gh_url)/compare/$(_git_branch_name)";;
    'r')
      open "$(_gh_url)/compare/$(_git_branch_name)?expand=1";;
    *)
      open "$(_gh_url)/branches";;
  esac
}

# Label: Process GitHub Pull Request Option
# Description: Process GitHub pull request option for remote repository viewing.
# Parameters: $1 (optional) - The option.
_process_gh_pull_request_option() {
  local option="$1"
  local number_match="^[0-9]+$"

  if [[ "$option" =~ $number_match ]]; then
    open "$(_gh_url)/pull/$option"
  elif [[ "$option" == 'l' ]]; then
    _gh_pr_list
  else
    open "$(_gh_url)/pulls"
  fi
}

# Label: Process GitHub URL Option
# Description: Processes GitHub URL option for remote repository viewing.
# Parameters: $1 (optional) - The commit/option.
_process_gh_url_option() {
  local commit="$1"
  local commit_match="^([0-9a-f]{40}|[0-9a-f]{7})$"

  if [[ "$commit" =~ $commit_match ]]; then
    printf "$(_gh_url)/commit/$commit" | _copy_and_print
  elif [[ "$commit" == 'l' ]]; then
    printf "$(_gh_url)/commit/$(_git_commit_last)" | _copy_and_print
  else
    _gh_url | _copy_and_print
  fi
}

# Label: Process GitHub Option
# Description: Processes GitHub option for remote repository viewing.
# Parameters: $1 (optional) - The first option, $2 (optional) - The second option.
_process_gh_option() {
  case $1 in
    'o')
      open $(_gh_url);;
    'i')
      open "$(_gh_url)/issues";;
    'c')
      _process_gh_commit_option "$2";;
    'f')
      _process_gh_file_option "$2" "$3";;
    'b')
      _process_gh_branch_option "$2";;
    't')
      open "$(_gh_url)/tags";;
    'r')
      _process_gh_pull_request_option "$2";;
    'w')
      open "$(_gh_url)/wiki";;
    'p')
      open "$(_gh_url)/pulse";;
    'g')
      open "$(_gh_url)/graphs";;
    's')
      open "$(_gh_url)/settings";;
    'u')
      _process_gh_url_option "$2";;
    'q');;
    *)
      printf "%s\n" "ERROR: Invalid option.";;
  esac
}

#-------------------#
# Section: Dotfiles #
#-------------------#

# Label: Print Section
# Description: Print section.
# Parameters: $1 (required) - The string from which to parse the section from.
_print_section() {
  if [[ "$1" == "# Section:"* ]]; then
    local section=$(printf "$1" | sed 's/# Section://' | sed 's/^ *//g' | tr -d '#')
    printf "\n%s\n\n" "#### $section"
  fi
}

# Label: Print Alias
# Description: Print alias.
# Parameters: $1 (required) - The string from which to parse the alias from.
_print_alias() {
  echo "$1" | sed 's/alias //' | sed 's/="/ = "/' | sed "s/='/ = '/"
}

# Label: Print Aliases
# Description: Print aliases.
_print_aliases() {
  while read -r line; do
    _print_section "$line"

    if [[ "$line" == "alias"* ]]; then
      printf "    "
      _print_alias "$line"
    fi
  done < "$HOME/.config/bash/aliases.sh"
}

# Label: Print Function Name
# Description: Print function name.
# Parameters: $1 (required) - The string from which to parse the function name from.
_print_function_name() {
  local name=$(printf "$1" | sed 's/() {//')
  printf "%s\n" "$name = $2 - $3"
}

# Label: Set Function Label
# Description: Set function label.
# Parameters: $1 (required) - The string from which to parse the function label from.
_set_function_label() {
  if [[ "$1" == "# Label:"* ]]; then
    label=$(printf "$1" | sed 's/# Label://' | sed 's/^ *//g')
  fi
}

# Label: Set Function Description
# Description: Set function description.
_set_function_description() {
  if [[ "$line" == "# Description:"* ]]; then
    description=$(printf "$line" | sed 's/# Description://' | sed 's/^ *//g')
  fi
}

# Label: Print Functions
# Description: Print functions.
_print_functions() {
  local path="${1:-$HOME/.config/bash/functions-public.sh}"

  while read -r line; do
    _print_section "$line"
    _set_function_label "$line"
    _set_function_description "$line"

    if [[ "$line" == *"() {" && "$line" != "_"* ]]; then
      printf "    "
      _print_function_name "$line" "$label" "$description"
      unset label
      unset description
    fi
  done < "$path"
}

# Label: Print Git Hooks
# Description: Print Git hooks.
_print_git_hooks() {
  for file in $(find "$HOME/.config/git/hooks/extensions" -type l | sort); do
    _print_functions "$file"
  done
}

# Label: Print All
# Description: Print aliases, functions, and Git hooks.
_print_all() {
  printf "%s\n" "### Aliases"
  _print_aliases
  printf "\n%s\n" "### Functions"
  _print_functions
  printf "\n%s\n\n" "### Git Hooks"
  _print_git_hooks
}

# Label: Find Alias
# Description: Find and print matching alias.
# Parameters: $1 (required) - The alias to search for.
_find_alias() {
  while read -r line; do
    if [[ "$line" == "alias "*"$1"* ]]; then
      printf "    %s " "Alias:"
      _print_alias "$line"
    fi
  done < "$HOME/.config/bash/aliases.sh"
}

# Label: Find Function
# Description: Find and print matching function.
# Parameters: $1 (required) - The function to search for.
_find_function() {
  while read -r line; do
    _set_function_label "$line"
    _set_function_description "$line"

    if [[ "$line" == *"$1"*"()"* ]]; then
      printf "    %s " "Function:"
      _print_function_name "$line" "$label" "$description"
      unset label
      unset description
    fi
  done < "$HOME/.config/bash/functions-public.sh"
}

# Label: Find Command
# Description: Find and print matching alias or function.
# Parameters: $1 (required). The alias or function to search for.
_find_command() {
  if [[ "$1" ]]; then
    printf "%s\n" "\"$1\" Search Results:"

    _find_alias "$1"
    _find_function "$1"
  else
    printf "%s\n" "ERROR: Nothing to search for. Criteria must be supplied."
  fi
}

# Label: Process Dotfiles Option
# Description: Process option for learning about dotfile aliases/functions.
# Parameters: $1 (optional) - The option selection, $2 (optional) - The option input.
_process_dots_option() {
  case $1 in
    'a')
      _print_aliases | more;;
    'f')
      _print_functions | more;;
    'g')
      _print_git_hooks | more;;
    'p')
      _print_all | more;;
    's')
      _find_command "$2" | more;;
    'q');;
    *)
      printf "%s\n" "ERROR: Invalid option.";;
  esac
}
