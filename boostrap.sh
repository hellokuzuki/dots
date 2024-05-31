#!/bin/bash

# Function to install zsh
install_zsh() {
        echo "Installing zsh..."
        sudo apt update
        sudo apt install -y zsh
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
        echo "Installing Oh My Zsh..."
        # Run the Oh My Zsh install script
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_neovim() {
        echo "Installing neovim"
        curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
}

# Function to install fd
install_fd() {
        echo "fd not found. Installing fd..."
        # Download the latest release tarball
        LATEST_FD_URL=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep "browser_download_url.*x86_64-unknown-linux-gnu.tar.gz" | cut -d : -f 2,3 | tr -d \")
        curl -LO $LATEST_FD_URL
        # Extract the tarball
        TAR_FILE=$(basename $LATEST_FD_URL)
        tar -xzf $TAR_FILE
        # Move the binary to /usr/local/bin
        FOLDER_NAME=$(basename $TAR_FILE .tar.gz)
        sudo mv $FOLDER_NAME/fd /usr/local/bin/
        # Clean up
        rm -rf $TAR_FILE $FOLDER_NAME
}

# Function to install fzf
install_fzf() {
        echo "fzf not found. Installing fzf..."
        # Clone the fzf repository
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        # Run the install script
        ~/.fzf/install
}

# Check if zsh is installed
if ! command -v zsh &>/dev/null; then
        install_zsh
else
        echo "zsh is already installed."
fi

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
        install_oh_my_zsh
else
        echo "Oh My Zsh is already installed."
fi

# Check if zsh is installed
if ! command -v nvim &>/dev/null; then
        install_neovim
else
        echo "nvim is already installed."
fi

# Check if fzf is installed
if command -v fzf >/dev/null 2>&1; then
        echo "fzf is already installed."
else
        install_fzf
fi

# Check if fd is installed
if command -v fd >/dev/null 2>&1; then
        echo "fd is already installed."
else
        install_fd
fi
