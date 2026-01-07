#!/bin/bash

REPO_URL="https://github.com/carl0xs/nvim-labs.git"
TARGET_DIR="$HOME/.config/nvim-labs"
FISH_CONF="$HOME/.config/fish/config.fish"
NVIM_DIR="$HOME/.config/nvim"
NVIM_BACKUP="$HOME/.config/nvim.backup"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Clone for $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR"
else
    echo "Directory $TARGET_DIR already exists."
fi

cat << 'EOF' >> "$FISH_CONF"

set -x NVIM_BASE_DIR "nvim-labs"
set -x NVIM_CONFIG_FILE "$HOME/.nvim_choice"

function nv
    set -l conf (ls -d $HOME/.config/$NVIM_BASE_DIR/*/ | xargs -n 1 basename | fzf --prompt="Selecionar Configuração: " --height=20% --reverse)
    if test -n "$conf"
        env NVIM_APPNAME="$NVIM_BASE_DIR/$conf" nvim $argv
    end
end

function nv-set
    set -l conf (ls -d $HOME/.config/$NVIM_BASE_DIR/*/ | xargs -n 1 basename | fzf --prompt="Definir como ~/.config/nvim: " --height=20% --reverse)
    if test -n "$conf"
        echo "$conf" > "$NVIM_CONFIG_FILE"
        echo "Default set: $conf"

        set -l nvim_dir "$HOME/.config/nvim"
        set -l nvim_backup "$HOME/.config/nvim.backup"
        set -l choice_dir "$HOME/.config/$NVIM_BASE_DIR/$conf"

        if test -d "$nvim_dir"
            rm -rf "$nvim_backup"
            mkdir -p "$nvim_backup"
            rsync -a --delete "$nvim_dir"/ "$nvim_backup"/
        end

        rm -rf "$nvim_dir"
        mkdir -p "$nvim_dir"

        rsync -a "$choice_dir"/ "$nvim_dir"/

        echo "Now using: $conf"
    end
end

function nvim
    if test -f "$NVIM_CONFIG_FILE"
        set -l current_config (cat "$NVIM_CONFIG_FILE")
        env NVIM_APPNAME="$NVIM_BASE_DIR/$current_config" command nvim $argv
    else
        command nvim $argv
    end
end
# ------------------------------
EOF

echo "Done"
