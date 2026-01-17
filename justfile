dotfiles := env_var('HOME') + "/.dotfiles"

# Show available recipes
default:
    @just --list

# Install all dotfiles
install: git vim fish starship ghostty zed
    @echo "Done!"

# Symlink git config
git:
    ln -sf {{dotfiles}}/gitconfig ~/.gitconfig
    ln -sf {{dotfiles}}/gitignore_global ~/.gitignore_global

# Symlink vim config
vim:
    ln -sf {{dotfiles}}/vimrc ~/.vimrc

# Symlink fish config
fish:
    mkdir -p ~/.config/fish
    ln -sf {{dotfiles}}/config/fish/config.fish ~/.config/fish/config.fish

# Symlink starship config
starship:
    mkdir -p ~/.config
    ln -sf {{dotfiles}}/config/starship.toml ~/.config/starship.toml

# Symlink ghostty config
ghostty:
    mkdir -p ~/.config/ghostty
    ln -sf {{dotfiles}}/config/ghostty/config ~/.config/ghostty/config

# Symlink zed config
zed:
    mkdir -p ~/.config/zed
    ln -sf {{dotfiles}}/config/zed/keymap.json ~/.config/zed/keymap.json
    ln -sf {{dotfiles}}/config/zed/settings.json ~/.config/zed/settings.json

# Skills management for AI coding agents
skills_dir := dotfiles / "agents" / "skills"
claude_dir := env_var('HOME') / ".claude" / "skills"
codex_dir := env_var('HOME') / ".codex" / "skills"

# List available skills
skills-list:
    @ls -1 {{skills_dir}}

# Symlink all skills to Claude Code (~/.claude/skills/)
skills-claude:
    @mkdir -p {{claude_dir}}
    @for skill in {{skills_dir}}/*/; do \
        name=$(basename "$skill"); \
        if [ -L "{{claude_dir}}/$name" ]; then \
            echo "skip: $name (already linked)"; \
        else \
            ln -s "$skill" "{{claude_dir}}/$name" && echo "link: $name"; \
        fi \
    done

# Symlink all skills to Codex (~/.codex/skills/)
skills-codex:
    @mkdir -p {{codex_dir}}
    @for skill in {{skills_dir}}/*/; do \
        name=$(basename "$skill"); \
        if [ -L "{{codex_dir}}/$name" ]; then \
            echo "skip: $name (already linked)"; \
        else \
            ln -s "$skill" "{{codex_dir}}/$name" && echo "link: $name"; \
        fi \
    done

# Symlink all skills to both Claude and Codex
skills-all: skills-claude skills-codex

# Remove skill symlinks from Claude
skills-unlink-claude:
    @for skill in {{skills_dir}}/*/; do \
        name=$(basename "$skill"); \
        if [ -L "{{claude_dir}}/$name" ]; then \
            rm "{{claude_dir}}/$name" && echo "unlink: $name"; \
        fi \
    done

# Remove skill symlinks from Codex
skills-unlink-codex:
    @for skill in {{skills_dir}}/*/; do \
        name=$(basename "$skill"); \
        if [ -L "{{codex_dir}}/$name" ]; then \
            rm "{{codex_dir}}/$name" && echo "unlink: $name"; \
        fi \
    done

# Remove all skill symlinks
skills-unlink: skills-unlink-claude skills-unlink-codex
