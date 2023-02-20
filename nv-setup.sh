#!/bin/sh

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
	[ ! -d ~/.config/nvim ] || { 
	
	echo "Creating .config/nvim directory"
	mkdir -p ~/.config/nvim
	}

	echo "Copying config file to ~/.config/nvim"
	cp init.vim ~/.config/nvim
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

./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

Exposing nvim globally.
mv squashfs-root /
ln -s /squashfs-root/AppRun /usr/bin/nvim

echo "==========================================================\n"
echo "Now open init.vim by running the command below:\n"
echo "nvim ~/.config/nvim/init.vim\n"
echo "Then type :PlugInstall to install all necessary plugins\n"
echo "==========================================================\n"
