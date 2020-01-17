#!/bin/bash

is_brew_installed() {
    if ! command -v "brew" > /dev/null; then
        echo "(brew) is not installed."
        return 1
    fi
}

brew_bundle_install() {
    declare -r FILE_PATH="$1"

    local LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `brew` is installed.

    is_brew_installed || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install formulae.

    if [ -e "$FILE_PATH" ]; then

        . "$LOCAL_BASH_CONFIG_FILE" \
            && brew bundle install -v --file=\"$FILE_PATH\"

    fi
}
