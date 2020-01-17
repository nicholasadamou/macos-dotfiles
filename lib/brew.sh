#!/bin/bash

is_brew_installed() {
    if ! command -v "brew" > /dev/null; then
        echo "(brew) is not installed."
        return 1
    fi
}

brew_install() {
    declare -r CMD="$3"
    declare -r FORMULA="$1"
    declare -r TAP_VALUE="$2"

    local LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `brew` is installed.

    is_brew_installed || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If `brew tap` needs to be executed,
    # check if it executed correctly.

    if [ -n "$TAP_VALUE" ]; then
        if ! brew_tap "$TAP_VALUE"; then
            printf "%s ('brew tap %s' failed)" "$FORMULA" "$TAP_VALUE"
            return 1
        fi
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install the specified formula.

    if brew "$CMD" list | grep "$FORMULA" &> /dev/null; then
        printf "(%s) is already installed" "$FORMULA"
    else
        . "$LOCAL_BASH_CONFIG_FILE" \
        	&& brew "$CMD" install "$FORMULA"
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
            && brew bundle install -v --file="$FILE_PATH"

    fi
}

brew_tap() {
    local LOCAL_BASH_CONFIG_FILE="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    . "$LOCAL_BASH_CONFIG_FILE" \
        && brew tap "$1" &> /dev/null
}
