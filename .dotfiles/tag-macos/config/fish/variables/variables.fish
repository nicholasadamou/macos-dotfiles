# fish variables

# NOTE: There is probably a sexier nicer way to do this, but until I figure that out I am manually unset PATH
set -gx PATH

# Sets necessary PATH defaults
set -gx PATH $PATH /usr/local/bin /usr/bin /bin /sbin /usr/sbin /usr/local/sbin /sbin

# Homebrew configurations
# Make all homebrew casks and fonts be installed to a
# specific directory
set -gx HOMEBREW_CASK_OPTS "--appdir=/Applications --fontdir=/Library/Fonts"

# Dotfiles directory
set DOTFILES $HOME/"dotfiles"

# Add $HOME/dotfiles/bin to $PATH
if test -d $DOTFILES/bin
    set -gx PATH $PATH $DOTFILES/bin
end

# Theme
# set tacklebox_theme entropy

# Which modules would you like to load? (modules can be found in ~/.tackle/modules/*)
# Custom modules may be added to ~/.tacklebox/modules/
# Example format: set tacklebox_modules virtualfish virtualhooks

# Which plugins would you like to enable? (plugins can be found in ~/.tackle/plugins/*)
# Custom plugins may be added to ~/.tacklebox/plugins/
# Example format: set tacklebox_plugins python extract

# Change spacefish char
# see: https://spacefish.matchai.me/docs/Options.html#char
set SPACEFISH_CHAR_SYMBOL "\$"
