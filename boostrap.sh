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
