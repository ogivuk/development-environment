#!/bin/bash

source functions.sh

# set the background
if ! gsettings get org.gnome.desktop.background picture-uri | grep "file:////usr/share/backgrounds/Night_lights_by_Alberto_Salvia_Novella.jpg" >/dev/null
then
	echo "Changing background image..."
	gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/Night_lights_by_Alberto_Salvia_Novella.jpg
	echo "Changing background image... Done."
else
	echo "[OK] Background image already set."
fi

# enable multiple workspaces
echo "To enable multiple workspaces go to:"
echo "System Settings -> Personal -> Appearance -> Behavior -> Enable Workspaces"
read -p "Press Enter to continue with the rest." userInput

# configure shared VB folder access, if such exists
if grep -q vboxsf /etc/group; then
	if ! id -nG "$USER" | grep -qw "vboxsf"; then
		echo "Giving access to the shared VB folder"
		sudo adduser $USER vboxsf
	else
		echo "[OK] $USER already belongs to vboxsf"
	fi
fi

# prepare for installations
init

# install google chrome
if ! dpkg -s google-chrome-stable 1>/dev/null 2>/dev/null
then 
	echo "Installing Google Chrome…"
	echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
	wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo apt-get -qq update
	sudo apt-get -y install google-chrome-stable
	echo "Installing Google Chrome... Done."
	google-chrome
else
	echo "[OK] Google Chrome already installed."
fi

# Git
if alreadyInstalled git
then
	echo "[OK] Git already installed."
else
	installFromRepo "Git" "git"
	echo "Configuring Git…"
	read -p 'Git user.name: ' gitusername
	read -p 'Git user.email: ' gitemail
	git config --global user.name $gitusername
	git config --global user.email $gitemail
	echo "[Done] Configuring Git."
	# add ssh keys
	echo "Do not forget to copy your SSH keys to /home/$USER/.ssh/"
	read -p "Press Enter to continue with the rest." userInput
fi

# install Sublime
# see: https://www.sublimetext.com/docs/3/linux_repositories.html
if ! dpkg -s sublime-text 1>/dev/null 2>/dev/null
then
	echo "Installing Sublime…"
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-get -qq update
	sudo apt-get -y install sublime-text
	echo "Installing Sublime… Done."
	subl
else
	echo "[OK] Sublime already installed."
fi

# install VS Code
# see: https://code.visualstudio.com/docs/setup/linux
if ! dpkg -s code 1>/dev/null 2>/dev/null
then
	echo "Installing VS Code…"
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
	wget https://packages.microsoft.com/keys/microsoft.asc
	sudo apt-key add microsoft.asc
	rm microsoft.asc
	sudo apt-get -qq update
	sudo apt-get -y install code
	code --install-extension ms-vscode.cpptools
	code --install-extension donjayamanne.python
	code --install-extension ms-vscode.sublime-keybindings
	echo "Installing VS Code… Done."
	code
else
	echo "[OK] VS Code already installed."
fi

# G++
if alreadyInstalled "g++"
then
	echo "[OK] G++ already installed."
else
	installFromRepo "G++" "g++"
fi

# Python
if alreadyInstalled "python"
then
	echo "[OK] Python already installed."
else
	installFromRepo "Python" "python"
fi
if alreadyInstalled "python3"
then
	echo "[OK] Python3 already installed."
else
	installFromRepo "Python3" "python3"
fi
if alreadyInstalled "python3-pip"
then
	echo "[OK] Python3-Pip already installed."
else
	installFromRepo "Python3-Pip" "python3-pip"
fi

# CMake
if alreadyInstalled "cmake"
then
	echo "[OK] CMake already installed."
else
	installFromRepo "CMake" "cmake"
fi