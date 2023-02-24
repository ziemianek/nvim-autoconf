#!/bin/sh
set -x -e
# ========================================================== #
# Script for automated neovim installation and configuration #
# ========================================================== #

install_nvim () {
	echo "Downloading latest nvim version"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage

	#echo "Copying nvim installation file to /usr/bin/nvim"
	#cp nvim.appimage /usr/bin/nvim
}

install_conf_file () {
	[ ! -d ~/.config/nvim ] && { 
	
	echo "Creating .config/nvim directory"
	mkdir -p ~/.config/nvim
	}

	echo "Copying config file to ~/.config/nvim"
	#USERNAME=`whoami`
	sudo cp init.vim ~/.config/nvim/
}

install_nerd_fonts () {
	[ ! -d ~/.local/share/fonts ] && {
	
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

./nvim.appimage --appimage-extract >> /dev/null 2>&1
./squashfs-root/AppRun --version

# Exposing nvim globally.
[ -d /squashfs-root ] && sudo rm -rf /squashfs-root
[ -d /usr/bin/nvim ] && sudo rm -rf /usr/bin/nvim
sudo mv squashfs-root /
sudo ln -s -f /squashfs-root/AppRun /usr/bin/nvim

echo "=========================================================="
echo "Now open init.vim by running the command below:"
echo "nvim ~/.config/nvim/init.vim"
echo "Then type :PlugInstall to install all necessary plugins"
echo "=========================================================="
