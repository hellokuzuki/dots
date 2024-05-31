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

# install fzf.git
install_fzfgit() {
	# Clone fzf-git.sh repository
	git clone git@github.com:junegunn/fzf-git.sh.git ~/.fzf-git
	# Add the following line to your .zshrc to source fzf-git.sh
	echo 'source ~/.fzf-git/fzf-git.sh' >>~/.zshrc
	echo "fzf-git.sh installed and configured. You can now use it in your terminal."
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

# Check if ~/.fzf-git directory already exists
if [ -d ~/.fzf-git ]; then
	echo "fzf-git.sh is already installed in ~/.fzf-git."
else
	install_fzfgit
fi

# -- Use fd instead of fzf --
if [[ -z "${FZF_DEFAULT_COMMAND}" ]]; then
	export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
fi

if [[ -z "${FZF_CTRL_T_COMMAND}" ]]; then
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

if [[ -z "${FZF_ALT_C_COMMAND}" ]]; then
	export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
fi

if [[ -z "${FZF_DEFAULT_OPTS}" ]]; then
	export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
fi

FUNCTIONS='
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}
'

# Check if the functions are already defined in .zshrc
if grep -q "_fzf_compgen_path()" ~/.zshrc && grep -q "_fzf_compgen_dir()" ~/.zshrc; then
	echo "Functions already defined in ~/.zshrc"
else
	echo "$FUNCTIONS" >>~/.zshrc
	echo "Functions added to ~/.zshrc"
fi
