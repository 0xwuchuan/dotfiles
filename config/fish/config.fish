if status is-interactive
    # starship
    starship init fish | source

    # nvm
    set -x NVM_DIR ~/.nvm
    bass source ~/.nvm/nvm.sh --no-use

    zoxide init fish --cmd cd | source
    fzf --fish | source

    # eza aliases
    alias ls="eza"
    alias ll="eza -la --git"
    alias la="eza -a"
    alias lt="eza --tree --level=2"

    # Quick vim file finder
    function vf
        vim (fzf)
    end

    # Quick cd with preview
    function cdf
        cd (find . -type d | fzf --preview 'ls -la {}')
    end

    # Find and execute command
    function fexec
        set cmd (history | fzf)
        eval $cmd
    end
end

# PATH and environment (needed for scripts too)
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source
