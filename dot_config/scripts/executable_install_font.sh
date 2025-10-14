#!/bin/bash

if [ -f /etc/fedora-release ]; then
        FONT="Hack"

        LATEST=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" \
                jq -r '.assets[] | select(.name | test(\"{FONT}\\.zip\")) | .browser_download_url')

        cd ~/Downloads

        wget "$LATEST" -O "${FONT}.zip"
        unzip -q "${FONT}.zip" -d "${FONT}"

        mkdir -p ~/.local/share/fonts
        mv "${FONT}"/*.ttf ~/.local/share/fonts

        fc-cache -fv
fi
