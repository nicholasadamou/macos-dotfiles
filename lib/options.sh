#!/bin/bash

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters:
# $1 = The option to process.
process_option() {
  case $1 in
		-b|--base)
			bash "$DOTFILES_PATH"/base/base.sh
			;;
    -s)
      show_files;;
		-c)
			check_files;;
    -l)
      symlink_files;;
    -d)
      delete_files;;
		-u)
			update_dotfiles "$2";;
		-h|--help)
			show_help;;
    *)
      printf "%s\n" "ERROR: Invalid option.";;
  esac
}
export -f process_option
