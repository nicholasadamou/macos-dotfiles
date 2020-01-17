#!/bin/bash

# Where to install nicholasadamou/dotfiles
readonly DOTFILES_DIR=${DOTFILES_DIR:-"${HOME}/dotfiles"}

function is_git_repo() {
	[ -d "${DOTFILES_DIR}/.git" ] || [[ $(git -C "${DOTFILES_DIR}" rev-parse --is-inside-work-tree 2> /dev/null) ]]
}

function has_remote_origin() {
	git -C "${DOTFILES_DIR}" config --list | grep -qE 'remote.origin.url' 2> /dev/null
}

function is_git_repo_out_of_date() {
	UPSTREAM=${1:-'@{u}'}
	LOCAL=$(git -C "${DOTFILES_DIR}" rev-parse @)
	REMOTE=$(git -C "${DOTFILES_DIR}" rev-parse "$UPSTREAM")
	BASE=$(git -C "${DOTFILES_DIR}" merge-base @ "$UPSTREAM")

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	[ "$LOCAL" = "$BASE" ] && [ "$LOCAL" != "$REMOTE" ]
}
