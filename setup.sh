#!/bin/zsh

LOCAL_BIN="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

echo "Using temporary directory: $TMP_DIR"

echo "Installing: mise"
curl https://mise.run | sh
echo 'eval "$('$LOCAL_BIN'/mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc
mise trust mise/config.toml
mise dr
echo "Installed: $(mise --version)"

# Cleanup
echo "Cleaning up temporary directory: $TMP_DIR"
rm -rf "$TMP_DIR"

mise install