#!/bin/bash

# Some packages aren't in dnf, but are in brew. Make sure to install those too.

# Make sure to install cargo first!
if ! command -v rustc --version >/dev/null 2>&1; then 
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi 

if ! command -v starship --version >/dev/null 2>&1; then
        curl -sS https://starship.rs/install.sh | sh
fi

if ! command -v zellij --version >/dev/null 2>&1; then
        cargo install --locked zellij
fi

# Install lua-language-server
LATEST=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep "browser_download_url" | grep linux-x64.tar.gz | cut -d '"' -f 4)

mkdir -p /tmp/lua-ls
cd /tmp/lua-ls
wget "$LATEST" -O lua-language-server.tar.gz
tar -xzf lua-language-server.tar.gz

sudo mv ./bin/lua-language-server /usr/local/bin/lua-language-server
