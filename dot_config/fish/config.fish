if status is-interactive
    # Commands to run in interactive sessions can go here
end

# autojump
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

# aliases
alias vim="nvim"
alias ls="ls -laG"
alias cat="bat"
alias dev="cd ~/Desktop/projects"

# vim keybinds
fish_hybrid_key_bindings

# source pyenv
pyenv init - | source
