 #!/bin/bash

# Configuration
CONFIG_DIR="$HOME/.config/nvim"
LOCAL_DIR="$HOME/.local"
LOCAL_BIN="$LOCAL_DIR/bin"
NVIM_VERSION="0.11.6"

echo "🚀 Starting Neovim configuration setup..."

# 1. Ensure local bin directory exists
mkdir -p "$LOCAL_BIN"

# Function to check Neovim version
check_nvim_version() {
    if command -v nvim >/dev/null 2>&1; then
        # Extract version number (e.g., 0.11.6)
        CURRENT_VERSION=$(nvim --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        if [ "$(printf '%s\n' "$NVIM_VERSION" "$CURRENT_VERSION" | sort -V | head -n1)" = "$NVIM_VERSION" ]; then
            echo "✅ Neovim $CURRENT_VERSION already installed (>= $NVIM_VERSION)."
            return 0
        fi
    fi
    return 1
}

# Function to install Neovim
install_nvim() {
    OS="$(uname -s)"
    ARCH="$(uname -m)"
    DOWNLOAD_URL=""

    echo "📦 Installing Neovim $NVIM_VERSION for $OS ($ARCH)..."

    case "$OS" in
        Darwin)
            if [ "$ARCH" = "arm64" ]; then
                DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-macos-arm64.tar.gz"
            else
                DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-macos-x86_64.tar.gz"
            fi
            ;;
        Linux)
            if [ "$ARCH" = "x86_64" ]; then
                DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux-x86_64.tar.gz"
            elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
                DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux-arm64.tar.gz"
            fi
            ;;
    esac

    if [ -z "$DOWNLOAD_URL" ]; then
        echo "❌ Error: Unsupported OS/Architecture: $OS/$ARCH"
        exit 1
    fi

    TEMP_DIR=$(mktemp -d)
    echo "⬇️ Downloading Neovim from $DOWNLOAD_URL..."
    if ! curl -LO --output-dir "$TEMP_DIR" "$DOWNLOAD_URL"; then
        echo "❌ Error: Failed to download Neovim."
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    echo "📂 Extracting Neovim..."
    tar -xzf "$TEMP_DIR"/*.tar.gz -C "$TEMP_DIR"

    # Neovim tarball structure: nvim-<os>-<arch>/bin/nvim etc.
    EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "nvim-*" | head -n 1)

    if [ -z "$EXTRACTED_DIR" ]; then
        echo "❌ Error: Could not find extracted Neovim directory."
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    echo "🚚 Installing to $LOCAL_DIR..."
    cp -r "$EXTRACTED_DIR"/* "$LOCAL_DIR/"

    rm -rf "$TEMP_DIR"
    echo "✅ Neovim $NVIM_VERSION installed successfully."
}

# Function to check LuaRocks version
check_luarocks_version() {
    if command -v luarocks >/dev/null 2>&1; then
        LUAROCKS_INFO=$(luarocks --version 2>&1)
        if echo "$LUAROCKS_INFO" | grep -q "Lua 5.1"; then
            echo "✅ LuaRocks targeting Lua 5.1 already installed."
            return 0
        fi
    fi
    return 1
}

# Function to install LuaRocks 5.1
install_luarocks() {
    OS="$(uname -s)"
    echo "📦 Installing LuaRocks targeting Lua 5.1 for $OS..."

    case "$OS" in
        Darwin)
            if command -v brew >/dev/null 2>&1; then
                echo "🍺 Using Homebrew to install LuaRocks..."
                brew install luarocks
            else
                echo "❌ Error: Homebrew not found. Please install Homebrew or install LuaRocks 5.1 manually."
                exit 1
            fi
            ;;
        Linux)
            echo "🐧 Installing LuaRocks and Lua 5.1 via package manager..."
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update && sudo apt-get install -y luarocks lua5.1 liblua5.1-0-dev
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y luarocks lua-devel
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y luarocks
            else
                echo "❌ Error: Unsupported Linux package manager. Please install LuaRocks 5.1 manually."
                exit 1
            fi
            ;;
    esac
}

# 2. Install Neovim if needed
if ! check_nvim_version; then
    install_nvim
fi

# 2b. Install LuaRocks 5.1 if needed
if ! check_luarocks_version; then
    install_luarocks
fi

# 3. Setup configuration directory
if [ -d "$CONFIG_DIR" ]; then
    echo "💾 Backing up existing configuration to ${CONFIG_DIR}.bak"
    rm -rf "${CONFIG_DIR}.bak"
    mv "$CONFIG_DIR" "${CONFIG_DIR}.bak"
fi

# 4. Clone the repository
echo "git Cloning repository..."
git clone https://github.com/DeeNA95/nvim-config.git "$CONFIG_DIR"

# 5. Add ~/.local/bin to PATH for the current session if not present
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    export PATH="$LOCAL_BIN:$PATH"
    echo "⚠️ Added $LOCAL_BIN to current session PATH."
fi

# 6. Install plugins using Lazy.nvim
echo "🔌 Installing plugins..."
nvim --headless "+Lazy! sync" +qa

echo "✨ Setup complete! Open nvim to check."
