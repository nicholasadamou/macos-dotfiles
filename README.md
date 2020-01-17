<p align="center">
  <img src="dotfiles.png" alt="Dotfiles Icon"/>
</p>

# Dotfiles

[![Circle CI Status](https://circleci.com/gh/nicholasadamou/macos-dotfiles.svg?style=svg)](https://circleci.com/gh/nicholasadamou/macos-dotfiles)

Shell scripts for applying default settings to UNIX-based operating systems.

By default, these are set to my preferences (namely for macOS) but you can change them to your
liking by editing any of the `*.` files in the `home_files` directory. Read on to learn
more.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Upgrade](#upgrade)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

## Features

- Configures the Bash `.bashrc`, `.bash_profile`, and `.inputrc` files.
- Configures the `.hushlogin` & `.bash_logout` files.
- Configures the [CTags](http://ctags.sourceforge.net) `.ctags` file.
- Configures the [Vim](http://www.vim.org) `.vimrc` file.
- Configures the [Git](http://git-scm.com) `.gitconfig`, `.gitignore`, and hook (i.e.
  `.git_template`) files.
- Configures the [Silver Surfer](https://github.com/ggreer/the_silver_searcher) `.agignore` file.
- Configures the [NPM](https://www.npmjs.org) `.npmrc` file.
- Configures [Visual Studio Code](https://code.visualstudio.com/) as the default editor.
- Adds [Bash Completion](http://bash-completion.alioth.debian.org).
- Adds [GPG](https://www.gnupg.org) support.
- Adds [direnv](http://direnv.net) support.
- Adds [Node.js](http://nodejs.org) support.
- Adds [Z](https://github.com/rupa/z) support.

## Requirements

- [macOS](https://github.com/bkuhlmann/mac_os)

## Setup

Open a terminal window and execute the following commands:

Current Version (stable)

    git clone https://github.com/nicholasadamou/macos-dotfiles.git dotfiles
    cd dotfiles
    git checkout 36.0.0

Master Version (unstable)

    git clone https://github.com/nicholasadamou/macos-dotfiles.git dotfiles
    cd dotfiles

Edit any of the `*.` and/or `*.command` (command) files in the `home_files` directory
as you see fit. Then open a terminal window and execute the following command to install:

    cd dotfiles
    bin/run

Executing the `bin/run` script will present the following options:

    s: Show managed dotfiles.
    i: Install dotfiles (existing files are skipped).
    l: Link dotfiles to this project (interactive per file, excludes: env.sh and .gitconfig).
    c: Check for differences between $HOME files and this project's files.
    d: Delete dotfiles (interactive per file, excludes: env.sh and .gitconfig).
    q: Quit/Exit.

The options prompt can be skipped by passing the desired option directly to the `bin/run` script.
For example, executing `bin/run s` will show all managed dotfiles by this project.

After install, the following files will require manual updating:

- `.bash/env.sh`: Add secret/machine-specific environment settings (if any).
- `.gitconfig`: Uncomment the name, email, and token lines within the `[user]` and `[github]`
  sections to replace with your own details.

## Upgrade

When upgrading to a new version, run the following:

1. Run: `bin/run l`. Links new files. If not using linked files, run `bin/run d` and `bin/run i`
   instead.
1. Run: `bin/run c`. Displays file differences, if any. Usually, this will be excluded files.
1. Run: `exec $SHELL`. Updates current shell with the above changes.

## Versioning

Read [Semantic Versioning](https://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

## License

Copyright 2010 [Alchemists](https://www.alchemists.io).
Read [LICENSE](LICENSE.md) for details.

## History

Read [CHANGES](CHANGES.md) for details.
Built with [Bashsmith](https://github.com/bkuhlmann/bashsmith).

## Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at
[Alchemists](https://www.alchemists.io).
Forked & Modified by [Nicholas Adamou](http://nicholasadamou.com).
