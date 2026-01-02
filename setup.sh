#!/bin/bash

REPO_URL="https://github.com/carl0xs/nvim-labs.git"
TARGET_DIR="$HOME/.config/nvim-labs"
FISH_CONF="$HOME/.config/fish/config.fish"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Clonando configurações para $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR"
else
    echo "Diretório $TARGET_DIR já existe."
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
    set -l conf (ls -d $HOME/.config/$NVIM_BASE_DIR/*/ | xargs -n 1 basename | fzf --prompt="Definir Padrão Permanente: " --height=20% --reverse)
    if test -n "$conf"
        echo "$conf" > "$NVIM_CONFIG_FILE"
        echo "Padrão definido para: $conf"
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

function nvim-labs-update
    set -l current_dir (pwd)
    if test -d $TARGET_DIR
        echo "Entrando em $TARGET_DIR..."
        cd $TARGET_DIR
        echo "Buscando atualizações..."
        git pull
        cd $current_dir
        echo "Atualização concluída."
    else
        echo "Erro: Diretorio $TARGET_DIR nao encontrado."
    end
end
# ------------------------------
EOF

echo "Done"
