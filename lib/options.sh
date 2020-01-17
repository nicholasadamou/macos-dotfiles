#!/bin/bash

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters:
# $1 = The option to process.
process_option() {
  case $1 in
		'-b|--no-base|--base|b|no-base')
			_arg_base="on"

			test "${1:0:5}" = "--no-" && _arg_base="off"
			test "${1:0:5}" = "no-" && _arg_base="off"

			# by default, run the base module.
			if [[ ${_arg_base} == "on" ]]; then
				bash "$DOTFILES_PATH"/base/base.sh
			fi
			;;
    '-s|s')
      show_files;;
		'-c|c')
			check_files;;
    '-l|l')
      symlink_files;;
    '-d|d')
      delete_files;;
    '-q|q');;
    *)
      printf "%s\n" "ERROR: Invalid option.";;
  esac
}
export -f process_option
