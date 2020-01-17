#!/bin/bash

# Section: General
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cd..="cd .."
alias cdb="cd -"
alias c="clear"
alias h="history"
alias o="open"
alias cat="bat"
alias top="htop"
command -v "exa" &> /dev/null && {
    alias ls="exa"

    # List all files colorized in long format
    alias l="exa -l"
}
# List only directories
alias lsd="ls -lF --color | grep --color=never '^d'"
# List only hidden files
alias lsh="ls -ld .?*"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias +x="chmod +x"

# Section: Network
alias sshe="$EDITOR $HOME/.ssh/config"
alias key="open /Applications/Utilities/Keychain\ Access.app"
alias dnsi="scutil --dns"
alias dnss="sudo dscacheutil -statistics"
alias dnsf="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && printf 'DNS cache cleared.\n'"

# Section: [Fuzzy Finder](https://github.com/junegunn/fzf)
alias ff="fzf --preview 'bat --color always {}'"

# Section: [tmux](http://tmux.sourceforge.net)
alias tsl="tmux list-sessions"
alias tsa="tmux attach-session -t"
alias tsk="tmux kill-session -t"
alias tsr="tmux rename-session -t"

# Section: [Homebrew](http://brew.sh)
command -v "brew" &> /dev/null && {
    alias brewi='brew install'
    alias brewr='brew uninstall'
    alias brewls='brew list'
    alias brews='brew search'
    alias brewu='brew update && brew upgrade && brew cu --all --yes --cleanup --quiet'
    alias brewd='brew doctor'
}

# Section: [Git](http://git-scm.com)
command -v "hub" &> /dev/null && {
    alias git=hub
}
command -v "lazygit" &> /dev/null && {
    alias lg="lazygit"
}
alias gs ="git status"
alias acp="git add -A && git commit -v && git push"

# thefuck - Magnificent app which corrects your previous console command.
# see: https://github.com/nvbn/thefuck/wiki/Shell-aliases#bash
command -v thefuck &> /dev/null && {
    eval "$(thefuck --alias)"
}

# Section: [Tar](http://www.gnu.org/software/tar/tar.html)
alias bzc="tar --use-compress-program=pigz --create --preserve-permissions --bzip2 --verbose --file"
alias bzx="tar --extract --bzip2 --verbose --file"

# Section: [Silver Surfer](https://github.com/ggreer/the_silver_searcher)
alias agf="ag --hidden --files-with-matches --file-search-regex"

# alias n="npm" # Do not use if using 'n' for Node version control
command -v "npm" &> /dev/null && {
    alias npmi='npm i -g'
    alias npmr='npm uninstall -g'
    alias npmls='npm list -g --depth 0'
    alias npms='npm s'
    alias npmu='npm i -g npm@latest'
}

command -v "yarn" &> /dev/null && {
    alias yr='yarn remove'
    alias ya='yarn add'
    alias yu='yarn self-update && yarn upgrade && yarn upgrade-interactive'
	alias yarni="yarn install"
	alias yarna="yarn add"
	alias yarnu="yarn upgrade"
	alias yarnr="yarn remove"
}

command -v "pip" &> /dev/null && {
    alias pipi='pip install'
    alias pipr='pip uninstall'
    alias pipls='pip list'
    alias pips='pip search'
    alias pipu="sudo pip install --upgrade pip \
                    && sudo pip install --upgrade setuptools \
                    && sudo pip-review --auto"
}

command -v "pip3" &> /dev/null && {
    alias pip3i='pip3 install'
    alias pip3r='pip3 uninstall'
    alias pip3ls='pip3 list'
    alias pip3s='pip3 search'
    alias pip3u="sudo pip3 install -U pip \
                    && sudo -H pip3 install -U pip \
                    && sudo pip-review --auto"
}

# piknik - Copy/paste anything over the network!
# see: https://github.com/jedisct1/piknik#suggested-shell-aliases
command -v "piknick" &> /dev/null && {
    # pkc : read the content to copy to the clipboard from STDIN
    alias pkc='piknik -copy'

    # pkp : paste the clipboard content
    alias pkp='piknik -paste'

    # pkm : move the clipboard content
    alias pkm='piknik -move'

    # pkz : delete the clipboard content
    alias pkz='piknik -copy < /dev/null'

    # pkpr : extract clipboard content sent using the pkfr command
    alias pkpr='piknik -paste | tar xzhpvf -'
}

# has - checks presence of various command line tools and their versions on the path
# see: https://github.com/kdabir/has#running-directly-off-the-internet
alias has="curl -sL https://git.io/_has | bash -s"

alias wttr="curl wttr.in"

# Section: [Path Finder](http://www.cocoatech.com/pathfinder)
alias pfo='open -a "Path Finder.app" "$PWD"'

# Section: [asciinema](https://asciinema.org)
alias cin="asciinema"
alias cina="asciinema rec --append"
alias cinc="asciinema cat"
alias cinp="asciinema play"
alias cinu="asciinema upload"
alias cine="asciinema_plus -e"

command -v "fzy" &> /dev/null && {
    alias fzyf="find . -type f | fzy"
    alias fzyd="find . -type d | fzy"
}

command -v "fish" &> /dev/null && [ -f "$HOME/.config/fish/functions/update.fish" ] && {
	alias update="fish -c \"update\""
}
