# Installation

1. Run `sudo install_packages.sh`.

**Note**: package installation is optimized for Fedora and MacOS. 

# Installing LSPs

1. Install the language server globally according to its instructions.
2. Set up the LSP in .config/nvim/lua/lsp/init.lua.

# TODO

1. Set up Fedora-compatible package installation script
        - Font
1. Fedora OS configurations
        - Remove sound on volume key
        - Reverse scroll direction
        - keybinds - control/caps lock switch, is it possible to change option and command?
        - allow two finger scrolling

- PIA with network manager or openvpn

- change new vertical pane with markdown behavior
- remove SSH agent stuff from config.fish.tmpl
- firefox configuration if possible?

1. Get Polybar to set bars on the biggest monitor (currently hard-coded via `xrandr`, so single screen doesn't show Polybar)
1. Find another wallpaper for the second monitor
1. Create Polybar colorscheme for both wallpapers
1. Get Polybar icons working
1. Create better Polybar layout/modules
1. Rofi configuration
1. Set up an initial install script to get rid of .config/scripts  
1. Remove Homebrew on Linux and install dependencies through `sudo apt` instead (get rid of `snap`s as well)
1. Get rid of random transparencies in Picom 
