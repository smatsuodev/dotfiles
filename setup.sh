#!/bin/zsh

LOCAL_BIN="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

echo "Using temporary directory: $TMP_DIR"

echo "Installing: mise"
curl https://mise.run | sh
mise trust mise/config.toml
echo 'eval "$($LOCAL_BIN/mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc
mise dr
echo "Installed: $(mise --version)"

echo "Installing: aqua"
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.2/aqua-installer
echo "98b883756cdd0a6807a8c7623404bfc3bc169275ad9064dc23a6e24ad398f43d  aqua-installer" | sha256sum -c -
mv aqua-installer "$TMP_DIR/aqua-installer"
chmod +x "$TMP_DIR/aqua-installer"
$TMP_DIR/aqua-installer
echo "Installed: aqua"

# Cleanup
echo "Cleaning up temporary directory: $TMP_DIR"
rm -rf "$TMP_DIR"
