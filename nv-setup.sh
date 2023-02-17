#!/bin/sh

# ========================================================== #
# Script for automated neovim installation and configuration #
# ========================================================== #

install_nvim () {
	echo "Downloading latest nvim version"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
	
	echo "Installing latest nvim version"
	./nvim.appimage || {

	./nvim.appimage --appimage-extract
	./squashfs-root/AppRun --version
	} > /dev/null 2>&1
	
	echo "Removing instalation file"
	[ -f nvim.appimage ] && rm -rf nvim.appimage
}

install_conf_file () {
	[ ! -d ~/.config/nvim ] || { 
	
	echo "Creating .config/nvim directory"
	mkdir -p ~/.config/nvim
	}

	echo "Cloning `nvim-like-vscode` config file"
	[ -d ~/.config/nvim/nvim-like-vscode ] && rm -rf ~/.config/nvim/nvim-like-vscode
	git clone https://github.com/josethz00/neovim-like-vscode.git ~/.config/nvim/nvim-like-vscode

	echo "Copying `nvim-like-vscode` config file"
	cp ~/.config/nvim/nvim-config/init.vim ~/.config/nvim/

	echo "Removing unnecessary files"
	[ -d ~/.config/nvim/nvim-like-vscode ] && rm -rf ~/.config/nvim/nvim-like-vscode
}

install_nerd_fonts () {
	[ ! -d ~/.local/share/fonts ] || {
	
	echo "Creating fonts directory"
	mkdir -p ~/.local/share/fonts 
	}

	echo "Downloading Droid Sans Mono font from nerd fonts"
	( cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf )
}

install_vim_plug () {
	echo "Installing vim plug"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

# ==========================================================

# Download and install latest version of neovim
install_nvim

# Download and install nvim-like-vscode config file
install_conf_file

# Download and install nerd fonts to properly display icons 
install_nerd_fonts

# Download and install vim plug plugin manager
install_vim_plug

echo "Now open init.vim by running the command below:\n"
echo "nvim ~/.config/nvim/init.vim\n"
echo "Then type :PlugInstall to install all necessary plugins\n"