#! /usr/bin/env bash

# Section: General
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cd..="cd .."
alias cdb="cd -"
alias c="clear"
alias h="history"
alias l="ls -alhT"
alias o="open"
alias p='pwd | tr -d "\r\n" | _copy_and_print'
alias du="ncdu -e --color dark"
alias l1="ls -A1 | _copy_and_print '\n'"
alias cat="bat"
alias man="gem man --system"
alias ping="prettyping --nolegend"
alias pss="pgrep -i -l -f"
alias rmde="find . -type d -empty -not -path '*.git*' -delete"
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

# Section: [Bash](https://www.gnu.org/software/bash)
alias bashe="$EDITOR $HOME/.config/bash/env.sh"
alias bashs="exec $SHELL"

# Section: Network
alias sshe="$EDITOR $HOME/.ssh/config"
alias key="open /Applications/Utilities/Keychain\ Access.app"
alias ipa='curl --silent checkip.dyndns.org | ag --only-matching "[0-9\.]+" | _copy_and_print'
alias dnsi="scutil --dns"
alias dnss="sudo dscacheutil -statistics"
alias dnsf="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && printf 'DNS cache cleared.\n'"
# Get local IP.
alias lip="ifconfig \
                    | grep 'inet addr' \
                    | grep -v '127.0.0.1' \
                    | cut -d: -f2 \
                    | cut -d' ' -f1"
# Get external IP.
alias xip="curl -s checkip.dyndns.org | grep -Eo "\[0-9\.]+""

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
	alias hb="brew"
	alias hbi="brew install"
	alias hbin="brew info"
	alias hbu="brew uninstall"
	alias hbl="brew list"
	alias hbs="brew search"
	alias hbsw="brew switch"
	alias hbup="brew update"
	alias hbug="brew upgrade"
	alias hbp="brew pin"
	alias hbpu="brew unpin"
	alias hbd="brew doctor"
	alias hbc="brew cleanup"
	alias hbsu="brew update && brew upgrade && brew cleanup"
}

# Section: [Git](http://git-scm.com)
command -v "hub" &> /dev/null && {
    alias git=hub
}
command -v "lazygit" &> /dev/null && {
    alias lg="lazygit"
}
alias gi="git init"
alias gcle="git config --local --edit"
alias gcge="git config --global --edit"
alias gcd="git config --show-origin"
alias gget="git config --get"
alias gset="git config --add"
alias gst="git status --short --branch"
alias gl='git log --graph --pretty=format:"$(_git_log_line_format)"'
alias glh="_git_commit_last | _copy_and_print"
alias glf='git fetch && git log --reverse --no-merges --pretty=format:"$(_git_log_line_format)" ..@{upstream}'
alias glg='git log --pretty=format:"$(_git_log_line_format)" --grep'
alias gls='git log --pretty=format:"$(_git_log_line_format)" -S'
alias glt='git for-each-ref --sort=taggerdate --color --format="%(color:yellow)%(refname:short)%(color:reset)|%(taggerdate:short)|%(color:blue)%(color:bold)%(*authorname)%(color:reset)|%(subject)" refs/tags | column -s"|" -t'
alias grl="git reflog"
alias gg="git grep"
alias guthors='git log --color --pretty=format:"%C(bold blue)%an%C(reset)" | sort | uniq -c | sort --reverse'
alias gd="git diff"
alias gdc="git diff --cached"
alias gdm="git diff origin/master"
alias gdw="git diff --color-words"
alias gdo='git diff --name-only | uniq | xargs $EDITOR'
alias gdt="git difftool"
alias gdtc="git difftool --cached"
alias gdtm="git difftool origin/master"
alias glame="git blame -M -C -C -C"
alias gbi="git bisect"
alias gbis="git bisect start"
alias gbib="git bisect bad"
alias gbig="git bisect good"
alias gbir="git bisect reset"
alias gbisk="git bisect skip"
alias gbil="git bisect log"
alias gbire="git bisect replay"
alias gbiv='git bisect visualize --reverse --pretty=format:"$(_git_log_line_format)"'
alias gbih="git bisect help"
alias gbt="git show-branch --topics"
alias gba="git branch --all"
alias gbn="_git_branch_name | _copy_and_print"
alias gm="git merge"
alias gcl="git clone"
alias gb="git switch"
alias gbb="git switch -"
alias gbm="git switch master"
alias ga="git add"
alias gau="git add --update"
alias gap="git add --patch"
alias gall="git add --all ."
alias gco="git commit"
alias gce='cat .git/COMMIT_EDITMSG | ag --invert-match "^\#.*" | pbcopy'
alias gatch="git commit --patch"
alias gca="git commit --all"
alias gcm="git commit --message"
alias gcam="git commit --all --message"
alias gcf="git commit --fixup"
alias gcs="git commit --squash"
alias gamend="git commit --amend"
alias gamendh="git commit --amend --no-edit"
alias gamenda="git commit --amend --all --no-edit"
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcps="git cherry-pick --skip"
alias gashc="git stash clear"
alias gnl="git notes list"
alias gns="git notes show"
alias gna="git notes add"
alias gne="git notes edit"
alias gnd="git notes remove"
alias gnp="git notes prune"
alias gf="git fetch"
alias gpu="git pull"
alias gpuo="git pull origin"
alias gpuom="git pull origin master"
alias gpuum="git pull upstream master"
alias grbo="git rebase --onto"
alias grbc="git rebase --continue"
alias grbd="git rebase --show-current-patch"
alias grbs="git rebase --skip"
alias grba="git rebase --abort"
alias grbt="git rebase --edit-todo"
alias gr="git restore"
alias grr="git rerere"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpn="git push --no-verify"
alias gpo="git push --set-upstream origin"
alias gpr="git push review master"
alias gps="git push stage stage:master"
alias gpp="git push production production:master"
alias gtag="git tag"
alias gtagv="git tag --verify"
alias gtags="git push --tags"
alias gwl="git worktree list"
alias gwp="git worktree prune"
alias ges="git reset"
alias grom="git fetch --all && git reset --hard origin/master" # Reset local branch to origin/master branch. UNRECOVERABLE!
alias gel="git rm"
alias gelc="git rm --cached" # Removes previously tracked file from index after being added to gitignore.
alias grev="git revert --no-commit"
alias glean="git clean -d --force"
alias acp="git add -A && git commit -v && git push"

# thefuck - Magnificent app which corrects your previous console command.
# see: https://github.com/nvbn/thefuck/wiki/Shell-aliases#bash
command -v thefuck &> /dev/null && {
    eval "$(thefuck --alias)"
}

# Section: [Tar](http://www.gnu.org/software/tar/tar.html)
alias bzc="tar --use-compress-program=pigz --create --preserve-permissions --bzip2 --verbose --file"
alias bzx="tar --extract --bzip2 --verbose --file"

# Section: [Ruby Gems](https://rubygems.org)
alias gemcr="$EDITOR ~/.gem/credentials"
alias geml="gem list"
alias gemi="gem install"
alias gemu="gem uninstall"
alias gemc="gem cleanup"
alias gems="gem server"
alias gemp="gem pristine"
alias geme="gem environment"
alias gemuc="gem update --system && gem update && gem cleanup"
alias gemcli="ag --depth=1 --files-with-matches --file-search-regex gemspec executables | xargs basename | cut -d. -f1 | sort | _copy_and_print '\n'"

# Section: [Ruby Gems Whois](https://github.com/jnunemaker/gemwhois)
alias gemw="gem whois"

# Section: [Silver Surfer](https://github.com/ggreer/the_silver_searcher)
alias agf="ag --hidden --files-with-matches --file-search-regex"

# Section: [direnv](http://direnv.net)
alias denva="direnv allow"
alias denvr="direnv reload"
alias denvs="direnv status"

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

command -v "composer" &> /dev/null && {
    alias ci='composer install'
    alias cr='composer remove'
    alias cls='composer list'
    alias cs='composer search'
    alias cu='composer self-update'
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

# Section: [Z](https://github.com/rupa/z)
alias ze="$EDITOR $_Z_DATA"

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
