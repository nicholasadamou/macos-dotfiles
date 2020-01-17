<p align="center">
  <img src="dotfiles.png" alt="Dotfiles Icon"/>
</p>

# Dotfiles

[![Circle CI Status](https://circleci.com/gh/nicholasadamou/macos-dotfiles.svg?style=svg)](https://circleci.com/gh/nicholasadamou/macos-dotfiles)

Shell scripts for applying default settings to UNIX-based operating systems.

By default, these are set to my preferences (namely for macOS) but you can change them to your
liking by editing any of the files in the `.dotfiles/tag-macos` directory. Read on to learn
more.

## Table of Contents

- [Features](#features)
- [Setup](#setup)
- [Updating](#updating)
- [License](#license)

## Features

- Configures the Bash `.bashrc`, `.bash_profile`, and `.inputrc` files.
- Configures the `.hushlogin` & `.bash_logout` files.
- Configures `fish` along with `fisher` and `omf` along with a few of their packages.
- Configures the [Git](http://git-scm.com) `.gitconfig`.
- Configures the [Silver Surfer](https://github.com/ggreer/the_silver_searcher) `.agignore` file.
- Configures the [NPM](https://www.npmjs.org) `.npmrc` file.
- Configures [Visual Studio Code](https://code.visualstudio.com/) as the default editor.
- Adds [Bash Completion](http://bash-completion.alioth.debian.org).
- Adds [GPG](https://www.gnupg.org) support.
- Adds [Node.js](http://nodejs.org) support.
- Adds [Z](https://github.com/rupa/z) support.
- Adds [tmux](https://github.com/tmux/tmux) support.

## Setup

[![xkcd: Automation](http://imgs.xkcd.com/comics/automation.png)](http://xkcd.com/1319/)

To install my `dotfiles`, just run the following snippet in [`iTerm2`](https://www.iterm2.com/) or `terminal`:

    git clone https://github.com/nicholasadamou/macos-dotfiles.git dotfiles && \
    	cd dotfiles && \
    	bin/dotfiles -b && \
    	bin/dotfiles -l

Edit any of the files in the `.dotfiles/tag-macos` directory
as you see fit. Then open a terminal window and execute the following command to install:

    cd dotfiles
    bin/run --base
    bin/run -l

Executing the `bin/dotfiles` script will present the following options:

    -b|--base: Run the base module.
    -s: Show managed dotfiles.
    -c: Check for and remove all broken symlinks in $HOME directory.
    -l: Symlink dotfiles (existing files are skipped).
    -d: Delete dotfiles.
    -u: Update the dotfiles repository to the latest stable version.
    -h|--help: Print the help message.

The options prompt can be skipped by passing the desired option directly to the `bin/dotfiles` script.
For example, executing `bin/dotfiles -s` will show all managed dotfiles by this project.

After install, the following files will require manual updating:

- `.bash.local`: Add secret/machine-specific environment settings (if any).
- `.fish.local`: Add secret/machine-specific environment settings (if any).
- `.gitconfig`: Uncomment the name, email, and token lines within the `[user]` and `[github]`
  sections to replace with your own details.

## Updating

When updating, run the following:

1. Run: `bin/dotfiles -b`
1. Run: `bin/dotfiles -d` and `bin/dotfiles -l`

or simply run:

    bin/dotfiles -u

## License

Copyright 2020 [Nicholas Adamou](https://www.nicholasadamou.com).
Read [LICENSE](LICENSE.md) for details.
