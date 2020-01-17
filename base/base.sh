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

declare LOCAL_BASH_CONFIG_FILE="$DOTFILES_PATH/.dotfiles/tag-macos/.config/bash/env.sh"

# LIBRARY
source "$DOTFILES_PATH"/lib/brew.sh

# EXECUTION
add_brew_configs() {
    declare -r BASH_CONFIGS="
# Homebrew - The missing package manager for macOS.
export PATH=\"/usr/local/bin:\$PATH\"
export PATH=\"/usr/local/sbin:\$PATH\"
"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If needed, add the necessary configs in the
    # local shell configuration file.

    if ! grep -q "$(<<<"$BASH_CONFIGS" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf "\n%s\n" "$BASH_CONFIGS" >> "$LOCAL_BASH_CONFIG_FILE" \
                && . "$LOCAL_BASH_CONFIG_FILE"
    fi
}

main() {
	if ! command -v brew > /dev/null; then
		ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
		add_brew_configs
	fi

	brew_bundle_install "$DOTFILES_PATH/lib/Brewfile"
}

main
