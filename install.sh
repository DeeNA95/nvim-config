#!/bin/bash

# Define the config directory
CONFIG_DIR="$HOME/.config/nvim"

echo "Setting up Neovim configuration..."

# Check if the directory already exists
if [ -d "$CONFIG_DIR" ]; then
    echo "Backing up existing configuration to ${CONFIG_DIR}.bak"
    mv "$CONFIG_DIR" "${CONFIG_DIR}.bak"
fi

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/DeeNA95/nvim-config.git "$CONFIG_DIR"

# Install plugins using Lazy.nvim
echo "Installing plugins..."
nvim --headless "+Lazy! sync" +qa

echo "Setup complete! Open nvim to check."
