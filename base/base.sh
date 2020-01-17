#!/bin/bash

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}"

# DESCRIPTION
# Executes the command line interface.

# SETTINGS
set -o errexit
set -o pipefail

# VARIABLES
declare DOTFILES_PATH="$HOME/dotfiles"
declare LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"

# LIBRARY
source "$DOTFILES_PATH"/lib/brew.sh

# EXECUTION
create_bash_local() {
    declare -r FILE_PATH="$LOCAL_BASH_CONFIG_FILE"
	declare -r CONTENT="#! /usr/bin/env bash

# Add secret/machine specific key/value pairs here.
# export EXAMPLE=\"An example of a secret/machine-specific key/value.\"
"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
        printf "%s\n" "$CONTENT" >> "$FILE_PATH"
    fi
}

add_brew_configs() {
    declare -r BASH_CONFIGS="
# Homebrew - The missing package manager for macOS.
export PATH=\"/usr/local/bin:\$PATH\"
export PATH=\"/usr/local/sbin:\$PATH\"
"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If needed, add the necessary configs in the
    # local shell configuration file.

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf "%s\n" "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi
}

main() {
	create_bash_local

	if ! command -v brew > /dev/null; then
		ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
		add_brew_configs
	fi

	brew_bundle_install "Brewfile"
}

main
