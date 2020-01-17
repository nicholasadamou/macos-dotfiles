#! /usr/bin/env bash

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters:
# $1 = The option to process.
process_option() {
  case $1 in
    's')
      show_files;;
		'c')
			check_files;;
    'l')
      symlink_files;;
    'd')
      delete_files;;
    'q');;
    *)
      printf "%s\n" "ERROR: Invalid option.";;
  esac
}
export -f process_option
