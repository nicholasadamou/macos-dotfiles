#!/bin/bash

# DESCRIPTION
# Defines general utility functions.

# VARIABLES
declare DOTFILES_PATH="$HOME/dotfiles"

# Shows managed dot files.
show_files() {
  # List files that will be symlinked via 'rcup' using $DOTFILES_PATH/.dotifles/rcrc.
	export RCRC="${DOTFILES_PATH}/.dotfiles/rcrc" && lsrc -v -d "${DOTFILES_PATH}/.dotfiles"
}
export -f show_files

# Installs all dot files.
symlink_files() {
	# Update and/or install dotfiles. These dotfiles are stored in the .dotfiles directory.
	# rcup is used to install files from the tag-specific dotfiles directory.
	# rcup is part of rcm, a management suite for dotfiles.
	# Check https://github.com/thoughtbot/rcm for more info.

	# Get the absolute path of the .dotfiles directory.
	# This is only for aesthetic reasons to have an absolute symlink path instead of a relative one
	# <path-to-dotfiles>/.dotfiles/somedotfile vs <path-to-dotfiles>/.dotfiles/tag-macos/../somedotfile
	readonly dotfiles="${DOTFILES_PATH}/.dotfiles"

	# Remove broken symlinks in '$HOME' directory.
	check_files

	# Symlink files listed within dotfiles/rcrc to the '$HOME' directory.
	export RCRC="$dotfiles/rcrc" && \
					rcup -v -f -d "${dotfiles}"
}
export -f symlink_files

# Delete all dot files.
delete_files() {
	# Remove files that were symlinked via 'rcup'.
	export RCRC="${DOTFILES_PATH}/.dotfiles/rcrc" && rcdn -v -d "${DOTFILES_PATH}/.dotfiles"

	# Remove broken symlinks in '$HOME' directory.
	check_files
}
export -f delete_files

# Check for broken symlinks.
check_files() {
	# Remove broken symlinks in '$HOME' directory.
	"${DOTFILES_PATH}"/bin/symlinks -rd "$HOME"
}
export -f check_files

# Update the dotfiles repository to the latest stable version.
update_dotfiles() {
	cd "$HOME" && \
		rm -rf "${DOTFILES_PATH}" && \
		git clone https://github.com/nicholasadamou/macos-dotfiles.git "${DOTFILES_PATH}" && \
		"${DOTFILES_PATH}"/bin/dotfiles -b && \
		"${DOTFILES_PATH}"/bin/dotfiles -d && \
		"${DOTFILES_PATH}"/bin/dotfiles -l
}
export -f update_dotfiles

# Show the usage message.
print_help() {
	# Display the usage message.
	printf "%s\n" "Dotfile Installer"
	printf "%s\n" "Usage: $0 [-b|--base] [-s] [-c] [-l] [-d] [-u] [-h|--help] [-q]"
	printf "  %s\n" "-b,--base: Run base module."
	printf "  %s\n" "-s: Show managed dotfiles."
	printf "  %s\n" "-c: Check for and remove all broken symlinks in \$HOME directorys."
	printf "  %s\n" "-l: Symlink dotfiles (existing files are skipped)."
	printf "  %s\n" "-u: Update the dotfiles repository to the latest version."
	printf "  %s\n" "-d: Delete dotfiles."
	printf "  %s\n\n" "-h: Print this help message."
}
export -f print_help
