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
	declare -r CONTENT="#!/bin/bash

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

change_default_bash() {
    local configs=""
    local pathConfig=""

    local newShellPath=""
    local brewPrefix=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Try to get the path of the `Bash`
    # version installed through `Homebrew`.

    brewPrefix="$(brew --prefix)"

    pathConfig="PATH=\"$brewPrefix/bin:\$PATH\""
    configs="# Homebrew bash configurations
$pathConfig
export PATH"

    newShellPath="$brewPrefix/bin/bash"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Add the path of the `Bash` version installed through `Homebrew`
    # to the list of login shells from the `/etc/shells` file.
    #
    # This needs to be done because applications use this file to
    # determine whether a shell is valid (e.g.: `chsh` consults the
    # `/etc/shells` to determine whether an unprivileged user may
    # change the login shell for their own account).
    #
    # http://www.linuxfromscratch.org/blfs/view/7.4/postlfs/etcshells.html

    if ! grep -q "$(<<<"$newShellPath" tr '\n' '\01')" < <(less "/etc/shells" | tr '\n' '\01'); then
        printf '%s\n' "$newShellPath" | sudo tee -a /etc/shells
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set latest version of `Bash` as the default
    # (macOS uses by default an older version of `Bash`).

    if [ "$(dscl . -read /Users/"${USER}"/ UserShell | cut -d ' ' -f2)" != "${newShellPath}" ]; then
        chsh -s "$newShellPath" &> /dev/null
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If needed, add the necessary configs in the
    # local shell configuration file.

    if [ ! -e "$LOCAL_BASH_CONFIG_FILE" ] || ! grep -q "$(<<<"$configs" tr '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$configs" >> "$LOCAL_BASH_CONFIG_FILE" \
            && . "$LOCAL_BASH_CONFIG_FILE"
    fi
}

main() {
	create_bash_local

	if ! command -v brew > /dev/null; then
		ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
		add_brew_configs
		brew_bundle_install "$DOTFILES_PATH/base/Brewfile"
		change_default_bash
	fi
}

main
