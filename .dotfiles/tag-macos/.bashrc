#! /usr/bin/env bash

if [[ BASH_VERSINFO[0] < 4 ]]; then
  printf "%s\n" "WARNING: Dotfiles requires Bash 4.x.x or higher to work correctly."
fi

# Checks the window size after each command and, if necessary, updates LINES and COLUMNS values.
shopt -s checkwinsize

# Attempts to save all lines of a multi-line command as a single history entry for easy re-editing.
shopt -s cmdhist

# Attempts word spelling correction on directory names if directory name supplied does not exist.
shopt -s dirspell

# Enables extended pattern matching features.
shopt -s extglob

# Using ** in a pathname expansion context will match all files and zero or more directories and
# subdirectories. If the pattern is followed by a /, only directories and subdirectories match.
shopt -s globstar

# The history list is appended (instead of being overwritten) as defined by the HISTFILE variable.
shopt -s histappend

# Enables history expansion with space (i.e. `!!<space>`).
bind Space:magic-space

# Bash Variables.
# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html

# Default Editors
export EDITOR=code
export VISUAL=vim

# History
export HISTFILE="$HOME/.config/bash/history.log"
export HISTTIMEFORMAT="%F %T " # Use YYYY-MM-DD HH:MM:SS date/time format.
export HISTCONTROL="erasedups:ignoreboth" # Remove duplicate entries.
export HISTSIZE=10000 # Keep lengthy command history.
export HISTIGNORE="#*:..:...:c:h:l:l1:p:pwd:gst:gd:exit:* --help" # Exclude mundane commands.
# Increase the maximum number of lines of history persisted
# in the `Node` REPL history file (default value is 1000).
#
# https://github.com/nodejs/node/blob/c948877688ff2b6a37f2c88724b656aae495c7b2/doc/api/repl.md#persistent-history
export NODE_REPL_HISTORY_SIZE=10000

# Prefer US English and use UTF-8 encoding.
export LANG="en_US"
export LC_ALL="en_US.UTF-8"

# Use custom `less` colors for `man` pages.
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history.
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Don't clear the screen after quitting a `man` page.
export MANPAGER="less -X"

# Set custom 'ls' colors
export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Make Python use UTF-8 encoding for output to stdin/stdout/stderr.
export PYTHONIOENCODING="UTF-8"

# Homebrew
export HOMEBREW_BAT=1
export HOMEBREW_CURL_RETRIES=3
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_FORCE_BREWED_GIT=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_PREFIX="/usr/local"
export PATH="/usr/local/sbin:$PATH"
# Make all homebrew casks and fonts be installed to a
# specific directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

# Environment
. "$HOME/.config/bash/env.sh"

# Colors
. "$HOME/.config/bash/colors.sh"

# Aliases
. "$HOME/.config/bash/aliases.sh"

# Functions
. "$HOME/.config/bash/functions-private.sh"
. "$HOME/.config/bash/functions-public.sh"

# Command Prompt
. "$HOME/.config/bash/prompt.sh"

# Logout
. "$HOME/.bash_logout"

# Bash Completion
if [[ -f /usr/local/etc/bash_completion ]]; then
  . /usr/local/etc/bash_completion
fi

# OpenSSL
export PATH="/usr/local/opt/openssl/bin:$PATH"

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# direnv
if [[ -e /usr/local/bin/direnv ]]; then
  eval "$(direnv hook bash)"
fi

# FZF
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --color always --exclude .git"
export FZF_DEFAULT_OPTS="--multi --ansi"

# Node
export PATH="$PATH:/usr/local/share/npm/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Yarn
export PATH="$PATH:$(yarn global bin)"

# Z
export _Z_DATA="$HOME/.cache/z/history.txt"
if [[ -e /usr/local/etc/profile.d/z.sh ]]; then
  . /usr/local/etc/profile.d/z.sh
fi

# Git
source "$HOMEBREW_PREFIX/opt/git/etc/bash_completion.d/git-completion.bash"
export PATH=".git/safe/../../bin:$PATH"

# Ruby configurations
# Adds "GEMS_PATH" to "$PATH"
# Fixes "I INSTALLED GEMS WITH --user-install AND THEIR COMMANDS ARE NOT AVAILABLE"
# see: https://guides.rubygems.org/faqs/#user-install
if command -v gem &> /dev/null; then
	if [ -d "$(gem environment gemdir)/bin" ]; then
		export PATH="$(gem environment gemdir)/bin:$PATH"
	fi
fi

# Add ~/.local/bin to $PATH
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

# Add ~/.iterm2 to $PATH
if [ -d "$HOME/.iterm2" ]; then
	export PATH="$HOME/.iterm2:$PATH"
fi

# Add /usr/local/bin to $PATH
if command -v brew &> /dev/null; then
	if [ -d "$(brew --prefix)/bin" ]; then
		export PATH="$(brew --prefix)/bin:$PATH"
	fi
fi

# Clear system messages (system copyright notice, the date
# and time of the last login, the message of the day, etc.)

clear
