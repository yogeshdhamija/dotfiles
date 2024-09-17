if status is-interactive
    ######## translated from ~/.bashrc  ########
    set -gx LOCAL_CONFIG_OVERRIDES_LOADED ""
    set -gx LOCAL_CONFIG_OVERRIDES_NOT_LOADED ""
    if test -f ~/.config/fish/config.fish.local.loadbefore
        set -gx LOCAL_CONFIG_OVERRIDES_LOADED "~/.config/fish/config.fish.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_LOADED"
        source ~/.config/fish/config.fish.local.loadbefore
    else
        set -gx LOCAL_CONFIG_OVERRIDES_NOT_LOADED "~/.config/fish/config.fish.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
    end

    set -g fish_greeting

    #FZF config not necessary (added to fish commands&functions by dotfiles command)

    bind \cf forward-word
    bind \cb backward-word

    ######## translated from ~/.shellrc  ########
    set -gx DOTFILES_COMMAND 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    alias dotfiles="$DOTFILES_COMMAND"

    # Set up LESS
    set -gx LESS "-RXF"
    set -gx TIMEFMT "\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E"

    # Set up FZF to use silver searcher (ag)
    command -v ag > /dev/null && set -gx FZF_DEFAULT_COMMAND 'ag --follow --unrestricted --silent --filename-pattern ""'
    command -v ag > /dev/null && set -gx FZF_CTRL_T_COMMAND 'ag --follow --unrestricted --silent --filename-pattern ""'
    # Set up FZF to use ripgrep (rg)
    command -v rg > /dev/null && set -gx FZF_DEFAULT_COMMAND 'rg --follow --files --no-messages -uuu'
    command -v rg > /dev/null && set -gx FZF_CTRL_T_COMMAND 'rg --follow --files --no-messages -uuu'

    # Set up my code editor preferences, in worst-to-best order:
    command -v vim > /dev/null && set -gx EDITOR "vim"
    command -v nvim > /dev/null && set -gx EDITOR "nvim"
    command -v idea > /dev/null && set -gx EDITOR "idea --wait"
    command -v code > /dev/null && set -gx EDITOR "code -w"
    command -v zed > /dev/null && set -gx EDITOR "zed -w"

    if test -f ~/.shell_aliases
      source ~/.shell_aliases
    end

    # Set up Git preferences
    git config --global merge.conflictstyle diff3
    git config --global pull.ff only

    set -gx BAT_THEME "ansi"

    if test -f ~/.vimrc.local
        set -gx LOCAL_CONFIG_OVERRIDES_LOADED "~/.vimrc.local:$LOCAL_CONFIG_OVERRIDES_LOADED"
    else
        set -gx LOCAL_CONFIG_OVERRIDES_NOT_LOADED "~/.vimrc.local:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
    end
    if test -f ~/.vimrc.local.loadbefore
        set -gx LOCAL_CONFIG_OVERRIDES_LOADED "~/.vimrc.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_LOADED"
    else
        set -gx LOCAL_CONFIG_OVERRIDES_NOT_LOADED "~/.vimrc.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
    end
    if test -f ~/.config/fish/config.fish.local
        set -gx LOCAL_CONFIG_OVERRIDES_LOADED "~/.config/fish/config.fish.local:$LOCAL_CONFIG_OVERRIDES_LOADED"
        source ~/.config/fish/config.fish.local
    else
        set -gx LOCAL_CONFIG_OVERRIDES_NOT_LOADED "~/.config/fish/config.fish.local:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
    end

    starship init fish | source
end
